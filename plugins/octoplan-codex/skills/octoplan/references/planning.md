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

Continue exactly one live `octoplan-plan-v1`. A greenfield request creates one. A 10.x, unknown, partial, or conflicting contract is not executable: preserve it as history, recover the confirmed mandate and useful artifacts, prove old actors quiescent or fenced, then create a fresh v1 plan. Never inherit an old PASS, fingerprint, digest, consent, or creation intent.

If two plausible planners, ledgers, streams, or native sessions claim the same plan, reconcile them before writing or creating. Adopt the unique evidenced owner; pause only when the duplicate is materially unreconcilable.

## Brainstorm and brief

Collaborate naturally before imposing structure. Restate the intended result, then ask only questions that can change scope, success, risk, order, ownership, validation, project/workspace, protected gates, or execution authority. Ask all currently material questions in one numbered batch; use one targeted follow-up only when an answer exposes a new material ambiguity.

When enough is known, publish a compact brief containing the result and success evidence; in/out scope and important constraints; confirmed decisions, open material questions, sources, and assumptions; organization, workspace, work stream, and Codex project; protected gates; Delivery mode; and the finite native roles and environments that may be needed.

Default to **Review before delivery**. **Autonomous delivery** covers planning, launch, repair, and in-envelope replanning only when the user clearly delegates that bounded outcome. Neither mode authorizes secrets, access changes, destructive effects, spend, merge, migration application, deployment, publication, or acceptance.

Ask once for a native-creation grant covering the exact Codex project, allowed environments, and finite roles. It may cover the complete validated plan; never ask actor by actor. Keep its durable source reference. Delivery mode, plan approval, or a vague “go” does not replace it.

If a material answer remains open after the follow-up, return one `HUMAN_DECISION` with options and a recommendation instead of serial questioning.

## Identity runway

Before any Octopad planning write, prove the exact organization/workspace membership, one intended stream action, current Codex project identity, live Octopad write schemas, targeted read tools, one fresh plan reviewer, and real native creation/relocation authority.

If the current task is already in the intended project, continue. Otherwise relocate the untouched brief only under exact authority. Emit one durable `OCTOPLAN_BOOTSTRAP_INTENT` with a unique key, target project/environment, stream action, and source references before the one create call.

Treat `clientThreadId` as setup only. Reconcile through native task listing/reading and the bootstrap key. Pending setup waits through one bounded setup window and a second list/read. Adopt one exact destination; pause on several or a wrong project. If the second read still finds zero, pause as `bootstrap-dispatch-ambiguous`: resume only when the exact destination appears or authoritative native evidence proves no dispatch occurred, allowing the old intent to be retired and a fresh key issued once. Never retry blindly, and make no Octopad write from the source task.

## Draft the graph

Build the plan off-record using stable `E01`-style references for agent work and `H01`-style references for human gates. Each task must be an independently useful result, not a login, probe, read, tracker update, status relay, or tool call. Combine steps that share one owner, artifact, route, verifier, and gate unless they have independent acceptance.

Every agent task tells a fresh model enough to act without the planning chat: literal **Why**, **What**, and top-level **Done when** sections; outcome and boundaries; confirmed decisions and source pointers; useful implementation guidance; artifact and checks; failure or rollback limits; execution model/effort; review class/route; dependencies, owner, and gates; one internal `Octoplan operation key: <plan-id>:r<revision>:task:<ref>` marker; plus `impact` from 1 to 5 and `impact_rationale`.

Subtasks still need **Why** and **What**. Human tasks have no execution route and name the exact occurrence, owner, approval evidence, and resume predicate. Preserve dependency rationales. Remove a transitive edge only when the remaining path preserves the same rationale and gate.

Choose the lightest adequate task review:

- `independent`: fresh reviewer plus targeted tests for product, code, security, privacy, data, migrations, public output, or other material effects;
- `targeted`: a real diff/criteria adversarial check for documentation, internal work, or low-risk reversible artifacts;
- `specialist`: one additional fresh reviewer only for a second distinct material failure domain.

## Review before activation

Give one fresh read-only reviewer the complete draft, brief, sources, graph, routes, gates, and proposed review classes. Ask it to challenge outcome coverage, task quality, duplication, dependencies, model fit, authority, protected actions, feasibility, and unnecessary orchestration.

Accept only an explicit `PASS`, `REVISE`, `INFEASIBLE`, or `HUMAN_DECISION` with evidence. Silence, timeout, unavailable checks, or unfinished review is not PASS. Apply only confirmed findings. Recheck a corrected surface; repeat the whole plan review only when outcome, contract, or material scope changed.

Record the reviewer, plan revision, verdict, checked surfaces, findings, corrections, and remaining risks. The reviewer never writes Octopad, creates actors, or grants authority.

## Persist and verify

Read the active tool schemas immediately before writing. Use the connector's accepted shapes:

- finite work streams include `rationale`, `definition_of_success`, and `primary_goal_id`; stream creation supplies `scope` and `work_stream_description`;
- streamed tasks use `work_stream_id` and omit `goal_id`;
- multi-task creation supplies `depends_on_refs` for every row when required and `depends_on_rationale` for its edges;
- page links use `{page_id, rationale}`;
- task descriptions and impact fields follow the server contract above.

Create or adopt one coordination task, then persist the minimal state from [state-and-recovery.md](state-and-recovery.md). Create the reviewed tasks in coherent batches without shortening descriptions. Use returned IDs or receipts immediately; an incomplete response triggers targeted reconciliation, never blind replay.

For each essential stream, task, decision/question, dependency, and state update, record an item receipt from the write response or a targeted verification. Missing `structuredContent`, `_ui` differences, reordered prose, display-name changes, or non-byte-identical readback are warnings only. Verify uncertain items once by returned ID, stable task key, exact edge, or a bounded list plus targeted get. Retry only an item proven absent under its original operation key. If existence remains ambiguous, keep it pending and reconcile again; do not duplicate it.

Plan PASS requires the independent review record, one receipt for every essential creation, the desired dependency set, correct organization/workspace/stream, available verifiers, and no material drift from the reviewed draft. It never requires exhaustive readback or byte equality.

## Approve and launch

Set `approved_revision` only after review and targeted persistence verification. Under **Review before delivery**, show the plan and autonomy boundary, ask for approval, and stop. Under **Autonomous delivery**, an earlier end-to-end mandate may authorize launch after review only when the persisted plan stays inside its exact bounded outcome; otherwise ask once for the changed boundary.

Before launch, verify current plan ID/revision, supervisor owner, creation grant, unresolved material questions, protected gates, task routes, and first ready frontier. Then follow [codex-runtime.md](codex-runtime.md) and [codex-supervision.md](codex-supervision.md).
