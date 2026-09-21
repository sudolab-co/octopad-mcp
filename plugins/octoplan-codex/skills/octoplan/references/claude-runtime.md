# Claude runtime

Load only in Claude. Apply common [planning](planning.md), [supervision](supervision.md) and [recovery](recovery.md); this profile adds Claude routes and capability checks, assuming no Codex tools or Goals.

## Routes and enforcement

Check exact models, efforts and agent definitions before saving routes. Use this rubric when available; a different model set requires an explicit recorded mapping in planning, never silent substitution.

| Remaining task judgment | Declared route |
|---|---|
| Mechanical copy of a verified pattern, fully specified, reversible and checkable | `Sonnet 5 · xhigh` |
| Standard bounded delivery with a clear pattern | `Opus 5 · high` |
| Hard bounded work or cross-file/document coordination; consequential work | `Opus 5 · xhigh` |
| Open design or uncertain long-horizon approach | `Fable 5.1 · xhigh`, subject to the conditions below; otherwise `Opus 5 · xhigh` |
| Broad read-only audit or exhaustive verification | `Opus 5 · xhigh`; separate `/effort ultracode` only on explicit opt-in |

The default lane set remains `Sonnet 5 · xhigh`, `Opus 5 · high`, `Opus 5 · xhigh`, `Opus 5 · max`, `Fable 5.1 · xhigh`. These are declared routing policies, not price rankings. Sonnet below `xhigh` is outside this rubric. `low` is not recommended. `medium` is only for an explicit latency/cost priority and never Sonnet. Fable `high` remains available when already selected for bounded capability-sensitive work. `max` needs a recorded reason: `xhigh` proved insufficient, or explicitly unconstrained work justifies it; prefer moving Sonnet to Opus before increasing Sonnet effort.

Every Fable recommendation requires availability and explicit acceptance of data-retention terms. The saved condition is mandatory 30-day retention; verify current terms. If either fails, recommend compatible Opus and record a saved-route change through planning before launch. A recommendation is not data-handling consent.

`ultra`/`ultracode` is not a native effort above `max`. The declared `/effort ultracode` session mode combines `xhigh` with workflow orchestration; the prompt keyword requests a workflow at the session's effort. Check actual support before recommending it, preserve explicit opt-in, and save native effort separately. Never save `effort: ultra` or enable a workflow to bypass the ordinary ownership and authority rules.

On manual launches, exact model and effort are binding settings the user sets. On supervised launches, inspect existing lane definitions that pin model and effort together, such as the environment's agent definitions. Dispatch the lane matching the saved route. Do not create or alter lane definitions as an incidental planning step. If no matching lane exists and the exposed launch call can set only model, pass that exact model and make effort an explicit request in the worker prompt: `requested, not enforced: this launch call cannot set it — run at it if you can; if you cannot, say so in your status line`. With a matching lane use `pinned by your lane definition`. Explain the request-only limit once per run; never claim observed effort from a prompt. Positive route mismatch or unavailable model pauses the affected actor.

Preserve saved routes, including earlier exceptions and lane requests, as floors; do not normalize them to defaults. Escalation requires diagnosis, planning and affected review before replacement, never weakening or silent substitution. Review uses the worker's model at `xhigh`, retaining stronger saved review routes; the supervisor supports at least the strongest saved worker route. Select the planner against actual judgment using this rubric. Common review and upstream-premise floors apply.

## Measured facts about this runtime

Measured on 2026-09-14 and 2026-09-15 in Claude Code on macOS; re-measure when the harness changes.

- A subagent launched with the Agent tool can itself launch subagents, and `SendMessage` resumes a completed agent from its transcript. So planner, supervisor, workers, and reviewers nest as the shared protocol asks.
- A subagent's `SendMessage` lands in the main session's conversation, not in the subagent that spawned it, and a subagent that has ended its turn is not woken when its own background children finish. Therefore the relay is always the user's own session: it launches the supervisor, receives its reports, and forwards user decisions. Never delegate relaying to a subagent, and never let the relay end its turn on "in progress" unless it is the main session, which the harness wakes when a background agent completes.
- `ListAgents` reports a stopped agent as `killed` or `completed`; that listing is the cessation proof a successor needs. An agent stopped with `TaskStop` takes its in-process children with it; a successor still inspects the target for half-written artifacts.
- Each agent's context is its own: a fresh supervisor starts without the planner's history. The cost is elsewhere: every hop rereads the contract page, Decisions, and tasks, so a three-task stream spent about 200k tokens per relay, planner, or reviewer turn. Size the review floor to the stakes (F15).

## Verify the native route before offering it

Verify all three native capabilities: the parent spawns a fresh child; that child delegates workers/reviewers; and the parent can message or resume it after a report. Also verify native status/stop controls can prove cessation before replacement. Use only documented mechanisms exposed by the actual environment, not invented tool names.

Check these and the supervisor route before promising automatic delivery. Declarations alone are not a successful handoff rehearsal: identify missing runtime evidence. An unavailable or failed capability requires the precise [manual fallback](continuation.md) at mode choice, never a claim of autonomous continuation. No scheduler, hook or worker loop fills the gap.

After the reviewed Plan is visible and authority holds, spawn one fresh supervisor per approved disjoint boundary, never a full-history fork, at the saved route and matching lane. Its bounded prompt names the owned streams and boundary, organization/workspace, stored mandate and ownership pointers, plus indispensable environment facts absent from Octopad. It reads current state and claims the guarded supervisor Decision. No manual Next instructions load for this launch.

The parent relays bounded progress and six-field escalations verbatim, forwarding user decisions through native follow-up. The child follows common supervision and delegates workers/reviewers, never another supervisor. The parent manages lifecycle and dialogue, not task advancement. Use the common worker mandate, including for workers without Octopad; task text never grants authority and uncovered effects never convert Full autonomy into Checkpoints.

For multiple streams, apply [multi-stream.md](multi-stream.md). Default to one common supervisor. Use several only after qualifying creation, nested delegation, follow-up, wait/status, stop and replacement with current native permissions and capacity left for workers and reviewers. Reuse compatible qualification; repeat only evidence invalidated by a runtime change. The main relay routes each report, user answer and dependency-clearance event to the recorded owner using the exposed Agent, SendMessage, ListAgents and TaskStop capabilities or their verified equivalents. Wait through native background-completion notifications only where wake-up is proved; otherwise remain in the active native wait. A child never launches another supervisor. The designated cross-stream coordinator routes bounded repair to a suitable planner without taking another owner's work.

An ended supervisor turn is not completed Delivery. Before each follow-up reconcile the latest user instruction, mandate, boundary owner, native state, receipt and uncertain effects. User stop or pause forbids continuation; pending retirement goes through handoff. Resume the same healthy owner through native follow-up only when safe authorized work remains and the actor is resumable. An unclear receipt gets bounded reconciliation, never permission to repeat an uncertain effect. Two comparable returns without accepted progress trigger diagnosis before more continuation. Preserve real attempt and spend limits; do not wake an unchanged genuine wait. A local finish leaves other owners and integration active. Report scope and observed actor state, never calling an idle owner running. If the relay ends, disclose the actual wake-up or manual-continuation limit.

At replacement, apply common recovery: persist facts, reconcile in-flight workers/effects, prove predecessor cessation, then spawn fresh. The successor claims ownership with current `expected_updated_at`; send pending user answers to that successor. Missing returns are environment signals, not proof of cessation. No route to prove it means hold that boundary.

If the relay cannot continue, stop and reconcile its child before manual handoff. On recovery, inspect native state rather than assuming the child survived or died with its parent. Confirmed launch establishes an active successor; a pointer does not. Actual capabilities and runtime lifetime bound continuation.

## Read existing Claude contracts unchanged

Legacy Claude plans do not use the Codex `Octoplan 18` title scheme. Read the saved contract Decisions by their subjects and content: **Gate map** (person-waits and protected effects), **Reviewer routing**, **Stacking**, **Stakes and the kill question**, and the separate Decision whose own subject is the **delivery go**. Its recorded fields include mode, supervisor route, disclosed effects and marked points. Confirmed brief content may be in the tracker's Scope, Rationale and Definition of Success sections, with interpretation Decisions. Use those records as the corresponding common Brief, stakes, plan contract and delivery authorization; their titles need no migration.

An unchanged valid recorded go carries forward, including a legacy go with no handoff-message reference: preserve it and record that provenance gap, as the old contract allowed. A go naming a handoff must follow that message and concern the Plan actually shown. A standing-intent go needs the user's words, shown Plan and covered-effect list; absent coverage does not authorize protected effects. A reference to an old `Go record` page is history; the Decision remains authority. Pre-delivery-mode contracts with two autonomy dials are historical and need affected-scope reconciliation, not silent conversion into broader authority.

Retain exact saved task text, routes and existing Next instructions on resume. Optional `Octopad` lines absent in older tasks are resolved from the task's actual read/write needs. For legacy post-go drift, compare task `updated_at` with go `created_at` and subsequent task review receipts: a newer revision needs reconciliation, not automatic withdrawal of consent. Preserve accepted focused re-reviews and old receipts. Do not require a new naming scheme, new schema fields or a duplicate go before valid old work continues. Establish a guarded supervisor record on takeover only after reconciling existing activity; its absence in an old plan is not proof that no other supervisor exists.
