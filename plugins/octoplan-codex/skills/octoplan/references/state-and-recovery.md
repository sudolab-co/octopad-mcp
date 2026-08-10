# Octoplan state and recovery

Persist only what a fresh supervisor needs to identify the approved plan, avoid duplicate writes or actors, respect authority, and resume targeted work. Octopad is not a transaction log and the saved state is not a mirror of every field.

## Contents

- [Coordination task](#coordination-task)
- [Minimal state](#minimal-state)
- [Material revision](#material-revision)
- [Write receipts](#write-receipts)
- [Native action intents](#native-action-intents)
- [Targeted recovery](#targeted-recovery)
- [Strict pauses](#strict-pauses)

## Coordination task

Keep exactly one active coordination task per plan in the intended work stream. Before creating it, list the stream once and adopt the unique task carrying the plan ID. Its description uses the normal server-required task shape:

```markdown
**Why**
Keep the approved plan resumable without duplicating work or bypassing gates.

**What**
Hold the minimal Octoplan state for this plan. Execution details remain in the linked tasks and source systems.

**Done when**
The plan is completed with every protected gate resolved, or superseded with any remaining gate explicitly handed off.

OCTOPLAN_STATE_BEGIN
<JSON object>
OCTOPLAN_STATE_END
```

Set `agent_executable: false`. Use `expected_updated_at` on every state-changing update. A failed concurrency guard causes a reread and reconciliation, never an inferred overwrite.

Append recovery events as task comments with one UUID `idempotency_key` per logical event. Reuse that UUID only when retrying the same comment. Keep comments below the connector limit and do not copy entire task payloads.

## Minimal state

Persist this core object. Ordinary JSON formatting is accepted; key order and whitespace are irrelevant.

```json
{
  "schema": "octoplan-plan-v2",
  "plan_id": "<stable UUID>",
  "proposed_revision": 1,
  "approved_revision": null,
  "status": "awaiting-approval",
  "organization_id": "<ID>",
  "workspace_id": "<ID>",
  "work_stream_id": "<ID>",
  "coordination_task_id": "<ID>",
  "outcome": {"candidate_ref": "E01", "global_evidence_ref": null, "global_evidence_revision": null},
  "delivery_mode": "review-before-delivery",
  "execution_authority": null,
  "task_ids": {"E01": "<ID>", "E02": "<ID>", "H01": "<ID only for human-task gates>"},
  "desired_dependencies": [
    {"task_ref": "E02", "depends_on_ref": "E01", "rationale": "<why>"}
  ],
  "review": {
    "revision": 1,
    "verdict": "PASS",
    "reviewer_ref": "<native task or artifact reference>",
    "evidence_ref": "<review record reference>"
  },
  "supervisor": null,
  "creation_grant": {
    "source_ref": "<authorizing user-message reference>",
    "plan_id": "<same plan ID>",
    "project_id": "<ID or null for explicit projectless>",
    "directory_name": "<explicit projectless directory or null>",
    "environments": ["local", "worktree"],
    "roles": ["supervisor", "planner", "executor", "reviewer", "specialist-reviewer", "recovery", "follow-up"],
    "actions": ["create", "message", "archive"],
    "adopted_session_refs": []
  },
  "budgets": {"max_active_child_actors": 3, "max_wip": 3, "max_correction_loops": 2, "max_review_actors": 2, "max_review_checks": 8, "batch_size": 3},
  "counters": {"active_child_actors": 0, "wip": 0, "correction_loops": {}, "review_actors": 0, "review_checks": 0},
  "protected_gates": [
    {"gate_key": "<stable key>", "kind": "human-review|merge", "location": "embedded", "delivery_task_ref": "E01", "human_task_ref": null, "owner": "<role>", "target_effect": "<effect>", "evidence_ref": null, "state": "pending|satisfied|rejected", "resume_predicate": "<predicate>"},
    {"gate_key": "<stable key>", "kind": "deployment", "location": "human-task", "delivery_task_ref": "E01", "human_task_ref": "H01", "owner": "<role>", "target_effect": "<effect>", "evidence_ref": null, "state": "pending|satisfied|rejected", "resume_predicate": "<predicate>"}
  ],
  "actors": {},
  "native_action_intents": [],
  "native_action_receipts": [],
  "resume": {"last_event_id": null, "pending_operation_keys": []}
}
```

`draft` and `awaiting-approval` keep `approved_revision`, `execution_authority`, and `supervisor` null. Draft review may be absent; awaiting approval requires PASS on `proposed_revision`. An exact go guarded by `expected_updated_at` sets `approved_revision`, clears `proposed_revision`, records matching authority, and enters `approved`; no launch is legal earlier. A replan keeps the current approved revision/authority while `proposed_revision` and `proposed_review` describe the candidate delta.

Use only granted actions, roles, and environments; the example is vocabulary. Projectless execution is explicit and uses `[null]`. `review-before-delivery` pairs only with exact-revision `revision-approval`; `autonomous-delivery` pairs with `bounded-outcome`. Neither authorizes a gate. A grant is plan-scoped/source-bound; adopted or user sessions require explicit matching provenance. Review/merge are embedded on an E task; another gate may use one Hxx.

Persist useful budget ceilings and authoritative counters only. Token, tool-call, compaction, time, or provider-cost fields are forbidden unless their telemetry is directly observable. A ceiling never permits skipping a required check or protected gate.

Actor records carry role/task, project/environment, creation or adopted provenance, lifecycle flags, previous state, and transition evidence. They use `active -> awaiting-review -> correction-needed | handoff-pending -> terminal-reconciled -> archived`. Terminal requires report, transfer receipt, and supervisor reconciliation. Archive is reversible only after PASS/abandon/supersession with no correction, recheck, human wait, or handoff. Keep planner, supervisor, and waiters visible. Record `archive_receipt`; archive incidents remain pending/reconciled but do not block delivery.

The plan ID plus approved integer revision is the execution identity. The state does not contain or require a byte fingerprint, canonical JSON digest, exhaustive Decision/Question snapshot, or full-state equality assertion.

## Material revision

Increment the approved revision only when a reviewed change affects result, scope, success evidence, task meaning, dependency or parallelism, protected gate, owner, route/model bound, authority boundary, or acceptance.

Do not increment it for formatting, display names, descriptions clarified without changing meaning, reordered MCP prose, links, response shapes, runtime receipts, progress, artifacts, or status changes.

During a material replan, set `replanning`, stop affected claims, and let independent claimed work finish or fence it. Draft the next revision, map artifacts, review the delta, verify receipts/edges, then replace the approved revision under the guard. Old PASS never transfers. A grant remains usable only when its same plan, source, project, environments, roles, and actions cover the revision; never widen it silently.

## Write receipts

Use one stable operation key per intended write, for example `<plan-id>:r1:task:E01` or `<plan-id>:r1:edge:E02:E01`. Before a write without server-side idempotency, persist that key in `resume.pending_operation_keys`; before the work stream or coordination task exists, emit `OCTOPLAN_WRITE_INTENT <operation-key>` in the durable planning transcript. Record one compact journal event per item and clear the pending key only after confirmation:

```text
OCTOPLAN_RECEIPT {"operation_key":"...","entity":"task","ref":"E01","id":"...","result":"confirmed","evidence":"write-response|targeted-read"}
```

An explicit returned item ID or success receipt confirms the item. `structuredContent` is useful when present but never mandatory. If the response is incomplete, malformed for display, or missing one item, add a warning and verify only uncertain items by bounded stream list, internal operation marker, stable task reference, returned ID, targeted `get`, or exact dependency inspection.

For a timed-out batch, assume neither failure nor success. List once, match each stable ref, get only ambiguous candidates, and produce per-item receipts. Retry only writes proven absent, with their original operation keys. Never replay the whole batch because one item is unclear. A still-ambiguous item remains pending and blocks only dependent work while reconciliation continues.

## Native action intents

Before every create, message, or archive, persist one intent with stable `action_key`; action; target; correlated `effect_ref` or payload reference (never copied secret/private payload); plan/revision; project/environment/role; grant source/action; supervisor epoch; and `pending|confirmed|ambiguous|failed` result. After success, persist a receipt and clear the pending key.

After crash, timeout, or ambiguous output, list/read and reconcile observed state before acting; never blind replay. For create, match creation key plus role packet and adopt one exact actor. For message, put the action key/effect reference in the relay, then inspect the target thread and dedupe the correlated effect. For archive, inspect current visibility/archive state and record whether the intended target changed. Retry the same action key only after authoritative evidence proves the effect absent; conflicts pause that action's branch.

Only the current supervisor epoch may activate or perform an action. A takeover fences the owner and increments epoch. Receipts identify action key, target, observed effect/state, grant source, epoch, result, and evidence; they never copy private payloads.

## Targeted recovery

On resume:

1. refresh the exact native task, organization/workspace session, work stream, coordination task, and current task IDs;
2. verify plan ID, proposed/approved revision, state, supervisor epoch, grant, gates, and pending keys;
3. reconcile only pending writes/actions, claimed work, reviews, and gates;
4. re-read full task or source content only when its meaning, revision, verifier, or authority may have changed;
5. wake the unique dedicated resumable supervisor or fence and replace it with evidence; never create a second plausible owner.

Presentation drift is a warning. A receipt with an ID is enough to target verification. Do not require every Decision, Question, task, or comment to be re-rendered exactly before useful work continues.

## Strict pauses

Pause the affected branch only for a wrong or ambiguous organization/workspace/stream/project; an unreconcilable duplicate or bootstrap/creation dispatch ambiguity; absent real authority; a write proven missing after targeted recovery and not safely retryable; a conflict with the live approved revision; or a protected gate/material human decision.

Stop the whole plan only when shared identity/authority is invalid or no safe agent-owned frontier remains. Tool unavailability, missing `structuredContent`, an incomplete response, a stale display field, or a recoverable incident is not by itself a human blocker.
