# Octoplan planning

Use this workflow to turn an idea or an existing work stream into an executable Octopad plan. Durable state and reconciliation rules live in [state-and-recovery.md](state-and-recovery.md).

## Contents

- [Entry and recovery](#entry-and-recovery)
- [Clarify and creation brief](#clarify-and-creation-brief)
- [Identity runway](#identity-runway)
- [Draft the graph](#draft-the-graph)
- [Review before activation](#review-before-activation)
- [Persist and verify](#persist-and-verify)
- [Activate or stop](#activate-or-stop)

## Entry and recovery

Refresh the live organization, workspace, work stream, current tasks, relevant decisions/questions, and native Codex tasks before choosing a path. Read a bounded stream or task context once, then retrieve only material gaps. Do not read every Decision, Question, or task merely to reproduce a canonical snapshot.

Continue exactly one live `octoplan-plan-v3`. A greenfield request creates one. For v1, v2, 10.x, unknown, partial, or conflicting state, load [octoplan-contract-v3.md](octoplan-contract-v3.md), enumerate known live supervisors/Goals, persist a source-bound migration notice, fence affected old execution, recover the confirmed mandate and useful artifacts, then create a fresh v3 plan. Never assume installation propagated the correction or inherit PASS, authority, creation intents, supervisor ownership, or launch state.

At each safe wake, compare the loaded skill version with the installed Octoplan version. Fully read and adopt a compatible v3 update, recording the transition before further action. A breaking major, higher schema, or incompatible invariant requires material replan; a role packet's minimum version is not a permanent pin.

If two plausible planners, ledgers, streams, or native sessions claim the same plan, reconcile them before writing or creating. Adopt the unique evidenced owner; pause only when the duplicate is materially unreconcilable.

## Clarify and creation brief

Collaborate in natural language. The current user task interviews directly; `roles/planner.md` is only for a delegated diagnostic planner that cannot ask the user. Ask together only what can change scope, success, risk, order, ownership, validation, identity, protected effects, or post-plan delivery; follow up only when an answer exposes a new material ambiguity. Inspect `get_goal` before recommending the native route.

Before any Octopad write, show one **brief de création** containing:

- integrated outcome and proof; in/out scope, constraints, sources, assumptions, organization, workspace, stream, and native project;
- whether the request stops after creating the plan or authorizes bounded delivery, including the disclosed supervisor/child-session route;
- exact Octopad write classes/effects and native create/message/archive actions, finite roles, environments, project/worktree route, and child-session lifecycle that approval would cover;
- a recommended initiating-user review cadence: `progressive` or `final`, with the concrete reason;
- every human checkpoint: subject, timing, why human judgment is needed, owner, blocked descendants, safe work that can continue, expected decision, and exact resume evidence;
- mandatory organization/repository checkpoints and protected effects, even when the initiating user reviews only at the end.

Render the brief in the user's language and scale its presentation to material complexity without dropping any required fact. Compress a small reversible request; expand a risky or branching one.

Compact example:

- **Outcome/scope/proof/identity:** update one parser; targeted tests pass; parser/tests in, deploy out; repository source, no schema change; organization/workspace/stream/project confirmed.
- **Delivery/route/lifecycle:** approval covers bounded delivery; current task supervises one Goal; one worktree executor and reviewer; child archives only after terminal handoff.
- **Effects/roles:** Octopad tracker/task/comment/coordination-state; native create/message/archive; supervisor/executor/reviewer; no protected runtime effect.
- **Cadence:** final because no early choice changes the method.
- **Checkpoint/overlay:** required PR review after green checks because the repository requires human judgment; maintainer owns it; task close/merge wait while safe docs continue; expect approve/revise for the exact head; resume only on current-head review evidence. Merge remains separately gated.

Recommend progressive review only where a human choice changes downstream method or architecture, prevents material rework, governs many repeated artifacts, controls an irreversible/external effect, or cannot safely be inferred. Otherwise recommend final batch review. Ten independent articles normally fit final review; a shared methodology or pilot that governs all ten is reviewed before the rest. The user may choose either cadence, but mandatory organization rules still apply.

The user approves, revises, pauses, cancels, reprioritizes, or limits effects in ordinary language. Do not expose command syntax. Normalize the approved meaning into durable authority and intent fields. Brief approval authorizes only the Octopad and native operations explicitly disclosed by that brief; secrets, access changes, destructive effects, spend, merge, migration application, deployment, publication, and acceptance remain separately gated.

If a material answer remains open, return one `HUMAN_DECISION` with options and a recommendation. Do not write Octopad until the brief is approved. Do not create a Page merely to preserve it: the tracker, tasks, graph, Decisions, and Questions must embody the approved brief. A Page is valid only when it is itself a useful deliverable.

## Identity runway

Before planning writes, prove organization/workspace membership, intended stream action, Codex project identity under [codex-runtime.md](codex-runtime.md), write schemas, targeted reads, one fresh plan reviewer, and the disclosed native authority.

If the current task is already in the intended project, continue. Otherwise relocate the untouched brief only under exact authority. Emit one durable `OCTOPLAN_BOOTSTRAP_INTENT` with a unique key, target project/environment, stream action, and source references before the one create call.

Treat `clientThreadId` as setup only. Reconcile by native list/read, bootstrap key, and the runtime identity hierarchy. A returned `projectId=null` is incomplete evidence, not a blocker: use the unique receipt, saved project/repository mapping, worktree/Git identity, and no-mutation state. After one setup window and a second read, adopt one proven destination; pause on mismatch or several candidates. Zero candidates becomes `bootstrap-dispatch-ambiguous` until the destination appears or authoritative evidence proves no dispatch, allowing one retired intent and fresh key. Never retry blindly or write Octopad from an unresolved source task.

## Draft the graph

Define the first integrated demonstrable candidate or vertical slice across the critical path before any non-essential external checkpoint. A checkpoint blocks only descendants that require it; independent safe work remains eligible. Plan completion requires current global integrated-outcome evidence, never a count of completed components or branches.

The tracker holds human-readable outcome, scope, order/parallelism, checkpoints, and end condition, never copied task fields/status. Use stable `E01` refs and `H01` only for separately owned human work. A material resolved choice affecting outcome, scope, architecture, route, checkpoint, or acceptance becomes one Octopad Decision; a material unresolved item becomes one Question with owner, affected descendants, and resolution predicate. Persist refs/receipts without ordinary task detail. Embed required review/PR merge in the owning delivery task and never add a second go when authority remains valid. Each checkpoint records source, mandatory flag, subject, timing, reason, owner, blocked descendants, safe continuation, expected decision, state, evidence, and resume predicate. Agent review is native, not human.

Optimize explicit critical-path rank and `eligible_safe_ready` frontiers. Eligibility requires ready dependencies, authority, route, capability, budget, and no conflict in files, symbols, artifacts, migrations, lockfiles, scarce resources, checkpoints, routes, or budgets. Bound plan/task WIP, active child actors, retry/correction loops, review actors/checks, and repeated-item batch size. Batch independent articles or similar items while retaining individual artifacts, receipts, verdicts, and acceptance. Launch up to capacity from the safe frontier, reconcile, then backfill; never require all-ready activation or serialize merely because only a partial batch fits.

Every delivery task tells a fresh model enough to act without the planning chat: literal **Why**, **What**, and top-level **Done when**; outcome and boundaries; decisions and source pointers; useful guidance without overprescribing; artifacts and checks; rollback/failure behavior; lightest adequate model/effort; review class; dependencies, owner, checkpoints, impact, and `impact_rationale`; plus `Octoplan operation key: <plan-id>:r<revision>:task:<ref>`.

Make each top-level task one coherent, independently acceptable, reviewable, and reversible delivery unit. Under an organization rule such as one PR per task, independently acceptable database, capture, read, API, test-infrastructure, or dashboard surfaces become separate top-level tasks and dependent PRs from the outset. Subtasks are steps within the same artifact and PR, not a device for stacking several deliveries into one huge review. If the organization requires authorization to split tasks or PRs, expose that choice in the creation brief instead of silently accepting an unreviewable unit.

For every changed surface, name a verifier that actually runs on it. Green CI is evidence only for covered paths. Where relevant, include a bounded adjacent-case sweep for normalization/case variants, deduplication, authorization probes, batching, timeouts, empty/zero results, retries, and scale limits; select applicable cases rather than copying a ritual checklist.

The delivery task containing an embedded human review or merge stays active through its applicable checkpoint. Its Done when includes required review, merge, and closure evidence. Follow the effective `AGENTS.md`, organization policy, and repository workflow in each actor's environment. Do not create login, probe, read, tracker, status-relay, human-review, merge, or tool-call tasks. Combine steps sharing owner, artifact, route, verifier, and checkpoint only when they remain one independently acceptable delivery.

Subtasks still need **Why** and **What**. Human tasks have no execution route and name the exact occurrence, owner, approval evidence, and resume predicate. Preserve dependency rationales. Remove a transitive edge only when the remaining path preserves the same rationale and checkpoint.

Budgets are hard ceilings, not estimates or permission to skip a check or checkpoint. Persist only useful ceilings and counters. Add token, tool-call, or compaction limits only when authoritative telemetry is observable; never estimate missing time, cost, or tokens.

Choose the lightest adequate task review:

- `independent`: fresh reviewer plus targeted tests for product, code, security, privacy, data, migrations, public output, or other material effects;
- `targeted`: a real diff/criteria adversarial check for documentation, internal work, or low-risk reversible artifacts;
- `specialist`: one additional fresh reviewer only for a second distinct material failure domain.

## Review before activation

Give one fresh read-only reviewer the complete draft, approved creation brief, sources, critical path, integrated candidate, frontiers, budgets, routes, checkpoints, global proof, and review classes. Ask it to challenge outcome coverage, delivery-unit size and reviewability, task quality, duplication, dependencies, model fit, authority, organization rules, real verifier coverage, adjacent failure modes, protected actions, feasibility, and orchestration.

Accept only an explicit `PASS`, `REVISE`, `INFEASIBLE`, or `HUMAN_DECISION` with evidence. Silence, timeout, unavailable checks, or unfinished review is not PASS. Apply only confirmed findings. Recheck a corrected surface; repeat the whole plan review only when outcome, contract, or material scope changed.

Record the reviewer, plan revision, verdict, checked surfaces, findings, corrections, and remaining risks. The reviewer never writes Octopad, creates actors, or grants authority. If review exposes a material assumption outside the approved brief, revise the brief with the user before persisting or launching; do not hide the choice inside task prose.

## Persist and verify

Read the active tool schemas immediately before writing. Use the connector's accepted shapes:

- finite work streams include `rationale`, `definition_of_success`, and `primary_goal_id`; stream creation supplies `scope` and `work_stream_description`;
- streamed tasks use `work_stream_id` and omit `goal_id`;
- multi-task creation supplies `depends_on_refs` for every row when required and `depends_on_rationale` for its edges;
- page links use `{page_id, rationale}`;
- task descriptions and impact fields follow the server contract above.

After brief approval and plan-review PASS, create or adopt one coordination task and persist the minimal state from [state-and-recovery.md](state-and-recovery.md). Create reviewed tasks in coherent batches without shortening descriptions, then set `planned` only after their essential receipts and edges reconcile. Use returned IDs or receipts immediately; incomplete output triggers targeted reconciliation, never blind replay.

For each essential stream, task, decision/question, dependency, and state update, record an item receipt from the write response or a targeted verification. Missing `structuredContent`, `_ui` differences, reordered prose, display-name changes, or non-byte-identical readback are warnings only. Verify uncertain items once by returned ID, stable task key, exact edge, or a bounded list plus targeted get. Retry only an item proven absent under its original operation key. If existence remains ambiguous, keep it pending and reconcile again; do not duplicate it.

Plan PASS requires the independent review record, one receipt for every essential creation including applicable Decision/Question refs, the desired dependency set, correct organization/workspace/stream, available and mapped verifiers, exposed checkpoints, and no material drift from the reviewed draft or approved brief. It never requires exhaustive readback or byte equality.

## Activate or stop

The approved brief is the human creation decision; do not manufacture a second abstract mode or redundant approval when the reviewed graph stays inside it. If the request authorizes plan creation only, persist `planned`, show the created tracker/tasks/checkpoints, and stop without a Goal or executor. A later natural-language request may authorize delivery against the same revision after live revalidation.

For authorized delivery, immediately before activation verify plan ID/revision, current-task supervisor ownership, normalized authority, open questions, checkpoints, routes, capacity, and the first `eligible_safe_ready` frontier. Refresh `get_goal`: adopt an unfinished Goal only when its objective, constraints, verification, and plan identity exactly match; replace a completed Goal; if an unrelated unfinished Goal exists, revise the brief to choose an approved dedicated supervisor before creating any Goal or ask for the material choice. Persist a Goal-creation/adoption intent, establish one Goal, record ownership, then set `active` with `expected_updated_at` and launch only covered child work. A failed state guard launches nothing and enters reconciliation. The user has explicitly requested that Goal by approving a brief which names delivery and Goal ownership; never set `token_budget` unless the user explicitly requested one.

The current user task remains the supervisor and owns the Goal by default. Choose a separate native supervisor only before Goal creation when an existing unrelated Goal or project/worktree/runtime isolation makes inline supervision impossible. Persist one handoff intent, create and reconcile it once, transfer a self-contained packet, prove the source loop fenced, then let the destination create its Goal. Post-creation Goal transfer is prohibited because no supported primitive can fence or transfer an unfinished Goal; a later isolation conflict requires recovery or a new human choice, never false completion/blocking. Then follow [codex-runtime.md](codex-runtime.md) and [codex-supervision.md](codex-supervision.md).
