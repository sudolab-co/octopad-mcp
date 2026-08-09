# Octoplan state and recovery

Persist only what a fresh supervisor needs to identify the approved plan, avoid duplicate writes or actors, respect authority, and resume targeted work. Octopad is not a transaction log and the saved state is not a mirror of every field.

## Contents

- [Coordination task](#coordination-task)
- [Minimal state](#minimal-state)
- [Material revision](#material-revision)
- [Write receipts](#write-receipts)
- [Creation intents](#creation-intents)
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
The plan is completed or superseded and every protected gate is resolved or handed off.

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
  "schema": "octoplan-plan-v1",
  "plan_id": "<stable UUID>",
  "approved_revision": 1,
  "status": "approved|active|replanning|waiting-human|paused|completed|superseded",
  "organization_id": "<ID>",
  "workspace_id": "<ID>",
  "work_stream_id": "<ID>",
  "coordination_task_id": "<ID>",
  "delivery_mode": "review-before-delivery",
  "execution_authority": {
    "source_ref": "<authorizing user-message reference>",
    "kind": "revision-approval",
    "approved_revision": 1,
    "outcome_boundary_ref": null
  },
  "task_ids": {"E01": "<ID>", "H01": "<ID>"},
  "desired_dependencies": [
    {"task_ref": "E02", "depends_on_ref": "E01", "rationale": "<why>"}
  ],
  "review": {
    "revision": 1,
    "verdict": "PASS",
    "reviewer_ref": "<native task or artifact reference>",
    "evidence_ref": "<review record reference>"
  },
  "supervisor": {"owner_thread_id": null, "epoch": 1},
  "creation_grant": {
    "source_ref": "<authorizing user-message reference>",
    "project_id": "<ID or null for explicit projectless>",
    "directory_name": "<explicit projectless directory or null>",
    "environments": ["local", "worktree"],
    "roles": ["supervisor", "planner", "executor", "reviewer", "specialist-reviewer", "recovery", "follow-up"]
  },
  "protected_gates": [
    {"gate_key": "<stable key>", "task_ref": "H01", "kind": "<kind>", "state": "pending|satisfied|rejected"}
  ],
  "resume": {"last_event_id": null, "pending_operation_keys": []}
}
```

Use only roles and environments actually granted; the example is a vocabulary, not a default grant. Projectless execution must be explicit and uses `[null]` for environments. `review-before-delivery` pairs only with `revision-approval` for the exact revision; `autonomous-delivery` pairs only with `bounded-outcome`, sets `approved_revision` to `null`, and names the confirmed outcome boundary. Neither authorizes a protected gate. `task_ids` includes every essential delivery task and protected human task, with one distinct native task ID per ref. Every protected occurrence has one unique gate key and one distinct human task. Keep task content, display names, descriptions, routes, source prose, runtime status, and artifacts in their owning records rather than duplicating them here.

The plan ID plus approved integer revision is the execution identity. The state does not contain or require a byte fingerprint, canonical JSON digest, exhaustive Decision/Question snapshot, or full-state equality assertion.

## Material revision

Increment the approved revision only when a reviewed change affects result, scope, success evidence, task meaning, dependency or parallelism, protected gate, owner, route/model bound, authority boundary, or acceptance.

Do not increment it for formatting, display names, descriptions clarified without changing meaning, reordered MCP prose, links, response shapes, runtime receipts, progress, artifacts, or status changes.

During a material replan, set status to `replanning`, stop new claims on affected tasks, and let demonstrably independent claimed work finish or fence it. Draft the next integer revision, map reusable artifacts explicitly, review the changed plan proportionately, verify essential receipts/edges, then replace the approved revision under the concurrency guard. Old review PASS and task PASS records do not transfer. The plan-scoped creation grant remains usable only when its same project, environments, and finite roles still cover the new revision; never widen it silently.

## Write receipts

Use one stable operation key per intended write, for example `<plan-id>:r1:task:E01` or `<plan-id>:r1:edge:E02:E01`. Before a write without server-side idempotency, persist that key in `resume.pending_operation_keys`; before the work stream or coordination task exists, emit `OCTOPLAN_WRITE_INTENT <operation-key>` in the durable planning transcript. Record one compact journal event per item and clear the pending key only after confirmation:

```text
OCTOPLAN_RECEIPT {"operation_key":"...","entity":"task","ref":"E01","id":"...","result":"confirmed","evidence":"write-response|targeted-read"}
```

An explicit returned item ID or success receipt confirms the item. `structuredContent` is useful when present but never mandatory. If the response is incomplete, malformed for display, or missing one item, add a warning and verify only uncertain items by bounded stream list, internal operation marker, stable task reference, returned ID, targeted `get`, or exact dependency inspection.

For a timed-out batch, assume neither failure nor success. List once, match each stable ref, get only ambiguous candidates, and produce per-item receipts. Retry only writes proven absent, with their original operation keys. Never replay the whole batch because one item is unclear. A still-ambiguous item remains pending and blocks only dependent work while reconciliation continues.

## Creation intents

Before every native create call, list/read plausible native matches, then append one durable intent containing a stable creation key `<plan-id>:r<revision>:<role>:<task-ref>:<attempt>`; organization, workspace, stream and task; approved revision; role, model, effort, project/environment and capability; creator supervisor epoch; and covering grant source. Adopt one pre-existing exact key/packet match instead of creating; pause on conflicting or multiple matches.

Call native create at most once for that key. Put the creation key and role packet in the first prompt; use a readable display title separately. A direct thread ID, pending `clientThreadId`, empty response, timeout, or crash all enter reconciliation. List/read native tasks and match the creation key plus material role packet. One exact match may activate; several, a wrong project, or conflicting material packet pauses. Zero matches stay pending through one bounded setup window and a second list/read. If still zero, pause that branch as `creation-dispatch-ambiguous`: resume only when the exact actor appears or authoritative native evidence proves no dispatch occurred, allowing the old intent to be retired and a fresh key created once. Never retry blindly.

Only the current supervisor epoch may activate or record an actor. A takeover increments the epoch after fencing the previous owner; old actors cannot advance state.

## Targeted recovery

On resume:

1. refresh the exact native task, organization/workspace session, work stream, coordination task, and current task IDs;
2. verify plan ID, approved revision, state, supervisor epoch, creation grant, open gates, and pending operation keys;
3. reconcile only pending writes, actor intents, claimed work, reviews, and gates;
4. re-read full task or source content only when its meaning, revision, verifier, or authority may have changed;
5. wake the unique resumable supervisor or fence and replace it with evidence; never create a second plausible owner.

Presentation drift is a warning. A receipt with an ID is enough to target verification. Do not require every Decision, Question, task, or comment to be re-rendered exactly before useful work continues.

## Strict pauses

Pause the affected branch only for a wrong or ambiguous organization/workspace/stream/project; an unreconcilable duplicate or bootstrap/creation dispatch ambiguity; absent real authority; a write proven missing after targeted recovery and not safely retryable; a conflict with the live approved revision; or a protected gate/material human decision.

Stop the whole plan only when shared identity/authority is invalid or no safe agent-owned frontier remains. Tool unavailability, missing `structuredContent`, an incomplete response, a stale display field, or a recoverable incident is not by itself a human blocker.
