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
  "schema": "octoplan-plan-v4",
  "plan_id": "<stable UUID>",
  "revision": 1, "proposed_revision": null, "proposed_review": null,
  "status": "planning|planned|active|replanning|waiting-human|paused|completed|superseded",
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
  "task_contracts": {
    "E01": {"task_generation": 1, "contract_hash": "<hash>", "manifest_ref": "<bounded manifest>", "manifest_hash": "<hash>", "new_context_required": true, "artifact_disposition": "adopt|reject|rewrite", "base_stack_ref": "<snapshot>"}
  },
  "brief_records": {
    "decisions": {"D01": {"id": "<ID>", "receipt_ref": "<receipt>"}},
    "questions": {"Q01": {"id": "<ID>", "receipt_ref": "<receipt>"}}
  },
  "desired_dependencies": [
    {"task_ref": "E02", "depends_on_ref": "E01", "rationale": "<why>"}
  ],
  "review": {"revision": 1, "task_generations": {"E01": 1}, "review_type": "full_independent_fresh|targeted_recheck", "reviewer_session_ref": "<session>", "planned_route": "gpt-5.6-luna/max", "observed_route": "gpt-5.6-luna/max", "route_evidence_ref": "<turn context>", "artifact_hash": "<hash>", "finding_keys": [], "executed_checks": ["<check>"], "verdict": "PASS", "evidence_ref": "<review record>"},
  "supervisor": {
    "thread_ref": "<current user task by default>",
    "epoch": 1,
    "mode": "current-task|dedicated-handoff|recovery-successor",
    "predecessor": null,
    "goal": {"required": true, "owner_thread_ref": "<same thread>", "objective_ref": "<approved outcome>", "origin": "created|adopted|null", "evidence_ref": "<receipt or null while pending>", "state": "pending|active|blocked|complete", "supersedes_goal_ref": null}
  },
  "runtime": {"minimum_version": "14.0.0", "loaded_version": "14.0.0", "installed_version": "14.0.0", "adoption_ref": null, "admission_checked_at": "<timestamp refreshed before dispatch/effect>", "supervisor_route": {"planned": "gpt-5.6-sol/high", "observed": "gpt-5.6-sol/high", "evidence_ref": "<turn context>", "admission": "PASS"}},
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
  "actors": {}, "native_action_intents": [], "native_action_receipts": [],
  "stack_snapshots": {"stack-1": {"main_sha": "<sha>", "base_shas": ["<sha>"], "head_shas": ["<sha>"], "ancestry_ref": "<evidence>", "effective_diffs_ref": "<evidence>", "migration_registry_ref": "<evidence>", "checks_ref": "<evidence>", "verifier_coverage_ref": "<evidence>", "checked_at": "<timestamp>", "ttl_seconds": 300, "fresh_until": "<timestamp>", "admission": "PASS", "admission_ref": "<readback>"}},
  "frontier": {"parallel_safe_now": [], "blocked_on_artifact_refs": {}, "write_conflict_set": {}},
  "telemetry": {"snapshot_refs": [], "metrics": []},
  "compaction": {"size_budget": "<explicit positive connector-safe limit>", "detail_ledger_refs": [], "last_receipt": null},
  "heartbeat": null,
  "resume": {"last_event_id": null, "pending_operation_keys": []}
}
```

For `recovery-successor`, replace `predecessor: null` with exactly `{"thread_ref":"...","epoch":1,"goal_evidence_ref":"...","revival_ref":"...","terminal_or_unreachable_ref":"...","fence_key":"<plan_id>:takeover:epoch:2","fence_readback_ref":"...","effects_quiescent_ref":"<post-fence evidence>"}`; otherwise keep it null.

Before approval, the brief stays in the conversation; Octoplan writes nothing to Octopad. `planning` covers reconciled creation; `planned` means the reviewed graph exists. Other states describe coordination, never Octopad task statuses. `plan-only` stops at `planned` without a Goal; delivery enters `active` only after Goal creation. Replanning keeps current authority while `proposed_revision` and `proposed_review` describe the candidate delta.

The authority source must equal the approved brief reference, and its actions, roles, environments, Octopad write classes, child route, and effects must exactly match the brief's normalized disclosure. The vocabulary is internal, not user-facing command syntax. Projectless execution is explicit. Later widening requires a revised brief, reviewed plan revision, and new source reference. Adopted sessions require matching provenance. User review cadence never authorizes a protected effect or removes an organization checkpoint. Review/merge remain embedded on an E task; a separately owned human deliverable may use Hxx.

Persist only useful budget ceilings and authoritative counters. Keep detailed receipts in comments/ledger refs, not C00. Before its explicit size budget, compact automatically with pre/post hashes, essential-field inventory, readback, and no-loss assertion. Typed telemetry records metric, value or `unavailable`, source, population, and time window; sessions, review passes, retries, compactions, tool calls, elapsed time, and tokens never share a counter or get added. Ceilings never waive checks or checkpoints.

Actor records carry a complete `actor_binding_readback`, `fresh_session_receipt` where required, route-admission and stack receipts, lifecycle, and evidence. Reuse a healthy writer only for stable findings on the same artifact/generation when result, scope, risk, graph, route, acceptance, authority, contract, and base remain unchanged. Split/merge, changed meaning/outputs/Done when/graph/route/acceptance/authority, rejected draft, rewrite-from-scratch, generation/manifest change, or unadoptable drift increments `task_generation`; the predecessor may only stop, transfer, recover, or archive.

Replacement lifecycle separates `active -> fence-pending -> fenced -> terminal-reconciled -> archived|archive-pending` from successor `created-pending -> active`. Activate a successor writer only after stop acknowledgement, `effects_quiescent_ref`, affected task-generation rotation, transfer receipt, fresh create receipt, binding readback, and manifest acknowledgement; never rotate the supervisor epoch for task replacement. A read-only planner may start earlier. Physical archive may follow activation once quiescence is proved. Normal completion requires PASS/reconciliation and `archive_receipt`; failure records `archive_incident_ref`, stays pending under bounded recovery, and final success waits.

Plan revision identifies the reviewed graph; task ID plus `task_generation` identifies semantic meaning. `intent.revision` orders operational instructions independently. Hashes bind a bounded manifest/contract or compaction receipt, not an exhaustive mirrored plan.

## Material revision

Increment the plan revision when a reviewed change affects result, scope, success evidence, task meaning, split/merge, outputs, dependency/parallelism, checkpoint, owner, route/model bound, authority, acceptance, or required artefact. Increment every affected `task_generation`, set `new_context_required`, fence old writers, and require a new autonomous manifest plus `full_independent_fresh` review.

Do not increment it for formatting, display names, descriptions clarified without changing meaning, reordered MCP prose, links, response shapes, runtime receipts, progress, artifacts, or status changes.

For every user directive, first increment `intent.revision` under `expected_updated_at`, store its source and superseded effect keys, then notify affected actors. If meaning changes, set `replanning`, stop affected claims, rotate generations, map `adopt|reject|rewrite`, create manifests, run fresh full review, verify receipts/edges, then replace the revision under the guard. Old actor eligibility and PASS never transfer. Stable corrections keep generation and use targeted recheck.

## Write receipts

Use one stable operation key per intended write, for example `<plan-id>:r1:task:E01` or `<plan-id>:r1:edge:E02:E01`. Before a write without server-side idempotency, persist that key in `resume.pending_operation_keys`; before the work stream or coordination task exists, emit `OCTOPLAN_WRITE_INTENT <operation-key>` in the durable planning transcript. Record one compact journal event per item and clear the pending key only after confirmation:

```text
OCTOPLAN_RECEIPT {"operation_key":"...","entity":"task","ref":"E01","id":"...","result":"confirmed","evidence":"write-response|targeted-read"}
```

An explicit returned item ID or success receipt confirms the item. `structuredContent` is useful when present but never mandatory. If the response is incomplete, malformed for display, or missing one item, add a warning and verify only uncertain items by bounded stream list, internal operation marker, stable task reference, returned ID, targeted `get`, or exact dependency inspection.

For a timed-out batch, assume neither failure nor success. List once, match each stable ref, get only ambiguous candidates, and produce per-item receipts. Retry only writes proven absent, with their original operation keys. Never replay the whole batch because one item is unclear. A still-ambiguous item remains pending and blocks only dependent work while reconciliation continues.

## Native action intents

Before every create, work-message, source effect, or archive, persist one intent with a stable key. A create intent carries the current creation packet, planned route, and fresh stack while observed route/readback remain pending; after dispatch, persist observation evidence before any work message/effect. Work, archive, and other receipts match the actor's historical binding tuple; only unresolved/actionable intents must match current state. Never rewrite confirmed historical receipts or message revised work before durable intent/generation state exists.

After uncertain output, reconcile observed state before acting; never blind replay. Match create by key/role packet; correlate message by action/effect key; inspect archive visibility/target. Retry only after authoritative absence; conflicts pause that branch. Exhausted archive recovery preserves `archive-pending`, pauses final close, and reports the failed predicate/resume evidence.

Only the current supervisor epoch may act. Before takeover, append `OCTOPLAN_TAKEOVER_INTENT` and derive `fence_key` exactly as `<plan_id>:takeover:epoch:<predecessor_epoch+1>`. One `expected_updated_at` update atomically fences the predecessor by setting owner, recovery mode, incremented epoch, predecessor, `paused`, and successor Goal `pending`. Reread it, then obtain fresh post-fence quiescence before Goal creation. The predecessor Goal stays historical.

## Targeted recovery

On resume:

1. refresh the exact native task, organization/workspace session, work stream, coordination task, and current task IDs;
2. verify plan/revision, task generations/manifests, intent, status, supervisor/Goal owner, authority, checkpoints, observed routes, stack freshness, runtime, heartbeat, and pending keys;
3. adopt a compatible installed v4 update, then reconcile only pending writes/actions, claimed work, reviews, checkpoints, and open incident keys through the runtime identity hierarchy where relevant;
4. re-read full task or source content only when its meaning, revision, verifier, or authority may have changed;
5. revive and wake the unique saved owner first; only when native evidence proves it terminal or unreachable may a guarded `recovery-successor` follow the protocol in [codex-supervision.md](codex-supervision.md). Never create a second plausible effective owner.

Presentation drift is a warning. A receipt with an ID is enough to target verification. Do not require every Decision, Question, task, or comment to be re-rendered exactly before useful work continues.

For each incident, append one event with stable key, failed predicate, classification, evidence, actor/mutation state, remaining budget, remedies/receipts, disposition, and resume/stop predicate. One diagnosis plus two distinct remedies is the default ceiling unless the plan sets less; rewording, waking, or replacing a reasoning actor never resets it.

## Strict pauses

Pause the affected branch for wrong identity; unresolved/duplicate dispatch; absent authority; proven missing write; plan/intent/generation/manifest/binding mismatch; unobserved or noncompliant route; stale stack for a writer; failed fence/quiescence; or a human checkpoint/material decision.

Stop the whole plan only when shared identity/authority is invalid or no safe agent-owned frontier remains. Tool unavailability, missing `structuredContent`, incomplete output, `projectId=null`, stale display metadata, or a recoverable incident is not by itself a human blocker. Diagnose and try bounded safe alternatives first; never turn passive observation into completion or a permanent block.
