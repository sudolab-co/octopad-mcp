# Codex runtime

Load only in Codex. Apply common [planning](planning.md), [supervision](supervision.md) and [recovery](recovery.md); this profile adds native mechanics and compatibility.

## Exact routes

Select workers by the judgment remaining after preparation. Consider Luna `max` first, including substantial implementation with settled choices and reliable checks; record why another route is needed. These are routing defaults, not measured cost rankings. Save exact model, effort and reason.

| Role or remaining work | Default route |
|---|---|
| Planner | `gpt-6-astra · effort xhigh` |
| Supervisor | `gpt-5.6-sol · effort high` |
| Worker: settled choices and reliable verification | `gpt-5.6-luna · effort max` |
| Worker: bounded judgment beyond that first candidate | `gpt-6-astra · effort low` |
| Worker: several unresolved reasoning steps in a prepared task | `gpt-6-astra · effort medium` |
| Reviewer: bounded verification with reliable checks | `gpt-5.6-sol · effort high` |
| Worker or reviewer: difficult reasoning or hard-to-detect errors | `gpt-6-astra · effort high` |
| Worker or reviewer: weak verification or high consequences | `gpt-6-astra · effort xhigh` |

These defaults do not override an explicit user choice of an available model and effort. Record that choice and reason; capability, independent-review and evidence requirements still apply.

Astra `max` is exceptional after diagnosis, never automatic. Default role admission: planner = Astra `xhigh|max`; supervisor = Sol `high`; worker = Luna `max` or Astra `low|medium|high|xhigh|max`; reviewer = Sol `high` or Astra `high|xhigh|max`. Review floors do not depend on worker price. Repair insufficient preparation before escalating effort.

Saved v18 routes valid under 1.3.0 remain valid: Luna workers `max`; Sol planners `xhigh|max`, supervisors, reviewers and workers `high|xhigh|max`; Astra planners and supervisors `xhigh|max`, reviewers `high|xhigh|max`, workers `low|medium|high|xhigh|max`. Keep exact saved values, including active actors. A saved-route change returns to Plan and affected review before dispatch; unavailable or invalid routes pause only the affected actor. Never substitute silently.

Native evidence exposing model and effort must match the saved values exactly. Positive mismatch pauses that actor. Requested settings, prompts and titles are declarations, not observations. Where native metadata is absent, continue with the declared route and record once on the first affected receipt that it is not independently observable here; missing metadata alone is neither a failed review nor `INFEASIBLE`. Reusing a session for a role requires a matching saved route under this same rule; prompting cannot change its model.

## Parent relay and fresh supervisor

Before offering automatic delivery, inspect exposed tools: fresh child creation at the saved route, delegation by that child, and native follow-up, wait, status and stop. Declarations show capabilities, not successful end-to-end handoff. A missing capability requires the precise [manual fallback](continuation.md) at mode choice, without an autonomous-continuation promise. Explain at that choice that automatic continuation depends on the parent runtime staying active; an open conversation in the sidebar is not proof of a running parent. While Delivery still requires that parent to collect or resume an actor, ending its turn requires demonstrated native wake-up support or the declared manual fallback, never a promise to continue later. A proved outcome or legitimate wait with no independent safe work can end the turn under common supervision.

For repository work, verify the intended repository and working directory before dispatch. An explicitly requested new task uses the matching `list_projects` project through `create_thread`, not `projectless`. Honor the user's destination; otherwise choose `worktree` if `isGitRepository` is true, `local` if false. A returned `clientThreadId` means setup is pending: wait for a real `threadId` before follow-up or delivery, then verify the task's project and directory.

For multiple streams, apply [multi-stream.md](multi-stream.md). Default to a common supervisor. Qualify launch, nested delegation, follow-up, wait/status, stop and replacement for each proposed boundary using actual tool permissions and native evidence; reuse still-compatible qualification, and repeat only evidence invalidated by a runtime change. Reserve capacity for workers and reviewers: with four shared slots, a parent plus three supervisors leaves none for task work. Use fewer simultaneous supervisors or the common owner rather than launching a topology that cannot advance.

The parent routes returns, answers and dependency-clearance events to the correct recorded owner, using `collaboration.list_agents`, `collaboration.wait_agent`, `collaboration.send_message` and `collaboration.followup_task` as applicable. Apply return and replacement guards separately to every boundary. A local finish does not retire other owners or finish integration. The cross-stream coordinator initiates affected Plan repair; the parent may act as that planner without taking delivery ownership. There is no extra global supervisor.

After the reviewed Plan is visible and authority holds:

1. Launch one supervisor per approved disjoint boundary with `collaboration.spawn_agent`, `fork_turns: "none"`, and the exact saved model and `reasoning_effort`. Its bounded prompt gives the owned stream identities and boundary, organization/workspace, authorization and ownership pointers, plus indispensable environment facts absent from Octopad. Creation needs a returned identity or authoritative reconciliation before retry.
2. The child rereads Octopad, claims the guarded supervisor Decision, and delegates workers/reviewers under common supervision. It never starts another supervisor.
3. The parent handles every supervisor return using the rules below, then relays bounded reports and human escalations without altering the decision. Deliver later user answers using `collaboration.followup_task`, which resumes an idle child; `collaboration.send_message` can reach a running child. The parent does not dispatch delivery workers or close tasks.
4. Apply common recovery at handoff. Use native status and, when needed, `collaboration.interrupt_agent`, then verify cessation before launching a replacement with `fork_turns: "none"`. The successor reconciles actors/effects and claims ownership using current `expected_updated_at`. A missing response or saved handoff does not prove cessation; uncertainty holds that boundary.

Keep pending user answers until the successor is identified, then forward their exact scope and source; never wake the retired owner. The original parent may repair the Plan on the supervisor's bounded request without taking delivery ownership.

The child route creates no user-owned native task. Bounded receipts and native compaction reduce parent context; they do not replace that parent after its runtime ends. User stop wins; agents and Goals guarantee nothing after closure. Add no worker loop, hook or scheduler. Scheduled external-wait follow-up requires its own explicit request.

### Handle returns without losing the supervisor

The parent's job includes resuming a supervisor that returned prematurely, not only forwarding user answers. A native `completed` or idle child means its turn ended, not that Delivery is complete. On each return, reconcile the latest user instruction, recorded mandate and owner, bounded receipt, and native actor state before choosing. User stop or pause takes precedence even before persistence: send no continuation or reconciliation request while it applies. Never resume an owner with pending or recorded retirement/handoff; use recovery instead. Gates and actual limits affecting the requested action must be cleared before that action resumes.

- **Running:** wait with `collaboration.wait_agent`. A timeout proves neither completion nor failure; refresh status with `collaboration.list_agents` when needed and wait again. Unless this host has demonstrated wake-up after the parent's final response, keep that wait in the active turn. Send progress and answers to status questions in commentary, then resume the wait; do not end with a promise to continue.
- **Premature return:** after those guards, if the same healthy owner is in a resumable ended-turn state (`completed` or idle, as supported by the native follow-up capability), its mandate still holds and its receipt identifies safe authorized work remaining, call `collaboration.followup_task` on that identity with the next unresolved action and current bounds, then wait. No new supervisor, repeated go, or worker dispatch by the parent. The supervisor rereads affected state and reconciles actors and uncertain effects before acting. A missing receipt or unclear wait gets a bounded reconciliation request under the same guards, never permission to repeat an effect. A terminal or non-resumable actor goes through recovery.
- **Real wait or finish:** relay the recorded checkpoint, human gate, runtime limit or integrated outcome with its evidence. A claim of no safe work must account for independent branches under common supervision. Do not repeatedly wake an unchanged legitimate wait. An intended retirement goes through handoff, not same-actor resume. Errors, lost actors and uncertain ownership go through [recovery](recovery.md).

Two comparable returns without accepted progress trigger the existing non-progress diagnosis before another continuation request; do not send an endless series of “continue” messages. Respect actual attempt and spend limits across resumes. Replacement still requires cessation and guarded ownership transfer; runtime inability to resume gets an honest fallback.

After launch or replacement, and on a status request or wait handoff, identify the human-readable supervision scope, native actor and observed state, latest receipt, and next action or wait. Keep opaque actor IDs in the ownership record; use a readable role and scope with any supported native link in user-facing text. Never label an idle actor “running” or confuse a queued native task with an active supervisor. A separately requested native task may host the parent relay; the same return-handling and lifetime limits apply there.

## Optional parent-owned Goal

Offer an optional Goal at autonomy choice only when supported and no incompatible unfinished Goal prevents creation. Use `create_goal` only on explicit user request, after authorization; set `token_budget` only when explicitly requested. Delivery needs no Goal.

The originating parent owns it throughout delivery and supervisor relays. Children never create, complete, block or transfer Goals. Record identity and parent ownership in the existing ownership record. Handoff, retirement or task completion never completes the global Goal: the parent verifies integrated evidence against its whole objective before `update_goal(status: "complete")`, reporting final usage when budgeted.

Refresh with `get_goal`; never mutate unrelated Goals. `blocked` obeys the tool's threshold: the same impasse on at least three consecutive genuine Goal turns, without meaningful in-scope progress. Polls are not turns; resumed blocked Goals restart that audit. Never complete to stop, save budget or enable handoff. An older Goal remains with its original parent: reconcile its owner and actors, preserve its history, and continue without a new Goal unless separately requested and legitimately creatable.

## Read existing plans unchanged

Accept both new common Decision names and these exact saved aliases: `Octoplan 18 brief`, `Octoplan 18 stakes`, `Octoplan 18 plan contract`, and `Octoplan 18 delivery authorization`. Read the existing supervisor Decision by its recorded ownership content; the old source required a stream Decision but did not prescribe a fixed supervisor title. Reuse its identity, revision guards, current receipts and exact route. New plans use common names; resumed records retain their existing aliases. Valid Decisions, task text, receipts and authority need no rename, migration or duplicate go.

A release never renumbers the v18 plan-contract generation. Common recovery validates current state and handles invalid or pre-v18 private control objects as history, never execution authority. A similar name cannot grant PASS or consent.
