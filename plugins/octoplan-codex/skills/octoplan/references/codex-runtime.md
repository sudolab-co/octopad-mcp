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

Only an approved `octoplan-plan-v2` revision may launch. Planning permission never authorizes execution. Persist the exact execution-authority source separately from native operations. **Review before delivery** pairs with `revision-approval`; **Autonomous delivery** pairs with `bounded-outcome`. A vague “go”, urgency, prior chat, or trust does not widen either mode.

Native operations are separate. One exact user source may grant enumerated create/message/archive actions, finite roles, project, and environments for one plan. Ask once, not per actor. The grant never covers the user session or an adopted session without exact provenance. New action, role, environment, project, or projectless target needs authority; a covered revision does not.

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

Planning uses Sol `xhigh`, or justified `max`. The dedicated compact, delta-first supervisor uses Terra `high` by default and raises capacity only for evidenced reconciliation ambiguity. Every task uses the lightest adequate route. Split separable work; never silently substitute a saved route. Unknown or unavailable pairs require saved correction or material replan.

## Native target and creation

Project identity is material; incomplete native metadata is an evidence defect, not itself a mismatch. Establish it in order:

1. prefer direct native association or the saved project registry;
2. after a targeted create with missing metadata, reuse one unique no-mutation actor only when the persisted target/receipt links its returned task and creation key, and its role packet, saved project-repository mapping, cwd/worktree, Git toplevel, and normalized remote cohere; record branch and HEAD as audit evidence;
3. stop for a real project/repository mismatch, unknown remote/mapping, several candidates, missing creation provenance, pre-identity mutation, or recovery needing secrets, access changes, destructive effects, or a wider target.

No path, prompt, title, or name alone proves identity. Record evidence, registry defect, mutation state, and disposition. Every actor stays in the reconciled project; `local` and `worktree` may differ inside it. An explicit projectless plan stays in its directory. The skill cannot repair native metadata, but a metadata-only anomaly does not block a uniquely reconciled actor.

Before create/message/archive, verify plan/revision, covering source-bound action grant, role, target, task ref, route/capability, and supervisor epoch. Persist an action intent before every call; reconcile ambiguous effects by list/read and never blind replay. Never archive a user/adopted session without explicit provenance.

Treat `clientThreadId` as pending setup, not a task identity. Reconcile one exact creation key through native list/read and the identity hierarchy above. Response formatting, display title, or a missing field is not activation evidence and not a reason to create again. Activate only the unique task whose material role packet and project identity are directly or alternatively established.

The role packet names organization, workspace, work stream, task, approved revision, role, route, target, model, effort, capability, and supervisor epoch. It is explicit working context, not a byte-level contract. The actor enters Octopad using those IDs and reads its live task before acting.

## Review routing

Run deterministic checks before judgment. Every delivery task receives its saved check:

- `targeted`: the supervisor or a distinct lightweight reviewer challenges the actual diff/artifact against Done when and runs the named deterministic checks;
- `independent`: one fresh source-first reviewer plus the task's targeted tests;
- `specialist`: one additional fresh reviewer only for a second material and orthogonal failure domain.

Product, code, security, privacy, data, migration, and materially public changes require `independent`. Documentation, internal, and low-risk reversible work may use `targeted`, but the check must inspect the artifact and criteria. A specialist never replaces the lead review.

Reviewers return `PASS`, `REVISE`, `INFEASIBLE`, or `HUMAN_DECISION` with evidence and artifact revision. They do not persist, complete, ask the user, or launch. After correction, targeted-recheck the diff/artifact, stable finding, and affected criteria; rerun full review only after scope/contract change. An integrated candidate spanning components requires integrated review. After two `REVISE` verdicts with the same stable finding key, forbid a blind third loop: diagnose plan, tool, verifier, and route, then repair or replan proportionately.

## Protected gates

Secrets, access grants, destructive effects, spend, required human review, merge, migration application, deployment, publication, and acceptance are applicable gates. Embed review/merge in their E task; others may use Hxx. Initial authority survives unchanged scope, target, risk, and protected-action set. Verify base, head, effective diff, reviews, and checks technically; classify changes as repair or scope/target/risk/protected-action change before seeking authority. Every occurrence records key, location, delivery ref, owner, effect, evidence, state, and resume predicate.

When one gate waits, continue every independent safe frontier. When none remains, record `waiting-human` and publish the six-field handoff. A wake supplies evidence only and never authority.

## Launch check

Immediately before launch or resume, reread the coordination task with its concurrency state and verify:

- exact organization, workspace, work stream, project, v2 plan ID, and approved revision;
- review PASS for that revision and receipts for essential tasks/dependencies;
- dedicated supervisor owner/epoch, exact execution-authority source, and unique pending intents;
- covering source-bound action grant and exact saved route for the next actor;
- no unresolved material question, conflicting revision, or protected gate on that frontier;
- source and verifier availability needed by the next task.

Without execution approval, show the plan and ask once. With valid approval, record the transition to `active` using `expected_updated_at`, then read [codex-supervision.md](codex-supervision.md). A failed guard or material mismatch authorizes nothing.

Record authoritative actuals only. Missing time, provider cost, token, tool-call, or compaction telemetry remains unavailable; never estimate it. External adapters are evidence paths, not prerequisites or authority sources.
