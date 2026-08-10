# Octoplan planning

Use this workflow to turn an idea or an existing work stream into an executable Octopad plan. Durable state and reconciliation rules live in [state-and-recovery.md](state-and-recovery.md).

## Contents

- [Entry and recovery](#entry-and-recovery)
- [Brainstorm and brief](#brainstorm-and-brief)
- [Identity runway](#identity-runway)
- [Draft the graph](#draft-the-graph)
- [Review before activation](#review-before-activation)
- [Persist and verify](#persist-and-verify)
- [Approve and launch](#approve-and-launch)

## Entry and recovery

Refresh the live organization, workspace, work stream, current tasks, relevant decisions/questions, and native Codex tasks before choosing a path. Read a bounded stream or task context once, then retrieve only material gaps. Do not read every Decision, Question, or task merely to reproduce a canonical snapshot.

Continue exactly one live `octoplan-plan-v2`. A greenfield request creates one. A v1, 10.x, unknown, partial, or conflicting contract is history: recover the confirmed mandate and useful artifacts, fence old actors, then create a fresh v2 plan. Never inherit PASS, authority, creation intents, or launch state.

If two plausible planners, ledgers, streams, or native sessions claim the same plan, reconcile them before writing or creating. Adopt the unique evidenced owner; pause only when the duplicate is materially unreconcilable.

## Brainstorm and brief

Collaborate naturally before imposing structure. Restate the intended result, then ask only questions that can change scope, success, risk, order, ownership, validation, project/workspace, protected gates, or execution authority. Ask all currently material questions in one numbered batch; use one targeted follow-up only when an answer exposes a new material ambiguity.

When enough is known, publish a compact brief containing the integrated outcome and global evidence; in/out scope and constraints; decisions, questions, sources, and assumptions; organization, workspace, stream, and project; protected gates; Delivery mode; capacity; and finite actor actions, roles, and environments.

Default to **Review before delivery**. **Autonomous delivery** covers planning, launch, repair, and in-envelope replanning only when the user clearly delegates that bounded outcome. Neither mode authorizes secrets, access changes, destructive effects, spend, merge, migration application, deployment, publication, or acceptance.

Ask once for a source-bound plan grant enumerating exact create/message/archive actions, project, environments, and finite roles; never ask actor by actor. It never covers the user-owned planning session or an adopted session without matching provenance. Delivery mode, approval, or a vague “go” does not replace it.

If a material answer remains open after the follow-up, return one `HUMAN_DECISION` with options and a recommendation instead of serial questioning.

## Identity runway

Before planning writes, prove organization/workspace membership, intended stream action, Codex project identity under [codex-runtime.md](codex-runtime.md), write schemas, targeted reads, one fresh plan reviewer, and native creation/relocation authority.

If the current task is already in the intended project, continue. Otherwise relocate the untouched brief only under exact authority. Emit one durable `OCTOPLAN_BOOTSTRAP_INTENT` with a unique key, target project/environment, stream action, and source references before the one create call.

Treat `clientThreadId` as setup only. Reconcile through native task listing/reading, the bootstrap key, and the runtime identity hierarchy. Pending setup waits through one bounded setup window and a second list/read. Adopt one exact destination whose project is directly or alternatively established; pause on several candidates or a proven wrong project. If the second read still finds zero, pause as `bootstrap-dispatch-ambiguous`: resume only when the exact destination appears or authoritative native evidence proves no dispatch occurred, allowing the old intent to be retired and a fresh key issued once. Never retry blindly, and make no Octopad write from the source task.

## Draft the graph

Define the first integrated demonstrable candidate or vertical slice across the critical path before any non-essential external gate. A gate blocks only descendants that require it; independent safe work remains eligible. Plan completion requires current global integrated-outcome evidence, never a count of completed components or branches.

Use stable `E01` refs for delivery and `H01` only for separate human tasks. Review and PR merge are not separate tasks: embed occurrences required by active instructions or repository workflow in the owning delivery task. Do not add a second go when existing authorization remains valid. Every gate records `gate_key`, `kind`, `location`, `delivery_task_ref`, `owner`, `target_effect`, `evidence_ref`, `state`, and `resume_predicate`. Embedded review/merge use `location=embedded`; other gates may use `location=human-task` with Hxx. Agent review is a native session.

Optimize explicit critical-path rank and `eligible_safe_ready` frontiers. Eligibility requires ready dependencies, authority, route, capability, budget, and no conflict in files, symbols, artifacts, migrations, lockfiles, scarce resources, gates, routes, or budgets. Bound plan/task WIP, active child actors, retry/correction loops, review actors/checks, and repeated-item batch size. Batch independent articles or similar items while retaining individual artifacts, receipts, verdicts, and acceptance. Launch up to capacity from the safe frontier, reconcile, then backfill; never require all-ready activation or serialize merely because only a partial batch fits.

Every delivery task tells a fresh model enough to act without the planning chat: literal **Why**, **What**, and top-level **Done when**; outcome and boundaries; decisions and source pointers; useful guidance without overprescribing; artifacts and checks; rollback/failure behavior; lightest adequate model/effort; review class; dependencies, owner, gates, impact, and `impact_rationale`; plus `Octoplan operation key: <plan-id>:r<revision>:task:<ref>`.

The delivery task containing an embedded human review or merge stays active through its applicable gates. Its Done when includes the required review, merge, and closure evidence. Follow active `AGENTS.md` and repository workflow. Do not create login, probe, read, tracker, status-relay, human-review, merge, or tool-call tasks. Combine steps sharing owner, artifact, route, verifier, and gate unless independently acceptable.

Subtasks still need **Why** and **What**. Human tasks have no execution route and name the exact occurrence, owner, approval evidence, and resume predicate. Preserve dependency rationales. Remove a transitive edge only when the remaining path preserves the same rationale and gate.

Budgets are hard ceilings, not estimates or permission to skip a check or gate. Persist only useful ceilings and counters. Add token, tool-call, or compaction limits only when authoritative telemetry is observable; never estimate missing time, cost, or tokens.

Choose the lightest adequate task review:

- `independent`: fresh reviewer plus targeted tests for product, code, security, privacy, data, migrations, public output, or other material effects;
- `targeted`: a real diff/criteria adversarial check for documentation, internal work, or low-risk reversible artifacts;
- `specialist`: one additional fresh reviewer only for a second distinct material failure domain.

## Review before activation

Give one fresh read-only reviewer the complete draft, brief, sources, critical path, integrated candidate, frontiers, budgets, routes, gates, global proof, and review classes. Ask it to challenge outcome coverage, task quality, duplication, dependencies, model fit, authority, protected actions, feasibility, and orchestration.

Accept only an explicit `PASS`, `REVISE`, `INFEASIBLE`, or `HUMAN_DECISION` with evidence. Silence, timeout, unavailable checks, or unfinished review is not PASS. Apply only confirmed findings. Recheck a corrected surface; repeat the whole plan review only when outcome, contract, or material scope changed.

Record the reviewer, plan revision, verdict, checked surfaces, findings, corrections, and remaining risks. The reviewer never writes Octopad, creates actors, or grants authority.

## Persist and verify

Read the active tool schemas immediately before writing. Use the connector's accepted shapes:

- finite work streams include `rationale`, `definition_of_success`, and `primary_goal_id`; stream creation supplies `scope` and `work_stream_description`;
- streamed tasks use `work_stream_id` and omit `goal_id`;
- multi-task creation supplies `depends_on_refs` for every row when required and `depends_on_rationale` for its edges;
- page links use `{page_id, rationale}`;
- task descriptions and impact fields follow the server contract above.

Create or adopt one coordination task, then persist `draft` with `proposed_revision`, nullable approval/authority, and the minimal state from [state-and-recovery.md](state-and-recovery.md). After plan-review PASS persist `awaiting-approval`; never launch from either state. Create reviewed tasks in coherent batches without shortening descriptions. Use returned IDs or receipts immediately; incomplete output triggers targeted reconciliation, never blind replay.

For each essential stream, task, decision/question, dependency, and state update, record an item receipt from the write response or a targeted verification. Missing `structuredContent`, `_ui` differences, reordered prose, display-name changes, or non-byte-identical readback are warnings only. Verify uncertain items once by returned ID, stable task key, exact edge, or a bounded list plus targeted get. Retry only an item proven absent under its original operation key. If existence remains ambiguous, keep it pending and reconcile again; do not duplicate it.

Plan PASS requires the independent review record, one receipt for every essential creation, the desired dependency set, correct organization/workspace/stream, available verifiers, and no material drift from the reviewed draft. It never requires exhaustive readback or byte equality.

## Approve and launch

After review and persistence proof, an exact approval guarded by `expected_updated_at` copies `proposed_revision` to `approved_revision`, clears the proposal, records matching execution authority, and sets `approved`. Under **Review before delivery**, show the plan and stop for approval. Under **Autonomous delivery**, an earlier bounded mandate may authorize this transition only inside its exact outcome. Never launch before `approved`.

Before launch, verify plan ID/revision, dedicated supervisor intent, creation grant, questions, gates, routes, capacity, and first `eligible_safe_ready` frontier. Create or adopt exactly one dedicated native supervisor titled `Supervisor - <short-plan> - <mission>` within 64 characters, reconcile it, and transfer the packet. The planner stops its loop after acknowledged handoff and stays visible; neither planner nor supervisor is auto-archived. Then follow [codex-runtime.md](codex-runtime.md) and [codex-supervision.md](codex-supervision.md).
