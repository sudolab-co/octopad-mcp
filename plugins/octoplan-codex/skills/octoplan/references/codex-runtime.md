# Codex routing and authority

Read this reference before choosing models, asking for authority, or creating native Codex tasks. Durable identity and intents live in [state-and-recovery.md](state-and-recovery.md).

## Contents

- [Approval and authority](#approval-and-authority)
- [Capacity ladder](#capacity-ladder)
- [Native target and creation](#native-target-and-creation)
- [Review routing](#review-routing)
- [Protected checkpoints](#protected-checkpoints)
- [Launch check](#launch-check)

## Approval and authority

Only an approved creation brief and reviewed `octoplan-plan-v5` revision may launch. Planning permission never authorizes delivery. Persist the exact source separately from native operations. The brief records whether work stops after plan creation or continues to a bounded outcome, plus `progressive` or `final` initiating-user review; cadence never widens execution authority or removes a protected checkpoint.

Translate the user's natural approval only into the exact native actions, finite roles, environments, child route, Octopad write classes, and effects visibly disclosed in the approved brief. Persisted authority must match that disclosure. Do not ask for a command string or actor-by-actor grant. New action, role, environment, project, projectless target, write class, risk, or protected effect needs a revised brief and authority; a covered revision does not. A Goal never grants broader sandbox, approval, or external-effect authority.

The read-only plan reviewer needs no execution authority and cannot create, persist, claim, or launch.

## Capacity ladder

Choose by detection difficulty and reversibility, then save the exact model, effort, target, and short rationale on each agent task. Review class remains separate from model capacity.

| Work profile | Route |
|---|---|
| Mechanical, deterministic proof | `gpt-5.6-luna · effort max` |
| Bounded product, technical, editorial, review, or supervision judgment | `gpt-5.6-sol · effort high` |
| Difficult, open-ended, weakly verified, or high-consequence work | `gpt-5.6-sol · effort xhigh` |
| Open architecture or investigation without a reliable verifier | `gpt-5.6-sol · effort max` |

The only valid automatic routes are Luna `max` and Sol `high|xhigh|max`; Terra, Luna below `max`, Sol below `high`, unknown, and unavailable pairs pause for saved correction or material replan without substitution. Planning uses Sol `xhigh`, or justified `max`. A supervisor needs observed Sol `high` or above; if the current task is below the floor, select a disclosed compliant supervisor before Goal creation, otherwise pause. Split separable work and use worktrees for parallel writes.

## Native target and creation

Project identity is material; incomplete native metadata is an evidence defect, not itself a mismatch. Establish it in order:

1. prefer direct native association or the saved project registry;
2. after a targeted create with `projectId=null` or other missing metadata, reuse one unique no-mutation actor only when the persisted target/receipt links its returned task and creation key, and its role packet, saved project-repository mapping, cwd/worktree, Git toplevel, and normalized remote cohere; record branch and HEAD as audit evidence;
3. stop for a real project/repository mismatch, unknown remote/mapping, several candidates, missing creation provenance, pre-identity mutation, or recovery needing secrets, access changes, destructive effects, or a wider target.

No path, prompt, title, or name alone proves identity. Record evidence, registry defect, mutation state, and disposition. Every actor stays in the reconciled project; `local` and `worktree` may differ inside it. An explicit projectless plan stays in its directory. The skill cannot repair native metadata, but a metadata-only anomaly does not block a uniquely reconciled actor.

Before create, validate a creation packet with current plan/intent, epoch, authority, identity/target/role, task generation, manifest, capability, planned route, and fresh stack; observed route/readback do not exist yet. After creation and before any work message, claim, or effect, require `actor_binding_readback` plus observed model/effort and route evidence matching that packet. Runtime observation controls admission; missing/mismatched evidence permits only stop/rebind/recovery. Persist intents and reconcile ambiguity without replay. After PASS/reconciliation, archive every completed executor while preserving waiters.

Treat `clientThreadId` as pending setup, not a task identity. Reconcile one exact creation key through native list/read and the identity hierarchy above. Response formatting, display title, or a missing field is not activation evidence and not a reason to create again. Activate only the unique task whose material role packet and project identity are directly or alternatively established.

The role packet carries the complete binding, bounded manifest, schema, minimum version, and context-admission trigger state. The actor reads it from durable state, acknowledges `manifest_hash`, and cannot use predecessor conversation as contract. At safe boundaries, read live Octopad state, effective rules, and the installed skill; record compatible adoption or replan an incompatible schema.

Use native subagents for bounded planning/review analysis that needs no durable independent branch or user-owned task. Material replanning and volumetric diagnosis always use a fresh PLN lease; the supervisor consumes its bounded output instead of raw trace/source history. Before `create_thread`, refresh `list_projects`; use native tasks with isolated worktrees for durable delivery units and PRs. Follow active tasks with cursor-based `wait_threads`; do not repeatedly read or poll them, schedule heartbeats for them, or create a second supervisor. Use `update_plan` only for the current task's compact working steps, never as shared Octoplan truth, authority, or completion evidence.

## Review routing

Run deterministic checks before judgment. Every delivery task receives its saved check:

- `targeted`: the supervisor or a distinct lightweight reviewer challenges the actual diff/artifact against Done when and runs the named deterministic checks;
- `independent`: one fresh source-first reviewer plus the task's targeted tests;
- `specialist`: one additional fresh reviewer only for a second material and orthogonal failure domain.

Product, code, security, privacy, data, migration, and materially public changes require `independent`. Documentation, internal, and low-risk reversible work may use `targeted`, but the check must inspect the artifact and criteria. A specialist never replaces the lead review.

Reviewers return `PASS`, `REVISE`, `INFEASIBLE`, or `HUMAN_DECISION` with evidence and artifact revision. They do not persist, complete, ask the user, or launch. After correction, targeted-recheck the diff/artifact, stable finding, and affected criteria; rerun full review only after scope/contract change. An integrated candidate spanning components requires integrated review. After two `REVISE` verdicts with the same stable finding key, forbid a blind third loop: diagnose plan, tool, verifier, and route, then repair or replan proportionately.

Persist `review_type`, fresh reviewer session, reviewed plan/task generation, artifact hash, stable finding keys, executed checks, and verdict. `full_independent_fresh` is mandatory after scope, graph, contract, route, acceptance, or generation changes; `targeted_recheck` may reuse the same reviewer only for stable findings on the same artifact/generation with no material delta. Count sessions and passes separately.

## Protected checkpoints

Secrets, access grants, destructive effects, spend, required human review, merge, migration application, deployment, publication, and acceptance are protected checkpoints. Embed review/merge in their E task; separately owned human work may use Hxx. Initial authority survives unchanged scope, target, risk, and protected-action set. Verify base, head, effective diff, reviews, and checks technically; classify changes as repair or scope/target/risk/protected-action change before seeking authority. Every occurrence carries the full checkpoint fields from the state contract.

When one checkpoint waits, continue every independent safe frontier. When none remains, set coordination JSON to `waiting-human`, keep its Octopad task `in_progress`, and publish the six-field handoff. A wake supplies evidence only, never authority.

## Launch check

Immediately before launch or resume, reread the coordination task with its concurrency state and verify:

- exact organization, workspace, work stream, project, v5 plan ID/revision, and current intent revision;
- review PASS for that revision and receipts for essential tasks/dependencies;
- current-task supervisor/Goal owner and epoch, exact authority source, compatible installed skill, current planner/context leases, and unique pending intents;
- covering authority, exact binding/manifest, observed-route admission, actor-bound baseline lease, fresh source-stack snapshot, and delivery-artifact disposition for the next actor;
- no unresolved material question, conflicting revision, stale directive, or pending checkpoint on that frontier;
- source and verifier availability needed by the next task.

Before writer creation/claim and again before its first source effect, snapshot main, every stacked base/head and ancestry, effective diffs, migration registry, checks, verifier coverage, timestamp, and explicit TTL. Save a PASS admission/readback and refresh `runtime.admission_checked_at`; an actionable writer's snapshot must remain fresh at that instant. Hold that baseline through bounded work and refresh only before dispatch, first effect, push, review, handoff, or an evidenced collision. Drift blocks writer activation and triggers targeted refresh/replan; non-overlapping drift alone never invalidates accepted work or forces a treadmill, and explicitly bounded read-only analysis may continue. Never dispatch a writer first and inspect drift later.

For plan-only scope, stop at `planned` without a Goal. For authorized delivery, call `get_goal` first. Adopt only an unfinished v5 Goal whose objective, constraints, verification, and plan identity exactly match; a completed Goal may be replaced. A Goal from a legacy schema keeps v5 `paused` with no launch until its saved owner reaches a genuine terminal state; if that cannot be achieved in scope, request the lifecycle decision rather than falsely completing/blocking or creating a competitor. An unrelated unfinished Goal likewise requires resolution before creation. Then persist intent, establish one Goal, record ownership, and set `active` under `expected_updated_at`. Set a token budget only when explicitly requested.

Record typed metric snapshots only: metric, value or `unavailable`, source, population, and time window. Keep sessions, review passes, retries, compactions, resumes, elapsed time, tool calls, and tokens separate; never add heterogeneous counters or estimate provider cost. Telemetry is operational: compaction/superseded intent or two comparable cycles without accepted progress requires context/efficiency admission before more substantive work. External adapters are evidence paths, not prerequisites or authority sources.
