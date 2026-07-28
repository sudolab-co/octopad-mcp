# Changelog

All notable changes to the skills in this repository.

Each skill is versioned independently in its own `Version:` line and its plugin manifest. A **major** bump means a breaking change to the conventions written into Octopad task descriptions (title prefixes, the continuation prompt shape, template section names), so plans written under the old version may need a checkpoint pass. Minor and patch bumps are safe to adopt as-is.

## octoplan

### 2.0.0 — 2026-07-28

**Breaking: the continuation prompt changed shape.** It is now two lines instead of one:

```
<work stream> #N - <task title>
Octopad · Organisation: <organisation> · Workspace: <workspace>
```

The work and its rank lead, because an assistant names the session after the start of what it is given, so that line has to carry the readable label. The address moved to the second line and gained the organisation: workspace names can repeat across organisations, and naming only the workspace left the receiving session guessing.

Plans written under 1.x still run, but their tasks carry Next lines producing the old one-line prompt. Run an Octoplan checkpoint on any live stream to refresh them.

Also in this release: dropped the remaining framing about execution being a separate mode. There is no mode. What a later session needs is written into the task description, and that is all the skill says about it.

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
