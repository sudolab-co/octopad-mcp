# Changelog

All notable changes to the skills in this repository.

Each skill is versioned independently in its own `Version:` line and plugin manifest. Standard semantic versioning applies to each distribution's public contract: major changes are incompatible and may require migration or replanning, minor changes add backward-compatible functionality, and patches are backward-compatible fixes or clarifications.

## octoplan-codex

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

## octoplan

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
