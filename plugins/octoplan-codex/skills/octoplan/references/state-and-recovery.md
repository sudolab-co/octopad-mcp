# Octoplan state and recovery

Persist only what a fresh supervisor needs to identify the approved brief and plan, honor the latest user intent, avoid duplicate writes or actors, respect authority and checkpoints, and resume targeted work. Octopad is not a transaction log and the saved state is not a mirror of every field.

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
Keep the approved plan resumable without duplicating work or bypassing checkpoints.

**What**
Hold the minimal Octoplan state for this plan. Execution details remain in the linked tasks and source systems.

**Done when**
The plan is completed with every protected checkpoint resolved, or superseded with any remaining checkpoint explicitly handed off.

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
  "schema": "octoplan-plan-v3",
  "plan_id": "<stable UUID>",
  "revision": 1,
  "proposed_revision": null,
  "status": "planned|active",
  "organization_id": "<ID>",
  "workspace_id": "<ID>",
  "work_stream_id": "<ID>",
  "coordination_task_id": "<ID>",
  "brief": {
    "source_ref": "<request reference>",
    "approval_ref": "<approved creation-brief reference>",
    "tracker_ref": "<work-stream tracker reference>",
    "review_cadence": "progressive|final",
    "execution_scope": "plan-only|deliver-authorized",
    "octopad_write_classes": ["work-stream", "tracker", "task", "dependency", "decision", "question", "comment", "coordination-state"],
    "native_actions": ["create", "message", "archive"],
    "native_roles": ["supervisor", "planner", "executor", "reviewer", "specialist-reviewer", "recovery", "follow-up"],
    "project_id": "<ID or null for explicit projectless>",
    "directory_name": "<explicit projectless directory or null>",
    "native_environments": ["local", "worktree"],
    "child_route": "native-task/worktree",
    "effects": ["<bounded disclosed effects>"]
  },
  "outcome": {"candidate_ref": "E01", "global_evidence_ref": null, "global_evidence_revision": null},
  "task_ids": {"E01": "<ID>", "E02": "<ID>", "H01": "<ID only for separately owned human work>"},
  "brief_records": {
    "decisions": {"D01": {"id": "<ID>", "receipt_ref": "<receipt>"}},
    "questions": {"Q01": {"id": "<ID>", "receipt_ref": "<receipt>"}}
  },
  "desired_dependencies": [
    {"task_ref": "E02", "depends_on_ref": "E01", "rationale": "<why>"}
  ],
  "review": {
    "revision": 1,
    "verdict": "PASS",
    "reviewer_ref": "<native task or artifact reference>",
    "evidence_ref": "<review record reference>"
  },
  "supervisor": {
    "thread_ref": "<current user task by default>",
    "epoch": 1,
    "mode": "current-task|dedicated-handoff",
    "goal": {"required": true, "owner_thread_ref": "<same thread>", "objective_ref": "<approved outcome>", "origin": "created|adopted", "evidence_ref": "<create/get receipt>", "state": "active"}
  },
  "runtime": {
    "minimum_version": "13.0.0",
    "loaded_version": "13.0.0",
    "installed_version": "13.0.0",
    "adoption_ref": null
  },
  "authority": {
    "source_ref": "<approved brief or later directive>",
    "delivery": true,
    "project_id": "<ID or null for explicit projectless>",
    "directory_name": "<explicit projectless directory or null>",
    "environments": ["local", "worktree"],
    "roles": ["supervisor", "planner", "executor", "reviewer", "specialist-reviewer", "recovery", "follow-up"],
    "actions": ["create", "message", "archive"],
    "octopad_write_classes": ["work-stream", "tracker", "task", "dependency", "decision", "question", "comment", "coordination-state"],
    "child_route": "native-task/worktree",
    "effects": ["<bounded disclosed effects>"],
    "adopted_session_refs": []
  },
  "intent": {"revision": 1, "latest_user_directive_ref": "<reference>", "superseded_effect_keys": []},
  "budgets": {"max_active_child_actors": 3, "max_wip": 3, "max_correction_loops": 2, "max_review_actors": 2, "max_review_checks": 8, "batch_size": 3},
  "counters": {"active_child_actors": 0, "wip": 0, "correction_loops": {}, "review_actors": 0, "review_checks": 0},
  "human_checkpoints": [
    {"checkpoint_key": "<stable key>", "kind": "methodology|secret|access-grant|external-spend|destructive-effect|review|merge|migration-application|deployment|publication|acceptance", "source": "user|organization|planner-recommendation", "mandatory": true, "owner": "<person or role>", "subject": "<decision>", "timing": "<when>", "reason": "<why human>", "blocked_task_refs": ["E02"], "safe_continuation_refs": ["E03"], "expected_decision": "<decision shape>", "state": "pending|satisfied|rejected", "evidence_ref": null, "resume_predicate": "<predicate>"}
  ],
  "actors": {},
  "native_action_intents": [],
  "native_action_receipts": [],
  "heartbeat": null,
  "resume": {"last_event_id": null, "pending_operation_keys": []}
}
```

Before approval, the brief exists only in the user conversation and Octoplan performs no Octopad write. After approval and plan-review PASS, `planning` covers reconciled creation, then `planned` means the reviewed graph exists. `plan-only` keeps `supervisor.goal.required=false` and stops at `planned`; authorized delivery records the current supervisor and enters `active` only after the Goal exists. A replan keeps the current revision/authority while `proposed_revision` and `proposed_review` describe the candidate delta.

The authority source must equal the approved brief reference, and its actions, roles, environments, Octopad write classes, child route, and effects must exactly match the brief's normalized disclosure. The vocabulary is internal, not user-facing command syntax. Projectless execution is explicit. Later widening requires a revised brief, reviewed plan revision, and new source reference. Adopted sessions require matching provenance. User review cadence never authorizes a protected effect or removes an organization checkpoint. Review/merge remain embedded on an E task; a separately owned human deliverable may use Hxx.

Persist useful budget ceilings and authoritative counters only. Token, tool-call, compaction, time, or provider-cost fields are forbidden unless their telemetry is directly observable. A ceiling never permits skipping a required check or protected checkpoint.

Actor records carry role/task, project/environment, creation or adopted provenance, lifecycle flags, previous state, and transition evidence. They use `active -> awaiting-review -> correction-needed | handoff-pending -> terminal-reconciled -> archived`. Terminal requires report, transfer receipt, and supervisor reconciliation. Archive is reversible only after PASS/abandon/supersession with no correction, recheck, human wait, or handoff. Keep planner, supervisor, and waiters visible. Record `archive_receipt`; archive incidents remain pending/reconciled but do not block delivery.

The plan ID plus integer plan revision identifies task meaning. `intent.revision` orders user instructions independently so an in-envelope pause, cancellation, priority, or “do not send” propagates without inventing a material replan. The state does not require a byte fingerprint, exhaustive Decision/Question snapshot, or full-state equality assertion.

## Material revision

Increment the plan revision only when a reviewed change affects result, scope, success evidence, task meaning, dependency or parallelism, human checkpoint, owner, route/model bound, authority boundary, or acceptance.

Do not increment it for formatting, display names, descriptions clarified without changing meaning, reordered MCP prose, links, response shapes, runtime receipts, progress, artifacts, or status changes.

For every user directive, first increment `intent.revision` under `expected_updated_at`, store its source and superseded effect keys, then notify affected actors. They reread live state at their next safe boundary before any external effect. If the directive changes material plan meaning, set `replanning`, stop affected claims, draft the next revision, map artifacts, review the delta, verify receipts/edges, then replace the revision under the guard. Old PASS never transfers. Existing authority survives only when its source, plan, project, roles, actions, risks, and effects still cover the change.

## Write receipts

Use one stable operation key per intended write, for example `<plan-id>:r1:task:E01` or `<plan-id>:r1:edge:E02:E01`. Before a write without server-side idempotency, persist that key in `resume.pending_operation_keys`; before the work stream or coordination task exists, emit `OCTOPLAN_WRITE_INTENT <operation-key>` in the durable planning transcript. Record one compact journal event per item and clear the pending key only after confirmation:

```text
OCTOPLAN_RECEIPT {"operation_key":"...","entity":"task","ref":"E01","id":"...","result":"confirmed","evidence":"write-response|targeted-read"}
```

An explicit returned item ID or success receipt confirms the item. `structuredContent` is useful when present but never mandatory. If the response is incomplete, malformed for display, or missing one item, add a warning and verify only uncertain items by bounded stream list, internal operation marker, stable task reference, returned ID, targeted `get`, or exact dependency inspection.

For a timed-out batch, assume neither failure nor success. List once, match each stable ref, get only ambiguous candidates, and produce per-item receipts. Retry only writes proven absent, with their original operation keys. Never replay the whole batch because one item is unclear. A still-ambiguous item remains pending and blocks only dependent work while reconciliation continues.

## Native action intents

Before every create, message, or archive, persist one intent with stable `action_key`; action; target; correlated `effect_ref` or payload reference (never copied secret/private payload); plan and intent revisions; project/environment/role; authority source/action; supervisor epoch; and `pending|confirmed|ambiguous|failed` result. Every effective receipt joins exactly one intent and matches its action, target/effect, authority source, plan/intent revisions, and epoch; orphan, duplicate, stale, or mismatched receipts never advance work. After success, persist the matching receipt and clear the pending key. Never message an actor about a revised instruction before the durable intent revision exists.

After crash, timeout, or ambiguous output, list/read and reconcile observed state before acting; never blind replay. For create, match creation key plus role packet and adopt one exact actor. For message, put the action key/effect reference in the relay, then inspect the target thread and dedupe the correlated effect. For archive, inspect current visibility/archive state and record whether the intended target changed. Retry the same action key only after authoritative evidence proves the effect absent; conflicts pause that action's branch.

Only the current supervisor epoch may activate or perform an action. A takeover fences the owner and increments epoch. Receipts identify action key, target, observed effect/state, authority source, epoch, result, and evidence; they never copy private payloads.

## Targeted recovery

On resume:

1. refresh the exact native task, organization/workspace session, work stream, coordination task, and current task IDs;
2. verify plan ID/revision, intent revision, status, supervisor/Goal owner, authority, checkpoints, runtime version, heartbeat, and pending keys;
3. adopt a compatible installed v3 update, then reconcile only pending writes/actions, claimed work, reviews, checkpoints, and open incident keys through the runtime identity hierarchy where relevant;
4. re-read full task or source content only when its meaning, revision, verifier, or authority may have changed;
5. resume the current-task supervisor or, for an evidenced dedicated handoff, wake the unique destination after proving the source loop fenced; never create a second plausible owner.

Presentation drift is a warning. A receipt with an ID is enough to target verification. Do not require every Decision, Question, task, or comment to be re-rendered exactly before useful work continues.

For each incident, append one event with stable key, failed predicate, classification, evidence, actor/mutation state, remaining budget, remedies/receipts, disposition, and resume/stop predicate. One diagnosis plus two distinct remedies is the default ceiling unless the plan sets less; rewording, waking, or replacing a reasoning actor never resets it.

## Strict pauses

Pause the affected branch only for a wrong organization/workspace/stream; a project/repository mismatch proved by the identity hierarchy or identity still unresolved after bounded recovery; an unreconcilable duplicate or bootstrap/creation dispatch ambiguity; absent real authority; a write proven missing after targeted recovery and not safely retryable; a conflict with live plan/intent revision; or a pending human checkpoint/material decision.

Stop the whole plan only when shared identity/authority is invalid or no safe agent-owned frontier remains. Tool unavailability, missing `structuredContent`, incomplete output, `projectId=null`, stale display metadata, or a recoverable incident is not by itself a human blocker. Diagnose and try bounded safe alternatives first; never turn passive observation into completion or a permanent block.
