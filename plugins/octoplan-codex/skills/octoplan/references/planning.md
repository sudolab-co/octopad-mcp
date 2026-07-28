# Octoplan planning protocol

This is the Codex distribution of the public Octoplan 1.3.1 planning protocol. The dependency graph is executable truth; titles, trackers, and Blueprints explain it to people.

## What Octoplan needs

- Start the correct Octopad workspace session, then use `build_context` in `work_stream` or `task` mode. Record the organisation and workspace names.
- Read the stream tracker, every task, linked pages, Decisions, Questions, and relevant recent activity.
- Read the repository or governing documents required to verify every saved claim.

Respect Octopad's task-creation contract:

- Every task description contains literal `Why` and `What` sections.
- Every top-level task also contains literal `Done when`.
- Every task is created with `impact` from 1 to 5 and `impact_rationale`.
- Subtasks use `parent_task_id` and need only Why and What.
- Every dependency edge includes a one-line rationale.

## Non-negotiables

- Plan only. Do not produce the deliverable during planning.
- Save only verified paths, symbols, commands, source claims, access assumptions, and statuses.
- An unknown becomes a Question, Decision, investigation task, or flesh-out marker; never a guess.
- Use the simplest plan that fully delivers the definition of success.
- Size each executable top-level task to one focused, memory-less executor session.
- Keep one real job per task. Split at natural seams, never merely to reduce file count.
- Use subtasks only as an in-session checklist for three or more concrete internal steps.
- Run the saved-state self-check and adversarial plan review on every complete plan.

## Workflow

1. **Review or discover.** Read the whole existing stream. If it is thin, interview the user one theme at a time: outcome, audience, scope, constraints, proof, and human owners. If a loose plan exists, improve it instead of replacing it reflexively.
2. **Lock decisions.** Present one material choice at a time as Deciding, Options with gain and cost, Recommendation, and Reversibility. Save only the accepted choice as an Octopad Decision.
3. **Set the order.** Close done-but-open work, log Questions, add missing tasks, and wire every real dependency. Prefix executable task titles `#N - ` for human-readable rank. Dependencies, not the number, decide readiness.
4. **Ground and make runnable.** For engineering, verify repository patterns, tests, data changes, permissions, rollback, and exact commands. For content or operations, read the governing canon and live surfaces. Missing access becomes a blocking task. Anything that must already be live appears under `Preconditions`.
5. **Spec every task.** Fill the template below with exact sources, boundaries, edge cases, checks, routing, and completion state. A task depending on unknown output stays a flesh-out placeholder.
6. **Add final validation.** Wire one final validation task after all delivery tasks. Give it one subtask per runnable check and include any manual acceptance checklist.
7. **Self-check saved state.** Re-open every task from Octopad, check the saved text and edges, repair failures, then reread repairs.
8. **Adversarial review.** A full plan uses at least two fresh `gpt-5.6-sol · effort max` reviewers: design soundness and memory-less executability. Add a third reviewer at the same route for eight or more tasks or work involving migrations, permissions, authentication, money, or destructive data changes. A targeted event-driven replan changing fewer than three tasks uses one fresh `gpt-5.6-sol · effort xhigh` reviewer; three or more changed or added tasks use the full-plan route. Give reviewers saved task text and source access, not a summary.
9. **Explain the logic.** Update the stream tracker with why the order exists, which branches are parallel, where human gates sit, and what finishes the stream. Store no statuses or copied task content there.
10. **Mark and stop.** Append ` (octoplanned)` to the stream name if absent. Report the plan, then ask for execution approval exactly as the runtime reference requires. Do not launch anything yet.

## Task template

```text
Title: #N - <task title>

**Exec: <Codex model> · effort <level>** — <why>
**Review: required|skip** — <why>
**Review route: <Codex model> · effort <level>**
**Parallel-safe with: <immutable task ID> — <task title>; ...**
Preconditions: <what must already be live>

Why: <why this task exists and what it builds on>
What: <one job, scope, and boundaries>
How: <verified sources, exact paths, existing patterns, edge cases, approval gates>
Verify: <exact runnable commands or observable checks>
Done when: <durable result in its system of record>
Next: <the next task, parallel group, human gate, or none>
```

Keep `Review route` only when review is required. Keep `Parallel-safe with` only for a proven symmetric group and name every sibling by immutable ID. Omit `Preconditions` when none exist.

For code, `Done when` names the repository's actual terminal state. If the repository requires a merged pull request, say so; do not stop at tests passing or a branch existing. Human-only tasks have no title rank, Exec, Review, Review route, or Next.

A placeholder keeps its ranked title and required Octopad sections:

```text
Why: <why the future task exists>
What: ⚠️ Octoplan flesh-out required: run an Octoplan pass before building, because <verified missing input>.
Done when: <the future observable result>
```

## Parallel work

Parallelism is exceptional. Every pair in a group must share no file, symbol, contract, generated artifact, editorial structure, migration, lockfile, or scarce external resource. Every member must have the same readiness frontier. Save `Parallel-safe with` symmetrically only after all tasks exist, using immutable Octopad IDs.

The orchestration session owns continuation. Parallel executor sessions are sterile: each performs one task, records its result, and returns. They never create another Codex task.

## Multi-stream efforts and Blueprint

When one outcome needs several autonomous work streams:

1. Link the streams to one goal and keep each autonomous package in its logical stream.
2. Wire real dependencies across streams in the same workspace.
3. Create one light Blueprint page containing the outcome, each stream's role, global order, parallel branches, major dependencies, human gates, and finish condition.
4. Keep statuses and copied task content out of the Blueprint.
5. Add Blueprint archival to the effort's final validation task.

The Blueprint explains the logic. The Octopad dependency graph enforces it.

## Replanning

Replan only when reality changes the plan, not on a schedule. Revalidate affected specs, renumber titles, rewire dependencies, update affected Next lines and tracker logic, then rerun the relevant self-check.

A repair that preserves the approved result and risk may continue inside the approved run. Added scope, materially changed risk or cost, or a changed definition of success requires a revised plan and a new explicit execution approval.

## Saved-state self-check

For every executable task:

- The ranked title is unique.
- Why, What, Done when, impact, and impact rationale exist.
- Exec and Review match the runtime rubric; required review has an exact Review route.
- How cites verified sources and a concrete existing pattern when one exists.
- Verify is exact and runnable now.
- Preconditions name every live assumption and external gate.
- The task contains one job and fits one session.
- Parallel links are immutable, complete, symmetric, and genuinely independent.
- Next matches the dependency graph.

For the plan:

- The definition of success matches real scope.
- Every material choice is a recorded Decision.
- Every real dependency is wired.
- Final validation follows all delivery tasks.
- Tracker and Blueprint contain logic only.
- Nothing exists merely to serve process.
