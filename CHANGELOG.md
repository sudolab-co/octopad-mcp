# Changelog

All notable changes to the skills in this repository.

Each skill is versioned independently in its own `Version:` line and plugin manifest. Standard semantic versioning applies to each distribution's public contract: major changes are incompatible and may require migration or replanning, minor changes add backward-compatible functionality, and patches are backward-compatible fixes or clarifications.

## octoplan-codex

### 9.0.0 — 2026-08-05

This breaking release gives each actor a small role-specific pack and binds every native creation to an immutable packet naming the organization, workspace, work stream, task, route, target, model, effort, and required capability profile. Every native child enters that Octopad context first, while Octopad remains responsible for its own context and status lifecycle. The planner, supervisor, executor, reviewer, recovery, and follow-up responsibilities are explicit.

The supervisor owns incidents end to end: it can delegate bounded reasoning to a fresh actor with an appropriate model and effort, restore a missing capability or use a safe workaround, and asks the user only after proving that no compliant path remains. Analytical delegates cannot impersonate native launchers. Incident planners use the affected task's saved recovery route or default recovery route, and any capacity change creates a reviewed delta. Planning rejects plans decomposed into tool calls or access probes instead of independently deliverable results. Existing 8.0.0 plans require replanning under this creation contract; the Claude distribution is unchanged.

### 8.0.0 — 2026-08-04

Every native Octoplan session now stays in the same Codex project as the planning session. The project ID is fixed across supervisors, executors, lead and specialist reviewers, recovery sessions, and follow-ups; `local` and `worktree` environments may still differ inside that project. Projectless plans keep the exact planning directory. A cross-project or project/projectless substitution stops before session creation.

This breaking release requires earlier saved plans to be replanned before execution. Deterministic fixtures now validate the complete execution environment and every native session role for both project and projectless targets. The Claude distribution is unchanged.

### 7.0.0 — 2026-08-04

This breaking Codex release supports one v5/v2 contract path; earlier saved contracts require replanning and receive no historical support. Users choose a plain-language Delivery mode: **Review before delivery** waits for confirmation, while **Autonomous delivery** can accept an unambiguous end-to-end delegation in the first message, publish a non-blocking scoping checkpoint, independently validate that authority, and continue without asking the user to judge the plan. Neither mode grants protected actions.

The standalone v2 fingerprint binds exact target parsing, extraction/defaults, Unicode-scalar canonical JSON, collection ordering, feasibility coverage/matrix, source and verifier availability, distinct review verdicts, durable run states, stable blocker identity, accounting truthfulness, and the exact human occurrence predicate. Only authoritative actuals are recorded; unavailable provider cost remains unavailable and ambiguous authority waits for independent conformance judgment.

Material incidents use a fresh planner without execution authority, a concrete independent delta review, a whole-run fence/quiescence barrier, explicit adoption or rejection, repeated grounding, read-back, fingerprint, and conformance checks, and a new run without transferring PASS or consent. Natural-language activation fixtures distinguish bounded delegation from urgency, vague trust, or a bare “do it”. Portability, single-source references, generic tool-schema separation, deterministic fixtures, and CI-safe public-hygiene validators are tightened; no historical support is retained.

### 6.1.0 — 2026-08-04

Codex users may now explicitly authorize automatic execution after confirming the scoping brief. Once plan review and saved-state equality pass, Octoplan can bind that prior authority to the exact final plan hash in a guarded coordination-ledger comment and launch without a second wake-up. A bare brief confirmation, broad autonomy, prior chat, or planning permission is never enough.

Advance authority is invalidated by any unresolved Question or material change in result, scope, cost, risk, success, architecture, route bounds, validation mode, or protected actions. Consent evidence and launch-binding records remain runtime state outside the plan fingerprint. Existing 6.0 plans with `octoplan-supervision-v4` and normal later final-hash consent remain valid; protected actions, human gates, the Claude distribution, and the Octopad MCP are unchanged.

### 6.0.0 — 2026-08-03

Codex plans now use one byte-deterministic `octoplan-fingerprint-v1` input bound to `octoplan-supervision-v4`. The structured fingerprint covers the supervision policy, binding execution targets, review record, participating streams, governing Decisions, and every agent and human task, with exact field extraction, ordering, UTF-8 JSON escaping, and exclusions for runtime state. Final-hash locations are normalized to `PENDING`, the ledger manifest has explicit exclusion sentinels, and any hidden copy of the persisted digest stops verification instead of creating a self-referential hash.

Native Codex sessions now use readable titles for dedicated supervisors, executors, lead reviewers, and specialist reviewers. Repair, fallback, and recovery sessions preserve the owning stream and ranked delivery-task title; unsafe control or bidi characters and malformed task titles stop before creation. A canonical internal `OCTOPLAN_CREATION` JSON line retains the complete technical identity in the first prompt and durable record without exposing it in the visible title.

Every `create_thread` response shape now converges through `list_threads` and `read_thread` before a creation record becomes ready. Client IDs are never passed to thread tools, every real candidate is checked for the exact internal identity, and ambiguous or lost results pause without retrying creation. This release is breaking: plans using `octoplan-supervision-v3` or older must be replanned before execution. The Claude distribution and Octopad MCP are unchanged.

### 5.1.0 — 2026-08-03

User-facing Octoplan replies now keep opaque identifiers out of visible prose: raw UUIDs, session metadata, SHA-256 values, and Git commit hashes are retained only in internal records, agent-to-agent prompts, exact commands, or required Markdown link destinations. Codex session references use a readable label linked with the native `codex://threads/<thread-id>` deep link. PR, migration, task, and `#N` numbering remains unchanged.

### 5.0.0 — 2026-08-03

Codex plans now choose gradual or final human validation. The planner reviews a complete symbolic draft before writing only the final graph to Octopad, verifies deterministic saved-state equivalence, binds the result to `octoplan-supervision-v3`, and still asks for explicit execution consent on the final hash. Delivery tasks end at review-ready agent artifacts; human review, merge, migration application, deployment, publication, and acceptance are separate tasks with explicit completion evidence and optional event-wake predicates.

The supervisor can resolve bounded in-scope repairs without a new plan, create crash-idempotent non-blocking follow-ups, and continue unrelated safe branches while another branch waits on CI or a human. Repair classification is persisted before work, judgmental classification gets independent review, and artifact review scales from targeted deterministic checks to one independent lead plus an orthogonal specialist only when needed. Human rejection reopens the original delivery task while preserving history and returns to the same review task after correction.

GitHub event wakes deduplicate immutable deliveries, verify the exact PR head and saved human-task predicate, and resume reconciliation without authorizing protected actions. Incremental reconciliation avoids full-plan rereads unless authority or fingerprinted state may have changed. The supervisor owns the final recap and reports actual repairs, rejection loops, sessions, external wakes, delivered artifacts, remaining human work, and follow-ups from the existing ledger.

This is breaking: older plans do not contain the v3 validation, repair, follow-up, wake, or review contract and must be replanned before execution under 5.0.0. Explicit-only invocation, final execution consent, native target fencing, exact saved routes, and protected human-action gates remain in force.

### 4.0.0 — 2026-08-02

Codex plans now bind every supervisor, executor, reviewer, and recovery session to a saved native project and environment. The manifest separates inline and dedicated supervisor targets, the default executor target, and task-role overrides; projectless execution must be explicit and justified. Project ID and environment are fingerprinted into review and execution consent, while host, path, and Git metadata remain non-blocking audit evidence.

Launch, activation, resume, takeover, fallback, and artifact provenance now stop on a target mismatch instead of inferring from the caller's directory or task context. This is breaking: pre-4.0 plans do not contain the environment-bound `octoplan-supervision-v2` contract and must be replanned. The explicit-only invocation behavior introduced in 3.0.1 is preserved, and the Octopad MCP and Claude distribution are unchanged.

### 3.0.1 — 2026-08-02

Codex no longer loads Octoplan implicitly. It now requires an explicit `$octoplan` invocation, and the trigger description excludes general Octopad actions, organization connection, onboarding, and unapproved task execution. This prevents unrelated onboarding prompts from entering Octoplan.

### 3.0.0 — 2026-08-02

Approved execution now runs through one fenced supervisor. Small linear streams stay in the planning or recovery session; four or more delivery tasks, parallel work, multi-stream coordination, or interruption gates justify a dedicated parent at a saved route. Supervisor epochs make takeover restartable, and one saved replacement bound prevents parent churn.

One compact Octopad Plan manifest and tracker pointers replace copied contracts. Its canonical hash is persisted before plan review and consent; any plan change needs a new review, consent, and run. Native session creation uses durable identities and an activation barrier, including all-ready activation for parallel groups. Executors produce immutable artifacts, lead reviewers own revision-bound correction and completion, and only the supervisor launches successors. Saved lineage, same-route recovery, and evidence-gated executor fallback keep replacement work bounded.

This is breaking: pre-3.0 plans are unsupported and must be replanned. The Octopad MCP and Claude distribution are unchanged.

### 2.0.1 — 2026-08-01

Mixed tasks now route execution and review independently when objectively specified implementation has qualitative acceptance. Choices the executor must originate determine the execution route; qualitative judgment assigned only to review no longer inflates it. The full routing rubric still applies, and unresolved material judgment continues through Terra or Sol.

The planner's saved-state check records that distinction in each applicable execution rationale, and the routing validator now guards it alongside the synchronized 2.0.1 version.

### 2.0.0 — 2026-07-31

Every executable task now receives a fresh independent adversarial review. The lead reviewer owns corrections, durable completion, and relay; one simultaneous specialist is allowed only for a distinct material failure domain. Every PASS is bound to the same immutable artifact revision, and reviewer rerouting starts a fresh guarded attempt with an authorized correction executor and full review set.

Execution and review routing now minimize expected cost per accepted task. Luna covers exact and strongly verified work, Terra is a real technical and non-code judgment rung, and Sol is reserved for open, weakly verified, or hard-to-reverse work. Risk labels never select Sol alone; every Sol route must state why Luna and Terra are inadequate. Plan-review routes and rationales are saved and reread before launch.

This is breaking: saved plans that skip review or use the previous routing contract must be replanned before execution.

### 1.6.1 — 2026-07-31

Octoplan now distinguishes execution guidance from retrievable source context. Tasks save the outcome, decisions, boundaries, verified approach, exact pointers, risks, and verification that direct a fresh executor, while live pages, documents, and code remain in their systems of record. Engineering tasks identify the applicable files, symbols, patterns, integration points, invariants, regressions, and tests without copying implementation context.

Executor and reviewer prompts now explicitly start the Octopad workspace session, call `build_context` for the task, and open the saved source pointers before acting. This is a wording clarification only: existing task schemas, saved plans, routing, approvals, relay behavior, and terminal contracts remain valid.

### 1.6.0 — 2026-07-31

Octoplan now routes after decomposition by verification strength, consequence, and subjectivity. Luna `high` handles mechanical work, Luna `xhigh` is the default for well-specified autonomous execution, and Luna `max` handles difficult but strongly verifiable tasks. Terra `high` and `xhigh` cover everyday business communication and well-bounded product or decision documents. Sol `high` and `xhigh` remain for open-ended strategy, weak verification, polished or high-consequence public work, sensitive systems, and confirmed lower-tier capacity failures; planning remains Sol `xhigh`, with `max` reserved for justified extra scope, risk, or ambiguity.

Tasks now carry the smallest complete memory-less handoff: observable result, boundaries, inputs, acceptance, verification, and any decisions, sources, safeguards, proofs, or escalation conditions that affect execution. Business communication and editorial deliverables add only the audience, channel, intended effect, voice, message, claim-source, format, and review constraints that actually apply.

Review routing now uses Luna `max` for deterministic completeness and verifiability, Sol `high` for difficult or editorial judgment, and Sol `xhigh` for sensitive or costly public work. Failed work is diagnosed as a plan gap, environment or verifier blocker, or model-capacity problem before escalation. A changed route is a material task rewrite: it must be saved, reviewed, and explicitly approved in a fresh run; executors and reviewers never substitute a model themselves.

Existing saved plans remain valid. No task field, title convention, continuation prompt, or terminal contract changes.

### 1.5.0 — 2026-07-31

After explicit execution approval, Codex now passes continuation directly between task sessions. The planning session launches only the first ready task or parallel group. A review-skipped executor completes and relays its task; a review-required executor creates one fresh routed reviewer, which owns corrections, completion, and the next launch after PASS.

An Octopad ledger binds every session to the approved run, plan fingerprint, guarded task attempt, and persisted pending or real thread IDs. Parallel groups use all-or-none preflight and guarded claims, so racing completions cannot create duplicate reviewers or successors. Human gates, protected actions, plan changes, ambiguous recovery, and failed reviews stop without advancing.

Existing plans need no migration: their current `Next` values and dependency edges carry the relay, with no new required task field. Relay mechanics live in a separate reference loaded only after approval, keeping planning-time routing and consent guidance lightweight. Repository version guidance now follows standard compatibility-based semantic versioning, making this backward-compatible capability a minor release.

### 1.4.0 — 2026-07-30

Every full planning pass now returns a short scoping brief before writing anything to Octopad: the planner's understanding, explicit in/out of scope, definition of success, assumptions with their basis, and open questions. The brief is the whole reply, and the planner waits for a later user confirmation before saving Decisions, Questions, tasks, tracker logic, or Blueprint pages.

A prior prompt or apparently complete stream cannot satisfy the gate. Partial replies never silently accept an unanswered assumption: the planner asks once more, then records anything still open as a Question and leaves affected tasks as flesh-out placeholders. Multi-stream efforts use one effort-level brief before the stream split; a later full pass on one stream uses its own brief.

Reduced event-driven rebalancing remains available without a new brief only for at most two added or materially rewritten tasks when scope, result, material risk, cost, and definition of success stay unchanged; mechanical graph and title repairs do not count toward that limit. Only pure plan-hygiene repair continues under the existing execution approval. Any added, removed, or materially rewritten executable task requires fresh execution approval, while larger or material changes require a fresh full planning pass.

The Codex execution-consent boundary, saved model and effort routing, independent executor sessions, and protected-action gates are unchanged. Existing saved plans remain valid.

### 1.3.2 — 2026-07-29

Full planning and targeted replanning accept `gpt-5.6-sol` at `xhigh` or `max`; `max` remains for verified extra scope, risk, or ambiguity.

### 1.3.1 — 2026-07-28

First public Codex release, intentionally aligned with the current Claude `1.3.1` version.

- Keeps planning and execution separate: completing a plan never launches work. The planner asks the user whether Codex should start execution and waits for an explicit yes.
- After approval, Codex executes the saved plan in dependency order by creating fresh worktree or local sessions with each task's exact model and reasoning effort.
- Explicitly independent tasks can run in parallel after complete-group preflight; executor sessions are one-shot and the planning session remains the sole orchestration owner.
- Includes Codex-specific GPT-5.6 execution and review routing, durable recovery rules, Blueprint support, and event-driven replanning.
- No Kickstart skill or Branch command.

## octoplan-claude

### 1.4.0 — 2026-07-30

- New step 2, **Scoping brief — reflect back, then wait**: before locking any decision, drafting any design page, or writing any task, the planner hands the user one short brief merging what the user said with what the sources hold — understanding restated in its own words, in/out of scope, definition of success, an explicit Assumptions list (every point settled by inference rather than a source or the user's words), and open questions — then stops. The old flow only forced a question when a spec slot could not be filled at all; a plausible-but-wrong inference could fill the slot and ship silently. The Assumptions list makes those inferences visible so the user can veto them before planning starts.

  Three guards keep the gate from being talked around: confirmation must be a reply sent AFTER seeing the brief (no launch prompt, prior chat, or tracker note counts, however complete it looks); the brief is the entire message, with no decision proposals or draft breakdown riding along to be swept up by one "go"; and a reply that leaves part of the brief unanswered never defaults to the planner's assumption — re-ask once, then log a Question and mark the affected tasks as flesh-out placeholders. An empty Assumptions list has to show its work rather than assert itself. A call already settled in the brief reply is recorded as a Decision directly, not re-presented in step 3.

  Scope of the gate: every full planning pass. A multi-stream effort writes ONE effort-level brief before the cut into streams, and a later pass on one stream of that effort writes its own stream-level brief. A mid-execution rebalance does not rerun it — and a "rebalance" that would add or materially rewrite more than a couple of tasks, or move the scope, now has to stop and ask for a fresh Octoplan pass instead. The adversarial review's design-soundness lens also checks the specs against the confirmed brief, so a correction cannot silently fail to propagate.

  Steps renumbered (old 2–9 are now 3–10), with matching rows in the self-check list and the mistakes table.

  Not breaking: nothing in existing task descriptions changes shape; plans written under 1.3 keep working unchanged.

### 1.3.1 — 2026-07-28

- New "Changing this skill" note: edit the source repository and release, never an installed copy — auto-update silently overwrites it. This guard used to live in a project instruction file; it belongs here, where it travels with the skill.

### 1.3.0 — 2026-07-28

- Scheduled checkpoints are gone. The "Octoplan checkpoint <stream>" trigger and its every-3–4-tasks revision rhythm never came from a real decision, and a plan has no reason to change on a schedule. What replaces them is event-driven: the new **Replanning** section. When a session executing a task discovers something that adds a task, drops one, or changes the order, that session invokes this skill and rebalances the whole plan — specs re-validated, `#N` prefixes renumbered, dependencies and Next lines rewired, tracker logic updated, self-check re-run on anything added or rewritten. If the discovery invalidates the stream's definition of success, the session stops and asks for a fresh Octoplan pass instead.

  Not breaking: nothing in existing task descriptions references checkpoints, so plans written under 1.2 keep working unchanged.

### 1.2.0 — 2026-07-28

- The continuation prompt is now two lines instead of one:

```
<work stream> #N - <task title>
Octopad · Organisation: <organisation> · Workspace: <workspace>
```

  The work and its rank lead, because an assistant names the session after the start of what it is given, so that line has to carry the readable label. The address moved to the second line and gained the organisation: workspace names can repeat across organisations, and naming only the workspace left the receiving session guessing. The stream's plain name is used, without the ` (octoplanned)` suffix.

  Not breaking: a plan written under 1.0 or 1.1 keeps working, its tasks simply still emit the older one-line prompt, which resolves the same way. Run an Octoplan pass on the stream when convenient to refresh those Next lines.

- Dropped the remaining framing about execution being a separate mode. There is no mode. What a later session needs is written into the task description, and that is all the skill says about it.

### 1.1.0 — 2026-07-28

- The planner now writes the plan's reasoning into the stream tracker: why the tasks run in this order, which branches are parallel, where the human gates sit, what ends the stream. Logic only, no statuses and no copied task content, so it doesn't go stale. This is what the Blueprint page already did for multi-stream efforts, applied to a single stream.
- Dropped the "two-tier workflow" framing. There is no execution mode: this skill runs at planning time, and everything an executor needs is written into the task descriptions themselves.

### 1.0.0 — 2026-07-28

First public release.

- Planning protocol for Octopad work streams: a planning session locks decisions with the user and writes every task as a complete, self-contained spec, verified against the real codebase or reference documents.
- Execution needs nothing installed: each task carries its own hand-off instruction, and a finishing session emits a one-line continuation prompt (`Octopad: <workspace> / <stream> #N - <task title>`) the user pastes into a fresh session.
- Execution order comes from real Octopad dependency edges plus a `#N - ` prefix in task titles.
- Parallel groups: exactly one sibling is the relay and emits the continuation; the others end silently, so the chain cannot fork.
- Multi-stream efforts: one goal, several work streams, one light Blueprint page explaining the global logic, and cross-stream dependencies enforcing it.
- Works for engineering and non-technical streams alike, with per-domain lenses for the interview and the specs.
