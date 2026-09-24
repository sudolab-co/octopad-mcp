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

## Runtime facts

Re-measure these when the harness changes.

- The main session is the only actor the harness wakes: a background agent's completion and its `SendMessage` land there, never in the subagent that spawned it. A subagent that ends its turn is not woken when its own children finish. So the supervisor runs as a main session, and workers and reviewers run as its subagents.
- A subagent launched with the Agent tool can itself launch subagents, and `SendMessage` resumes a completed agent from its transcript.
- `ListAgents` reports a stopped agent as `killed` or `completed`; that listing is the cessation proof for a worker. An agent stopped with `TaskStop` takes its in-process children with it; still inspect the target for half-written artifacts.
- The desktop app can report the context fill of the current session, and of another session by id. The terminal exposes no such reading.
- Claude starts a new top-level session only through a native session-launch tool. When none is exposed, the user opens the session from a pointer block.

## Launch the supervisor

The supervisor is a fresh top-level session at the saved supervisor route, never a subagent of the planner and never a full-history fork. The user talks to it directly. It follows common supervision and delegates workers and reviewers as subagents on the matching lanes. It never launches another supervisor. Check the supervisor route and lane definitions before promising delivery.

After the reviewed Plan is visible and authority holds, the planner launches one supervisor per approved disjoint boundary. If a native session-launch tool is exposed, it starts the session with the supervisor pointer; this first launch has no predecessor to stop. Otherwise it ends its turn with the supervisor pointer block and settings line from [continuation.md](continuation.md), one per boundary, and one plain sentence telling the user to open a new session with it. This is the Claude route, not a degraded one; say so once at mode choice. The planner does no delivery work after launch. The supervisor reads current state and claims the guarded supervisor Decision. A plan defect goes to a bounded planner subagent the supervisor starts, never back to the user.

No parent relay remains after launch, so the shared relay duties map as follows: the user opens each session from its pointer; each successor proves its predecessor's cessation, as the handoff section requires; each supervisor answers the user and returns closure proof and the final recap in its own session; and the Plan names one supervisor as the cross-stream change coordinator.

Use the common worker mandate, including for workers without Octopad; task text never grants authority and uncovered effects never convert Full autonomy into Checkpoints. Dispatch parallel workers that write to the same repository with worktree isolation on the Agent call, so each works in its own checkout.

For multiple streams, apply [multi-stream.md](multi-stream.md). Default to one supervisor session. Several need every condition there, including worker and reviewer capacity, plus one pointer block each. Separate sessions share no native messages: each rereads dependency state from Octopad at every task boundary, and the user relays a decision only one of them can receive. The designated cross-stream coordinator routes bounded repair to a suitable planner without taking another owner's work.

## Wait without spending context

For an internal wait on workers, reviewers or checks, once no other safe ready work remains, end the turn on something the harness wakes the main session for: a background agent, or a background command that exits when its condition holds. For pull-request checks, that command exits when every check is terminal, success and failure alike. On waking, reconcile a failed command and the current PR head before acting on the result. Where background wake-up is unavailable, wait in the active turn per [supervision.md](supervision.md). The outcome, a human gate and a handoff end the turn under common supervision. Never end on "in progress" otherwise.

## Hand off before the context fills

When the context reading is exposed, the supervisor reads it after each task closes and before each batch. At the user's recorded preference, or at about 60% without one, it hands off at the next task boundary, earlier if the next batch is heavy. Without a reading, choose the boundary from workload per [supervision.md](supervision.md); never invent a percentage.

To hand off: stop dispatch, collect or stop in-flight workers, reviewers and background commands, reconcile uncertain effects and persist state per [recovery.md](recovery.md), then record the release in the supervisor Decision with the current `expected_updated_at`. Then emit the supervisor pointer block and settings line with one plain sentence asking the user to open a new session with it, end the turn and do no further work. A supervisor never launches its own successor, because it cannot prove its own cessation first.

The successor proves cessation before acting. The Decision must record the release and no actor may remain in flight. It then checks that the predecessor session is idle when session status is readable; when it is not, it asks the user to confirm that the previous session has stopped. A release record alone is not cessation proof. Without proof, hold the boundary. The user can ask for a handoff at any time.

## Read existing Claude contracts unchanged

Legacy Claude plans do not use the Codex `Octoplan 18` title scheme. Read the saved contract Decisions by their subjects and content: **Gate map** (person-waits and protected effects), **Reviewer routing**, **Stacking**, **Stakes and the kill question**, and the separate Decision whose own subject is the **delivery go**. Its recorded fields include mode, supervisor route, disclosed effects and marked points. Confirmed brief content may be in the tracker's Scope, Rationale and Definition of Success sections, with interpretation Decisions. Use those records as the corresponding common Brief, stakes, plan contract and delivery authorization; their titles need no migration.

An unchanged valid recorded go carries forward, including a legacy go with no handoff-message reference: preserve it and record that provenance gap, as the old contract allowed. A go naming a handoff must follow that message and concern the Plan actually shown. A standing-intent go needs the user's words, shown Plan and covered-effect list; absent coverage does not authorize protected effects. A reference to an old `Go record` page is history; the Decision remains authority. Pre-delivery-mode contracts with two autonomy dials are historical and need affected-scope reconciliation, not silent conversion into broader authority.

Retain exact saved task text, routes and existing Next instructions on resume. Optional `Octopad` lines absent in older tasks are resolved from the task's actual read/write needs. For legacy post-go drift, compare task `updated_at` with go `created_at` and subsequent task review receipts: a newer revision needs reconciliation, not automatic withdrawal of consent. Preserve accepted focused re-reviews and old receipts. Do not require a new naming scheme, new schema fields or a duplicate go before valid old work continues. Establish a guarded supervisor record on takeover only after reconciling existing activity; its absence in an old plan is not proof that no other supervisor exists.
