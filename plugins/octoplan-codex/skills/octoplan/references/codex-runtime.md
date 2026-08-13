# Codex routing and authority

Read this reference before choosing models, asking for authority, or spawning native Codex work. Compact identity and action intents live in [state-and-recovery.md](state-and-recovery.md).

## Contents

- [Approval and authority](#approval-and-authority)
- [Capacity ladder](#capacity-ladder)
- [Native target and creation](#native-target-and-creation)
- [Review routing](#review-routing)
- [Protected checkpoints](#protected-checkpoints)
- [Launch check](#launch-check)

## Approval and authority

Only a creation brief covered by an explicit user mandate and a reviewed `octoplan-plan-v6` revision may launch. A precise initial plan-and-deliver request covers a faithful brief without a redundant confirmation; planning-only permission never authorizes delivery. Translate the mandate into exactly the disclosed native actions, roles, targets, Octopad write classes, and effects. A new target, risk, role, action, or protected effect needs revised authority; a Goal never widens sandbox, approval, or external-effect authority.

Read-only planners and reviewers need no delivery authority. They still start a production Octopad session and read the exact bounded context and effective rules; they cannot write, claim, launch, complete, or grant authority.

## Capacity ladder

Choose by detection difficulty and reversibility, then save the exact model, effort, target, and short rationale on every spawned task. Calibration and review class remain separate from model capacity.

| Work profile | Route |
|---|---|
| Mechanical, deterministic proof | `gpt-5.6-luna · effort max` |
| Bounded product, technical, editorial, review, or supervision judgment | `gpt-5.6-sol · effort high` |
| Difficult, open-ended, weakly verified, or high-consequence work | `gpt-5.6-sol · effort xhigh` |
| Open architecture or investigation without a reliable verifier | `gpt-5.6-sol · effort max` |

The only valid automatic routes are Luna `max` and Sol `high|xhigh|max`; Terra, Luna below `max`, Sol below `high`, unknown, unavailable, or unobserved pairs pause without substitution. Planning uses Sol `xhigh`, or justified `max`. A supervisor needs observed Sol `high` or above. The plan reviewer follows the same ladder: bounded plan judgment normally uses Sol `high`, with `xhigh|max` when difficulty or consequence warrants it. Keep the exact mapping; do not replace it with a vague capability label.

## Native target and creation

The current task is the default native target and needs no invented project. Prove project identity only when a child or separate supervisor is justified, using direct native association or native task/project list-read evidence; do not depend on a hidden registry. For repository work, also bind repository and cwd/worktree; other profiles bind their actual source or destination. When metadata is incomplete, adopt one unique no-mutation actor only if its creation key, returned task, target mapping, Octopad context, and applicable source identity cohere. A real mismatch, several candidates, pre-identity mutation, or unknown mapping pauses that branch. A path, prompt, or title alone proves nothing.

Before create, persist one action intent and validate a bounded role packet containing plan and intent revisions, supervisor epoch, authority, organization/workspace/task, task generation, manifest hash, artifact profiles/versions, target, planned route, and required Octopad context. After creation and before work or effects, require a matching binding readback, production Octopad session/context receipt, and observed model-effort evidence from native turn/session metadata or authoritative task readback. Prompt text, title, or the requested route is not observation. If the host exposes no actual pair, the affected actor pauses. Missing or mismatched evidence permits only stop or recovery.

Treat `clientThreadId` as pending setup, not identity. Reconcile one exact creation key through native list/read; never create again because response formatting or one field is missing. An actor follows its packet, not predecessor conversation.

Use a native subagent for bounded read-only planning or review. Use a native task/worktree only when durable isolation, user-visible continuation, or independent writes justify it. Simple sequential work stays with the supervisor when delegation would add cost without value. Parallelize only independent tasks; follow native tasks with cursor-based waits. `update_plan` is local working memory, never shared Octoplan truth.

## Review routing

Run deterministic checks before judgment. `targeted` challenges the actual artifact and Done when with named checks. `independent` adds one fresh source-first reviewer. `specialist` adds one fresh reviewer only for a second orthogonal material failure domain. Consequence sets the floor, while effective rules and changed surface may raise it.

Reviewers enter the exact Octopad context read-only and return `PASS`, `REVISE`, `INFEASIBLE`, or `HUMAN_DECISION` with artifact versions, evidence, checks, and stable finding keys. Corrections return to the same reviewer only when task generation, artifact contract, and scope remain stable. A material change requires fresh review. After two `REVISE` verdicts with the same key, diagnose plan, tool, verifier, and route before another loop.

## Protected checkpoints

Secrets, access grants, destructive effects, spend, required human review, merge, migration application, deployment, publication, and acceptance are protected `Cxx` checkpoints in the owning delivery task. Use an `Hxx` task only when a human owns a distinct deliverable artifact; an approval, review, merge, publication, or other gate is never an `Hxx` task. Initial authority survives only while scope, target, consequence, and protected-action set remain unchanged. Verify the actual subject technically before asking its owner.

When one checkpoint waits, continue every independent safe frontier. When none remains, set control status to `waiting-human`, keep the affected delivery task open, and publish the six-field handoff. A wake supplies evidence only, never authority.

## Launch check

Immediately before launch or resume, reread the state host and verify exact production identity, v6 plan and intent revisions, plan-review PASS, supervisor/Goal owner and epoch, authority, task generation/manifest, observed route, Octopad context, artifact versions, open checkpoints, pending actions, source availability, and verifier availability. Derive the current safe frontier from live dependencies and active actors.

Repository work additionally refreshes exact repository/base/head and relevant checks before dispatch, first source mutation, push, review, and handoff. Content, research, and operations use their profile version and verifier evidence instead; never invent a Git snapshot for them. Material drift blocks only affected work and triggers refresh or replan.

Plan-only stops at `planned` without a Goal. Authorized delivery calls `get_goal`, adopts only the exact unfinished v6 Goal, and replaces a completed one. Never mutate an unrelated unfinished Goal to make room: choose a disclosed separate supervisor before Goal creation, or ask for direction if that route lacks authority. Then persist the action intent, establish one Goal, record its owner, and guard the transition to `active`. Set a token budget only when the user explicitly requested one.
