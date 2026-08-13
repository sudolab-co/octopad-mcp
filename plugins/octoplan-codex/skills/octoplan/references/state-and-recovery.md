# Octoplan state and recovery

Persist only what a fresh supervisor cannot safely derive: identity, approved authority, current generations, live actors, unresolved effects, artifact versions, open checkpoints, and the next safe continuation. Octopad is not a scheduler or raw execution log.

## Contents

- [State host](#state-host)
- [Minimal state](#minimal-state)
- [Material revision](#material-revision)
- [Write receipts](#write-receipts)
- [Native action intents](#native-action-intents)
- [Targeted recovery](#targeted-recovery)
- [Strict pauses](#strict-pauses)

## State host

Designate exactly one reviewed `Exx` delivery task as the state host. It must own or integrate the observable outcome. In a one-task plan it is that task; in a multi-task plan it is the existing outcome/integration task. Its status follows live actionability and dependencies, and once active it closes only on integrated proof. Never create a bookkeeping or status task.

Append the state after the task's stable delivery manifest:

```markdown
OCTOPLAN_STATE_BEGIN
<JSON object>
OCTOPLAN_STATE_END
```

The manifest hash covers the normalized autonomous delivery manifest and artifact contracts, excluding the delimited state block. A state-only edit changes neither manifest hash nor generation. Use `expected_updated_at` on every update; a failed guard causes reread and reconciliation, never overwrite. The host becomes `done` only with accepted integrated proof.

Append bounded recovery comments with one UUID `idempotency_key` per event; reuse it only for the same retry.

## Minimal state

Persist one compact control object. The live Octopad graph remains authoritative for task content, dependencies, and statuses. Confirmed receipts go in bounded comments. Omit empty optional runtime sections. Ordinary JSON formatting is accepted.

```json
{
  "schema": "octoplan-plan-v6",
  "plan_id": "<stable UUID>",
  "revision": 1,
  "status": "planning|planned|active|replanning|waiting-human|paused|completed|superseded",
  "calibration": {"shape": "simple|structured|adaptive", "consequence": "reversible|material|protected", "rationale": "<short reasons>"},
  "context": {"organization_id": "<ID>", "workspace_id": "<ID>", "work_stream_id": "<ID>", "state_host_ref": "E01", "native_target_ref": "<current task by default>", "project_ref": null},
  "contract": {"brief_hash": "<hash>", "source_ref": "<durable user turn or approval receipt>", "outcome": "<compact outcome>", "proof": "<compact completion proof>", "authority": "plan-only|<bounded delivery effects>", "delivery_authorized": true, "review_cadence": "progressive|final", "completion_evidence_ref": null},
  "intent": {"revision": 1, "latest_user_ref": "<directive>", "superseded_action_keys": []},
  "supervisor": {"thread_ref": "<current task>", "epoch": 1, "goal_ref": "<Goal receipt or null for plan-only>", "planned_route": "gpt-5.6-sol/high", "observed_route": "gpt-5.6-sol/high", "route_evidence_ref": "<observation>"},
  "tasks": {
    "E01": {"task_id": "<ID>", "generation": 1, "consequence": "reversible|material|protected", "manifest_hash": "<hash>", "artifact_refs": ["A01", "A02"]}
  },
  "plan_review": {
    "revision": 1,
    "fresh": {"review_type": "full_independent_fresh", "reviewer_session_ref": "<session>", "packet_hash": "<hash>", "planned_route": "gpt-5.6-sol/high", "observed_route": "gpt-5.6-sol/high", "route_evidence_ref": "<observation>", "octopad_context_ref": "<read-only session and exact context>", "finding_keys": [], "executed_checks": ["<check>"], "verdict": "PASS|REVISE", "evidence_ref": "<record>"},
    "latest_recheck": null
  },
  "open_checkpoints": {
    "C01": {"task_refs": ["E01"], "owner": "<person or role>", "subject": "<decision>", "resume_predicate": "<exact evidence>", "evidence_ref": null}
  },
  "artifacts": {
    "A01": {"task_ref": "E01", "profile": "repository|content|research|operations", "locator": "<stable locator>", "version": "<SHA, document revision, synthesis hash, or run ID>", "state": "draft|ready|waiting-human|terminal", "owner_ref": "<actor>", "verifier_ref": "<profile verifier>", "evidence_ref": "<evidence or null>", "disposition": "active|adopt|reject|rewrite|historical", "profile_data": {"<required profile fields>": "<bounded evidence>"}}
  },
  "continuation": {"last_progress_ref": null, "next_safe_task_refs": ["E01"], "blocked": {}, "incident": null}
}
```

Inline work omits actor bindings, not effect intents. Add these optional sections only while they are non-empty; `pending_actions` remains mandatory during any inline mutation or external side effect:

```json
"active_actors": {"E01:g1:executor": {"thread_ref": "<native task>", "role": "<role>", "task_ref": "E01", "generation": 1, "binding_hash": "<binding>", "planned_route": "gpt-5.6-sol/high", "observed_route": "gpt-5.6-sol/high", "route_evidence_ref": "<observation>", "octopad_context_ref": "<session/context>", "state": "starting|active|waiting|correction|terminal"}},
"pending_actions": {"<stable action key>": {"kind": "create|directive|effect|archive", "task_ref": "E01", "generation": 1, "target_ref": "<target>", "authority_ref": "<authority>", "result": "pending|ambiguous"}}
```

Before the brief is covered by the user mandate, it stays in the conversation. `planned` means the reviewed Octopad graph and compact state exist; plan-only keeps `goal_ref: null`. Delivery becomes `active` only after Goal creation. Control status records recovery conditions; Octopad tasks remain the project-progress truth.

`plan_review.fresh` is immutable and mandatory for each revision. When it is `REVISE`, `latest_recheck` must record `targeted_recheck`, the same reviewer session, the corrected packet, every original finding key, executed checks, PASS, and evidence. A targeted recheck alone never activates a plan.

The contract stores a compact outcome, proof, authority envelope, immutable brief hash, and durable source or approval receipt. If a native turn will not resolve for a successor, persist its receipt before launch. Review cadence never widens authority or satisfies a checkpoint; keep only open resume contracts here.

`active_actors` contains only spawned actors that may still act or need reconciliation; remove them after archive receipt. Each binding hash covers plan/intent revisions, supervisor epoch, task generation/manifest, authority, context, target, route, and artifact versions. A material mismatch permits only stop or recovery.

Keep the object small by moving confirmed receipts and terminal lifecycle events to bounded comments with stable references. Never compact away an unresolved action, open checkpoint, active actor, artifact disposition, or continuation predicate. Do not persist mirrored dependency graphs, derived frontiers, raw logs, token estimates, or telemetry counters.

Every artifact uses the generic core and exactly one profile. A task may own several artifacts with different profiles; its `artifact_refs` are the ownership boundary. Its bounded `profile_data` must satisfy that profile, and repository base/head is invalid as a universal requirement. No artifact can become terminal without verifier evidence and a non-active disposition. Plan completion is forbidden while an artifact is draft, ready, waiting, or missing a disposition.

## Material revision

Increment the plan revision when outcome, proof, scope, task meaning, graph, calibration, owner, route, authority, acceptance, artifact contract, or protected action changes. Increment every affected task generation, stop old actors before further effects, disposition their artifacts, create new manifests, and run one fresh plan-review session. A fresh planner is required only when the changed problem benefits from isolated re-decomposition.

Formatting, display names, clarified prose with unchanged meaning, receipts, progress, and artifact state transitions do not create a revision.

For every user directive, first increment `intent.revision` with `expected_updated_at`, save its source and superseded action keys, then notify actors. A material change sets `replanning`; old plan PASS and actor eligibility do not transfer. A stable finding correction keeps revision and generation and returns to the same reviewer session.

## Write receipts

Use one stable operation key per write, such as `<plan-id>:r1:task:E01`. Before a non-idempotent write, record `OCTOPLAN_WRITE_INTENT <operation-key>` on the state host. Record one receipt per item:

```text
OCTOPLAN_RECEIPT {"operation_key":"...","entity":"task","ref":"E01","id":"...","result":"confirmed","evidence":"write-response|targeted-read"}
```

A returned ID or explicit receipt confirms an item. After incomplete or timed-out output, assume neither failure nor success: list once, verify only uncertain items by key/ref/ID or exact edge, and retry only proven absences with the original key. Never replay the batch; ambiguity remains pending and blocks only dependent work.

## Native action intents

Before every native create or archive, instruction-changing actor directive, source mutation, or external side effect, add one `pending_actions` entry under a stable key. Reads, deterministic local checks, waits, and routine status polling need no action intent. A create entry carries the bounded role packet and planned route. After creation, prove the observed route and exact Octopad context before work; after confirmation, append a receipt comment and remove the pending entry.

After uncertain output, reconcile observed state before acting. Match create by key and role packet, directive/effect by action key, and archive by exact target. Retry only after authoritative absence; ambiguity pauses that branch without blocking independent safe work.

Only the current supervisor epoch may act. A successor is allowed only after waking the saved owner fails, native evidence proves it terminal or unreachable, a guarded update rotates owner and epoch, and post-fence evidence proves effects quiescent. The predecessor Goal remains historical; never manufacture a transfer or terminal state.

## Targeted recovery

On resume:

1. start a production Octopad session and refresh the state host, exact work stream/tasks, installed skill, native Goal, and native task list;
2. verify v6 plan and intent revisions, supervisor epoch, authority, calibration, task generations/manifests, plan review, checkpoints, active actors, artifact versions, and pending actions;
3. reconcile only unresolved writes/actions, live actors, artifacts, checkpoints, and the open incident; derive the safe frontier from live Octopad dependencies and those records;
4. read full source content only when its meaning, version, verifier, or authority may have changed;
5. wake the unique saved owner first. Create a guarded successor only after terminal-or-unreachable and post-fence quiescence evidence; never create a second plausible owner.

Reject every non-v6 schema. Do not validate, migrate, translate, or resume it; start a new reviewed v6 plan from the live mandate.

For each incident, save one compact record with stable key, failed predicate, classification, evidence, attempted distinct remedies, disposition, and resume predicate. One diagnosis plus two distinct safe remedies is the ceiling. Rewording, waking, or replacing an actor does not reset it.

## Strict pauses

Pause the affected branch for wrong identity; duplicate or ambiguous dispatch; absent authority; proven missing write; revision, generation, manifest, binding, context, route, or artifact-version mismatch; failed fence/quiescence; or an open protected decision.

Stop the whole plan only when shared identity or authority is invalid, the approved outcome is infeasible, or no safe agent-owned frontier remains. Tool unavailability, incomplete output, `projectId=null`, stale display metadata, or a recoverable incident is not by itself a human blocker. Diagnose and try bounded alternatives first; passive observation is never completion.
