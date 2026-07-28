# Changelog

All notable changes to the skills in this repository.

Each skill is versioned independently in its own `Version:` line and its plugin manifest. A **major** bump means a breaking change to the conventions written into Octopad task descriptions (title prefixes, the continuation prompt shape, template section names), so plans written under the old version may need a replanning pass. Minor and patch bumps are safe to adopt as-is.

## octoplan-codex

### 1.3.1 — 2026-07-28

First public Codex release, intentionally aligned with the current Claude `1.3.1` version.

- Keeps planning and execution separate: completing a plan never launches work. The planner asks the user whether Codex should start execution and waits for an explicit yes.
- After approval, Codex executes the saved plan in dependency order by creating fresh worktree or local sessions with each task's exact model and reasoning effort.
- Explicitly independent tasks can run in parallel after complete-group preflight; executor sessions are one-shot and the planning session remains the sole orchestration owner.
- Includes Codex-specific GPT-5.6 execution and review routing, durable recovery rules, Blueprint support, and event-driven replanning.
- No Kickstart skill or Branch command.

## octoplan

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
