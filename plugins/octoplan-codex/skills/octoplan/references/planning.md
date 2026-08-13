# Octoplan planning

Use this workflow to capture a request, formalize the project, calibrate the smallest adequate plan, challenge it once, and persist it in Octopad. Durable state and recovery live in [state-and-recovery.md](state-and-recovery.md).

## Contents

- [Entry and recovery](#entry-and-recovery)
- [Clarify and creation brief](#clarify-and-creation-brief)
- [Identity runway](#identity-runway)
- [Draft the graph](#draft-the-graph)
- [Review before activation](#review-before-activation)
- [Persist and verify](#persist-and-verify)
- [Activate or stop](#activate-or-stop)

## Entry and recovery

Start a production Octopad session, read live methodology, and load the exact task or work-stream context. Retrieve only material gaps and inspect native Goals/tasks before proposing execution.

Continue a v6 plan only when its ID, state host, supervisor, and revision reconcile. Reject every other schema and start a new v6 plan from the live mandate; no prior PASS, authority, actor, intent, or control field transfers.

At each safe wake, read the installed skill. A changed contract requires fencing the current effect and replanning under the installed schema. Reconcile several plausible supervisors or state hosts to one evidenced owner before writes or spawns.

## Clarify and creation brief

Collaborate in natural language. The current user task interviews directly; a delegated planner receives a bounded packet and cannot ask the user. Ask together only about facts that can change the outcome, proof, scope, non-goals, constraints, source of truth, ownership, order, authority, artifact profile, protected effect, or delivery route. State assumptions and leave non-material implementation choices to execution.

Formalize one project contract:

- integrated outcome and observable proof;
- scope, non-goals, constraints, authoritative sources, assumptions, and unresolved uncertainties;
- deliverables, owners, artifact profiles, and verifiers;
- organization, workspace, work stream, and native target when delivery needs one; the current task is the default;
- whether approval stops at the plan or authorizes bounded delivery;
- protected effects and effective organization, repository, privacy, security, legal, or publication rules.

Calibrate two axes independently and record a short reason:

| Axis | Value | Use |
|---|---|---|
| Shape | `simple` | One or two coherent deliverables, known method and verifier, no meaningful branching. |
| Shape | `structured` | Several known units, dependencies, owners, or integration points. |
| Shape | `adaptive` | Decomposition or method is uncertain, cross-domain, weakly verified, or likely to replan. |
| Consequence | `reversible` | Internal effect with cheap, reliable rollback. |
| Consequence | `material` | Public, data-bearing, security/privacy-sensitive, or costly to redo. |
| Consequence | `protected` | Irreversible, privileged, financial, regulated, destructive, or separately human-gated. |

Shape controls graph depth, WIP, delegation, and recovery. Plan consequence is the highest consequence in scope and controls plan-review lenses and brief detail. Each task also records its own consequence so delivery review and gates apply only to affected work. They never collapse into one tier: a simple deletion may be protected; a complex internal synthesis may be reversible. When reversibility, permissions, data, or external effect is unclear, raise consequence. Effective rules may only raise either result.

Before any Octopad write, show one localized **brief de création** containing the project contract, both calibration values and reasons, the smallest proposed graph, artifact profiles and verifiers, plan-review route, delivery authority and actor topology, recommended `progressive` or `final` user review, and every human checkpoint. A checkpoint names subject, timing, reason, owner, blocked descendants, safe continuation, expected decision, and exact resume evidence.

Scale presentation, not semantics: one compact block for simple/reversible work; a graph summary for structured or material work; explicit slices, containment, and gates for adaptive or protected work. Recommend progressive review only when an early human choice changes downstream method, governs repeated artifacts, prevents material rework, or controls a protected effect. Otherwise recommend final review. Mandatory rules overlay either cadence.

The user approves or revises in ordinary language. An initial request that explicitly authorizes plan creation and bounded delivery is already the authority source when the brief is a faithful restatement and adds no material choice, target, role, or effect; show the brief and proceed without manufacturing another go. Otherwise wait for approval. Secrets, access changes, destructive actions, spend, merge, migration application, deployment, publication, and acceptance stay separately gated. If a material answer remains open, return one `HUMAN_DECISION` with options and a recommendation. Do not create a Page merely to store the brief.

## Identity runway

Before review or writes, prove the production organization, workspace, intended stream action, current schemas, and disclosed authority. The current task is the default native target. Only when a child or separate supervisor is justified must project identity be proved; repository/worktree evidence applies only to repository-bound targets. If planning moves, persist one bootstrap intent before one create call and reconcile its unique receipt. Incomplete metadata such as `projectId=null` is an evidence gap, not permission to duplicate. A real mismatch or several candidates pauses the affected branch.

## Draft the graph

Start with the first integrated demonstrable result across the critical path. A checkpoint blocks only descendants that need it; independent safe work stays eligible. Completion requires current integrated proof, never a task count.

Use stable `E01` task refs, `C01` checkpoint refs, and `H01` only when a human owns a distinct deliverable artifact—not an approval, review, merge, publication, or other gate. Keep the tracker human-readable: outcome, scope, order, checkpoints, and end condition. Put a material resolved choice in one Decision and an unresolved material choice in one Question with owner and resolution predicate. Do not mirror task status into the tracker.

Shape determines the smallest adequate graph. Designate one real delivery task as the outcome task: it owns or integrates the observable result and hosts compact state. Never add a bookkeeping task.

- `simple`: one coherent task, or two only when ownership, artifact, verifier, or a mandatory rule genuinely differs; prefer inline execution over an unnecessary worker;
- `structured`: explicit dependency graph, integration task or proof, bounded WIP, and conflict declarations only for real shared surfaces;
- `adaptive`: first vertical slice, explicit uncertainty-reduction tasks, bounded planner/recovery use, replan triggers, and failure containment.

Each top-level task is one independently acceptable and reversible delivery unit. Its autonomous manifest includes Why, What, Done when, sources, task consequence, one or more artifact profiles and surfaces, allowed and forbidden effects, verifiers, saved model/effort, dependencies/checkpoints, current artifact dispositions, and `Octoplan operation key: <plan-id>:r<revision>:task:<ref>:g<generation>`. A coherent task may own several profiles—for example research evidence plus its decision memo—when owner, acceptance, dependency, and review remain shared. Split only when those boundaries or useful parallelism differ. Repository artifacts add exact base/head and checks; other profiles use their own version and evidence fields. Persist the manifest hash and increment generation when meaning changes.

Use a strict artifact core—profile, locator, version, state, owner, verifier, evidence, disposition—plus exactly one profile contract per artifact:

- `repository`: repository, base/head, changed surfaces, checks, review, migration/merge state, and backout evidence when a migration is authored;
- `content`: document revision, factual sources, audience, approval and publication target;
- `research`: question, source set, citation coverage, uncertainty and synthesis revision;
- `operations`: target, dry run, approval, execution receipt and rollback evidence.

Profile classifies the artifact, not every effect around it. Publishing a document remains a `content` artifact with a protected publication checkpoint and publication receipt. A migration file or schema change is a `repository` artifact; human application remains its protected checkpoint and records an application receipt. Add an `operations` artifact only when the run, rollout, or rollback exercise is itself a deliverable.

Name a verifier that actually examines every changed surface. Green CI proves only covered paths. Choose each task's review from its own consequence and changed surface: `targeted` for low-risk reversible artifacts, `independent` for material effects, and one `specialist` only for a second orthogonal material domain. The plan-level maximum does not raise every task. A protected task adds its human gate; it does not automatically add reviewer sessions.

## Review before activation

Build one immutable review packet from the mandate-covered brief, calibration, sources, draft graph, manifests, artifact contracts, routes, checkpoints, first integrated result, and completion proof. Give it to one fresh read-only plan reviewer. The reviewer starts a production Octopad session and reads the exact bounded context and effective rules, but treats the immutable packet as the review subject and performs no write, claim, launch, completion, or authority action.

Scale one review session rather than multiplying reviewers:

- always challenge mandate fidelity, missing deliverables or decisions, dependencies, feasible proof, hidden assumptions, and model fit;
- for `structured` or `adaptive`, also challenge critical path, integration, WIP/conflicts, delegation cost, and recovery triggers;
- for `material` or `protected`, also challenge reversibility, access, privacy/security/data, public effects, authority, failure containment, and human gates;
- for `adaptive`, also challenge uncertainty reduction, stopping conditions, cost/latency, and replan feasibility.

Accept only `PASS`, `REVISE`, `INFEASIBLE`, or `HUMAN_DECISION` with packet hash, session, finding keys, executed checks, and evidence. Persist the immutable fresh-review record for that revision. Corrections to stable findings return to the same session and add an optional latest `targeted_recheck`; they never replace the fresh record. A change to outcome, scope, graph, task meaning, authority, route, acceptance, or protected actions creates a new plan revision, a fresh bounded planner when useful, and exactly one new fresh plan-review session. Silence, timeout, unavailable checks, or unfinished review is not PASS.

## Persist and verify

Immediately before writing, read the active Octopad schemas. Once the brief is covered by the user mandate and plan review is PASS, create or adopt the work stream, let Octopad maintain its tracker, and create the reviewed tasks, dependencies, Decisions, and Questions in coherent batches. Append compact state to the reviewed outcome task as defined in [state-and-recovery.md](state-and-recovery.md). Never hand-write system-managed tracker activity or shorten a task to fit a batch.

Use one stable operation key per intended write. A returned ID or explicit receipt confirms it. On incomplete or timed-out output, list once and verify only uncertain items by stable ref, ID, exact edge, or targeted get. Retry only an item proven absent with its original key. Presentation drift is a warning, not failure.

Set `planned` only when every essential creation and edge has a receipt, the saved calibration and task generations match the reviewed packet, verifiers exist, checkpoints are exposed, and no material drift exists from the mandate-covered brief. Exhaustive or byte-identical readback is unnecessary.

## Activate or stop

If approval covers plan creation only, persist `planned`, show the created graph and checkpoints, and stop without a Goal or delivery actor. A later natural-language directive may authorize delivery after live revalidation.

For authorized delivery, revalidate the exact revision, user intent, task generations/manifests, plan-review PASS, supervisor identity and observed Sol route, authority, open questions, checkpoints, artifact versions, and first safe frontier. Call `get_goal`; adopt only the exact unfinished v6 Goal or replace a completed one. If the current task has an unrelated unfinished Goal, never alter it merely to make room: use a disclosed separate supervisor before Goal creation or request direction when that route was not authorized. Persist the action intent, establish one Goal, guard the transition to `active`, and follow [codex-supervision.md](codex-supervision.md). Never set `token_budget` unless the user explicitly requested one.

The current task remains supervisor. Use a separate supervisor only before Goal creation when project or runtime isolation makes inline supervision impossible; persist one handoff intent, reconcile one destination, prove the source loop fenced, then let that destination own the Goal. Never claim to transfer an unfinished Goal through an unsupported primitive.
