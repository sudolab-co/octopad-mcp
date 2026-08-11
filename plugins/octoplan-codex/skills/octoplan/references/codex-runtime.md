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

Only an approved creation brief and reviewed `octoplan-plan-v3` revision may launch. Planning permission never authorizes delivery. Persist the exact source separately from native operations. The brief records whether work stops after plan creation or continues to a bounded outcome, plus `progressive` or `final` initiating-user review; cadence never widens execution authority or removes a protected checkpoint.

Translate the user's natural approval only into the exact native actions, finite roles, environments, child route, Octopad write classes, and effects visibly disclosed in the approved brief. Persisted authority must match that disclosure. Do not ask for a command string or actor-by-actor grant. New action, role, environment, project, projectless target, write class, risk, or protected effect needs a revised brief and authority; a covered revision does not. A Goal never grants broader sandbox, approval, or external-effect authority.

The read-only plan reviewer needs no execution authority and cannot create, persist, claim, or launch.

## Capacity ladder

Choose by detection difficulty and reversibility, then save the exact model, effort, target, and short rationale on each agent task. Review class remains separate from model capacity.

| Work profile | Route |
|---|---|
| Mechanical, deterministic proof | `gpt-5.6-luna · effort max` |
| Bounded product, technical, or editorial judgment | `gpt-5.6-terra · effort high` |
| Difficult but bounded reconciliation | `gpt-5.6-terra · effort max` |
| Open-ended, weakly verified, or high-consequence work | `gpt-5.6-sol · effort xhigh` |
| Open architecture or investigation without a reliable verifier | `gpt-5.6-sol · effort max` |

Planning uses Sol `xhigh`, or justified `max`. The current user task remains on its selected model as supervisor; do not move the plan merely to enforce a route. Every child uses the lightest adequate route. Split separable work, use worktrees for parallel write-capable repository tasks, and never silently substitute a saved route. Unknown or unavailable pairs require a saved correction or material replan.

## Native target and creation

Project identity is material; incomplete native metadata is an evidence defect, not itself a mismatch. Establish it in order:

1. prefer direct native association or the saved project registry;
2. after a targeted create with `projectId=null` or other missing metadata, reuse one unique no-mutation actor only when the persisted target/receipt links its returned task and creation key, and its role packet, saved project-repository mapping, cwd/worktree, Git toplevel, and normalized remote cohere; record branch and HEAD as audit evidence;
3. stop for a real project/repository mismatch, unknown remote/mapping, several candidates, missing creation provenance, pre-identity mutation, or recovery needing secrets, access changes, destructive effects, or a wider target.

No path, prompt, title, or name alone proves identity. Record evidence, registry defect, mutation state, and disposition. Every actor stays in the reconciled project; `local` and `worktree` may differ inside it. An explicit projectless plan stays in its directory. The skill cannot repair native metadata, but a metadata-only anomaly does not block a uniquely reconciled actor.

Before create/message/archive, verify plan and intent revisions, covering source-bound authority, role, target, task ref, route/capability, and supervisor epoch. Persist an action intent before every call; reconcile ambiguous effects by list/read and never blind replay. Never archive the current user task or an adopted session without explicit provenance.

Treat `clientThreadId` as pending setup, not a task identity. Reconcile one exact creation key through native list/read and the identity hierarchy above. Response formatting, display title, or a missing field is not activation evidence and not a reason to create again. Activate only the unique task whose material role packet and project identity are directly or alternatively established.

The role packet names organization, workspace, work stream, task, plan and intent revisions, role, route, target, model, effort, capability, supervisor epoch, plan schema, and minimum Octoplan version. It never pins an exact compatible version. Before acting and at each safe boundary, the actor reads live Octopad state, effective `AGENTS.md`/organization/repository rules, and the installed skill; it records compatible version adoption or requests replan for an incompatible schema.

Use native subagents for bounded planning/review analysis that needs no durable independent branch or user-owned task. Before `create_thread`, refresh `list_projects`; use native tasks with isolated worktrees for durable delivery units and PRs. Follow active tasks with cursor-based `wait_threads`; do not repeatedly read or poll them, schedule heartbeats for them, or create a second supervisor. Use `update_plan` only for the current task's compact working steps, never as shared Octoplan truth, authority, or completion evidence.

## Review routing

Run deterministic checks before judgment. Every delivery task receives its saved check:

- `targeted`: the supervisor or a distinct lightweight reviewer challenges the actual diff/artifact against Done when and runs the named deterministic checks;
- `independent`: one fresh source-first reviewer plus the task's targeted tests;
- `specialist`: one additional fresh reviewer only for a second material and orthogonal failure domain.

Product, code, security, privacy, data, migration, and materially public changes require `independent`. Documentation, internal, and low-risk reversible work may use `targeted`, but the check must inspect the artifact and criteria. A specialist never replaces the lead review.

Reviewers return `PASS`, `REVISE`, `INFEASIBLE`, or `HUMAN_DECISION` with evidence and artifact revision. They do not persist, complete, ask the user, or launch. After correction, targeted-recheck the diff/artifact, stable finding, and affected criteria; rerun full review only after scope/contract change. An integrated candidate spanning components requires integrated review. After two `REVISE` verdicts with the same stable finding key, forbid a blind third loop: diagnose plan, tool, verifier, and route, then repair or replan proportionately.

## Protected checkpoints

Secrets, access grants, destructive effects, spend, required human review, merge, migration application, deployment, publication, and acceptance are protected checkpoints. Embed review/merge in their E task; separately owned human work may use Hxx. Initial authority survives unchanged scope, target, risk, and protected-action set. Verify base, head, effective diff, reviews, and checks technically; classify changes as repair or scope/target/risk/protected-action change before seeking authority. Every occurrence carries the full checkpoint fields from the state contract.

When one checkpoint waits, continue every independent safe frontier. When none remains, set coordination JSON to `waiting-human`, keep its Octopad task `in_progress`, and publish the six-field handoff. A wake supplies evidence only, never authority.

## Launch check

Immediately before launch or resume, reread the coordination task with its concurrency state and verify:

- exact organization, workspace, work stream, project, v3 plan ID/revision, and current intent revision;
- review PASS for that revision and receipts for essential tasks/dependencies;
- current-task supervisor/Goal owner and epoch, exact authority source, compatible installed skill, and unique pending intents;
- covering source-bound authority and exact saved route for the next actor;
- no unresolved material question, conflicting revision, stale directive, or pending checkpoint on that frontier;
- source and verifier availability needed by the next task.

For plan-only scope, stop at `planned` without a Goal. For authorized delivery, call `get_goal` first. Adopt only an unfinished Goal whose objective, constraints, verification, and plan identity exactly match; a completed Goal may be replaced. An unrelated unfinished Goal forces the supervisor route to be resolved in a revised brief before any Goal creation. Persist creation/adoption intent, establish one Goal, record ownership, and transition to `active` using `expected_updated_at`. Set a token budget only when the user explicitly requested one. A failed guard or material mismatch authorizes nothing; otherwise read [codex-supervision.md](codex-supervision.md).

Record authoritative actuals only. Missing time, provider cost, token, tool-call, or compaction telemetry remains unavailable; never estimate it. External adapters are evidence paths, not prerequisites or authority sources.
