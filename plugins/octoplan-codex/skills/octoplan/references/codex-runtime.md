# Codex routing and authority

Read this reference before choosing models, asking for authority, or creating native Codex tasks. Durable identity and intents live in [state-and-recovery.md](state-and-recovery.md).

## Contents

- [Approval and authority](#approval-and-authority)
- [Capacity ladder](#capacity-ladder)
- [Native target and creation](#native-target-and-creation)
- [Review routing](#review-routing)
- [Protected gates](#protected-gates)
- [Launch check](#launch-check)

## Approval and authority

Only an approved `octoplan-plan-v1` revision may launch. Planning permission never authorizes execution. Persist the exact execution-authority source separately from native creation. **Review before delivery** pairs with `revision-approval` and needs current approval of the persisted revision. **Autonomous delivery** pairs with `bounded-outcome` and may launch and replan only inside that confirmed boundary. Switch modes explicitly when the authority changes. A vague “go”, urgency, prior chat, or trust does not widen either mode.

Native task creation is separate. One exact user source may grant the finite roles, Codex project, and environments for the whole plan. Persist that source in the plan state and ask once, not per actor. A new role, environment, project, or projectless target needs new authority; a new revision inside the same grant does not.

The read-only plan reviewer needs no execution authority and cannot create, persist, claim, or launch.

## Capacity ladder

Choose by detection difficulty and reversibility, then save the exact model, effort, target, and short rationale on each agent task. Review class remains separate from model capacity.

| Work profile | Route |
|---|---|
| Mechanical, deterministic proof | `gpt-5.6-luna · effort max` |
| Bounded product, technical, or editorial judgment | `gpt-5.6-terra · effort xhigh` |
| Difficult but bounded reconciliation | `gpt-5.6-terra · effort max` |
| Open-ended, weakly verified, or high-consequence work | `gpt-5.6-sol · effort xhigh` |
| Open architecture or investigation without a reliable verifier | `gpt-5.6-sol · effort max` |

Planning uses Sol `xhigh`, or justified `max`. A dedicated supervisor uses Terra `xhigh` by default and raises capacity only for real reconciliation ambiguity. Split separable work; never silently substitute a saved route. Unknown or unavailable pairs trigger a saved route correction or material replan, not an actor-side guess.

## Native target and creation

Native metadata or the project registry must prove the planning target. A path, prompt, or matching name is not proof. Every supervisor, planner, executor, reviewer, recovery, and follow-up stays in that exact project; `local` and `worktree` may differ inside it. An explicit projectless plan stays in its exact directory. Cross-project or project/projectless substitution stops before creation.

Before each create, verify the plan ID/revision, covering grant, role, target, model/effort, task ID/ref, required capability, and current supervisor epoch; reconcile plausible existing native tasks; persist the creation intent from [state-and-recovery.md](state-and-recovery.md); then call native create once only when no exact actor already exists.

Treat `clientThreadId` as pending setup, not a task identity. Reconcile one exact creation key through native list/read. Response formatting, display title, or a missing field is not activation evidence and not a reason to create again. Activate only the unique task whose material role packet and project match.

The role packet names organization, workspace, work stream, task, approved revision, role, route, target, model, effort, capability, and supervisor epoch. It is explicit working context, not a byte-level contract. The actor enters Octopad using those IDs and reads its live task before acting.

## Review routing

Every delivery task receives its saved check:

- `targeted`: the supervisor or a distinct lightweight reviewer challenges the actual diff/artifact against Done when and runs the named deterministic checks;
- `independent`: one fresh source-first reviewer plus the task's targeted tests;
- `specialist`: one additional fresh reviewer only for a second material and orthogonal failure domain.

Product, code, security, privacy, data, migration, and materially public changes require `independent`. Documentation, internal, and low-risk reversible work may use `targeted`, but the check must inspect the artifact and criteria. A specialist never replaces the lead review.

Reviewers return `PASS`, `REVISE`, `INFEASIBLE`, or `HUMAN_DECISION` with evidence and the artifact revision checked. They do not persist PASS, complete tasks, ask the user, or launch successors. A changed artifact invalidates its prior PASS. After a correction, recheck the finding and affected criteria; rerun the whole review only after a contract or scope change.

## Protected gates

Secrets, access grants, destructive effects, external spend, merge, migration application, deployment, publication, and acceptance are distinct human occurrences. Delivery mode and plan approval never satisfy them. Each has a human task, owner, target/effect, evidence, and resume predicate.

When one gate waits, continue every independent safe frontier. When none remains, record `waiting-human` and publish the six-field handoff. A wake supplies evidence only and never authority.

## Launch check

Immediately before launch or resume, reread the coordination task with its concurrency state and verify:

- exact organization, workspace, work stream, project, plan ID, and approved revision;
- review PASS for that revision and receipts for essential tasks/dependencies;
- supervisor owner/epoch, exact execution-authority source, and unique pending creation intents;
- covering finite creation grant and exact saved route for the next actor;
- no unresolved material question, conflicting revision, or protected gate on that frontier;
- source and verifier availability needed by the next task.

Without execution approval, show the plan and ask once. With valid approval, record the transition to `active` using `expected_updated_at`, then read [codex-supervision.md](codex-supervision.md). A failed guard or material mismatch authorizes nothing.

Record authoritative actuals only. Missing time or provider cost remains unavailable; never estimate it. External event adapters are optional evidence paths, not plan prerequisites or authority sources.
