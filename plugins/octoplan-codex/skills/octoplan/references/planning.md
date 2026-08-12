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

Continue exactly one live `octoplan-plan-v5`. A greenfield request creates one. For v1-v4, 10.x, unknown, partial, or conflicting state, load [octoplan-contract-v5.md](octoplan-contract-v5.md), enumerate known live supervisors/Goals, persist a source-bound migration notice, fence affected old execution, recover the confirmed mandate and useful artifacts, then create a fresh v5 plan. Never assume installation propagated the correction or inherit PASS, authority, actor eligibility, creation intents, supervisor ownership, or launch state.

At each safe wake, compare the loaded skill version with the installed Octoplan version. Fully read and adopt a compatible v5 update, recording the transition before further action. A breaking major, higher schema, or incompatible invariant requires material replan; a role packet's minimum version is not a permanent pin.

If two plausible planners, ledgers, streams, or native sessions claim the same plan, reconcile them before writing or creating. Adopt the unique evidenced owner; pause only when the duplicate is materially unreconcilable.

## Clarify and creation brief

Collaborate in natural language. The current user task interviews directly; `roles/planner.md` is for a delegated planner that cannot ask the user. Initial planning may stay interactive, but every material replan after activation uses one fresh planner lease bound to plan revision, candidate hash, intent revision, and a bounded source snapshot. Ask together only what can change scope, success, risk, order, ownership, validation, identity, protected effects, or post-plan delivery; follow up only when an answer exposes a new material ambiguity. Inspect `get_goal` before recommending the native route.

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
- **Delivery/route/lifecycle:** bounded delivery; current task supervises one Goal; one worktree executor/reviewer; archive completed executors after PASS/reconciliation, preserving every pending session.
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

Optimize explicit critical-path rank and persist `parallel_safe_now`, `blocked_on_artifact_refs`, and `write_conflict_set`. Eligibility requires ready dependencies, authority, admitted route, fresh stack, capability, budget, and no conflict in files, symbols, artifacts, migrations, lockfiles, scarce resources, checkpoints, routes, or budgets. Read-only preflight may advance on an explicitly bounded baseline lease; writers obey DAG/WIP and conflicts. Refresh that baseline only before dispatch, first source effect, push/review/handoff, or an evidenced collision. Bound plan/task WIP, actors, retry/correction loops, review actors/checks, and batch size; never require all-ready activation—reconcile then backfill.

Every task generation has a bounded autonomous manifest: literal **Why**, **What**, and top-level **Done when**; sources/interfaces; files/surfaces; budgets; allowed/forbidden effects; exact base/stack; verifier matrix; admitted model/effort; dependencies/checkpoints; artifact disposition `adopt|reject|rewrite`; predecessor-context restrictions; impact fields; and `Octoplan operation key: <plan-id>:r<revision>:task:<ref>:g<generation>`. Persist `manifest_hash`; a fresh actor must acknowledge the exact manifest without reading its predecessor.

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

For a material replan, first create one fresh read-only planner with a durable lease and exact `input_snapshot_hash`; expire every prior planner lease, require a bounded consolidated proposal, record prior-artifact dispositions and output hash, and archive it after supervisor adoption/rejection. Two material replans without accepted progress, or a return to a prior graph hash, opens `replan_incident` and forbids another incremental mutation until that fresh proposal diagnoses plan, context, route, verifier, baseline, and delivery units.

Give one fresh read-only plan reviewer the complete draft, manifests, approved brief, sources, critical path, integrated candidate, frontiers, budgets, routes, checkpoints, global proof, and review classes. Admit its observed route under [codex-runtime.md](codex-runtime.md): Luna only at `max`, Sol at `high` or above; Terra, lower, unknown, unavailable, or unobserved routes pause. Ask it to challenge outcome coverage, delivery-unit size, task generations, planner lease, manifest autonomy, dependencies, model fit, authority, organization rules, verifier coverage, artifact debt, adjacent failure modes, protected actions, feasibility, and orchestration.

Accept only an explicit evidenced verdict. Use `full_independent_fresh` for the initial plan and after any material scope, graph, contract, route, acceptance, or generation change. Use `targeted_recheck` with the same reviewer only for stable finding keys on the same artifact/generation with no material delta. Silence, timeout, unavailable checks, or unfinished review is not PASS.

Record review type, reviewer session, reviewed revision/generation, artifact hash, finding keys, executed checks, verdict, corrections, and risks. Count one reviewer with several passes as one session and several passes. The reviewer never writes Octopad, creates actors, or grants authority.

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

For authorized delivery, immediately before activation verify plan/revision, generations/manifests, planner lease/output, supervisor ownership and observed Sol-high-or-above route, authority, questions, checkpoints, capacity, stack freshness, artifact debt, and the first safe frontier. Refresh `get_goal`: adopt only an exact unfinished v5 Goal; replace a completed Goal; keep v5 paused while a legacy Goal remains unfinished, resolving its lifecycle without false completion/blocking or a competitor; resolve other unrelated Goals before creation. Persist intent, establish one Goal, set `active` under `expected_updated_at`, and launch only covered work. A failed guard launches nothing; never set `token_budget` unless the user explicitly requested one.

The current user task remains the supervisor and owns the Goal by default. Choose a separate native supervisor only before Goal creation when an existing unrelated Goal or project/worktree/runtime isolation makes inline supervision impossible. Persist one handoff intent, create and reconcile it once, transfer a self-contained packet, prove the source loop fenced, then let the destination create its Goal. Post-creation Goal transfer is prohibited because no supported primitive can fence or transfer an unfinished Goal; a later isolation conflict requires recovery or a new human choice, never false completion/blocking. Then follow [codex-runtime.md](codex-runtime.md) and [codex-supervision.md](codex-supervision.md).
