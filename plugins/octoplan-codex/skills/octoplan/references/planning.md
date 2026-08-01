# Octoplan planning protocol

This is the Codex distribution of the public Octoplan planning protocol; its Codex-specific runtime guidance is versioned independently. The dependency graph is executable truth; titles, trackers, and Blueprints explain it to people.

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
- Size each executable top-level task to one focused executor session. Make its direction independent of the planning conversation by saving the accepted decisions, verified execution guidance, exact pointers, and checks it needs.
- Keep one real job per task. Split at natural seams, never merely to reduce file count.
- Use subtasks only as an in-session checklist for three or more concrete internal steps.
- On every full planning pass, return the scoping brief below as the whole reply and wait for the user's later confirmation before any planning write. Only a reduced event-driven rebalance as defined under Replanning is exempt.
- Run the scoping brief, saved-state self-check, and adversarial plan review on every full planning pass. A reduced event-driven rebalance runs only the gates named under Replanning.

## Workflow

1. **Review or discover.** Read the whole existing stream. If it is thin, interview the user one theme at a time: outcome, audience, scope, constraints, proof, and human owners. If a loose plan exists, improve it instead of replacing it reflexively. The answers and verified sources feed the scoping brief; no Decision, Question, Blueprint, design page, task, or tracker change is saved yet.
2. **Scoping brief — reflect back, then wait.** Before locking any Decision, drafting any Blueprint or design page, or writing any task or tracker change, merge the user's words with verified sources and return one short brief in the conversation. The brief is the entire reply: do not include decision proposals, a draft breakdown, an execution-consent question, or any other planning output. Include all five parts every time:
   - **Understanding:** restate the purpose and deliverable in the planner's own words.
   - **In scope / out of scope:** make both explicit. Name at least the nearest adjacent result the stream will not deliver.
   - **Success:** state the definition of success the plan will use.
   - **Assumptions:** list every point settled by inference instead of a verified source or the user's words, one line each, with the basis for the inference. If none remain, show where scope edges, audience, ordering, and quality bar were each settled.
   - **Open questions:** list what the planner cannot settle alone.
   Then stop. Confirmation must be a user reply sent after seeing the brief; a launch prompt, earlier chat, tracker note, or apparently complete stream never counts. Apply corrections before proceeding. If a reply leaves an assumption or open question unanswered, do not treat it as accepted: ask once more, then save any still-open point as an Octopad Question and keep affected tasks as flesh-out placeholders. Do not start step 3 or write any planning artifact until the user has confirmed the brief as corrected. The brief itself stays in chat; its confirmed content becomes the durable Decisions, Questions, tracker logic, and tasks.
3. **Lock decisions.** Present one remaining material choice at a time as Deciding, Options with gain and cost, Recommendation, and Reversibility. A choice explicitly settled in the scoping-brief reply is recorded directly instead of being presented again. Save only the accepted choice as an Octopad Decision.
4. **Set the order.** Close done-but-open work, log Questions, add missing tasks, and wire every real dependency. Prefix executable task titles `#N - ` for human-readable rank. Dependencies, not the number, decide readiness.
5. **Ground and make runnable.** For engineering, verify repository patterns, tests, data changes, permissions, rollback, and exact commands. For content or operations, read the governing canon and live surfaces. Missing access becomes a blocking task. Anything that must already be live appears under `Preconditions`.
6. **Spec every task.** Fill the template below with exact sources, boundaries, edge cases, checks, routing, and completion state. A task depending on unknown output stays a flesh-out placeholder.
7. **Add final validation.** Wire one final validation task after all delivery tasks. Give it one subtask per runnable check and include any manual acceptance checklist.
8. **Self-check saved state.** Re-open every task from Octopad, check the saved text and edges, repair failures, then reread repairs.
9. **Adversarial review.** One fresh reviewer, routed by the runtime's detection rubric, checks plan soundness, memory-less executability, and every spec against the confirmed brief. Before launch, save the block below in the stream tracker, reread it, and create exactly its saved lead and specialist; any Sol rationale states why Luna and Terra are inadequate. Add one simultaneous specialist only for two orthogonal material risks passing the runtime gate; task count and risk labels never qualify. Give distinct mandates, saved task text, and source access, not a summary. Both must PASS. A reduced replan uses one fresh routed reviewer; three or more added or materially rewritten tasks require a fresh full planning pass.
10. **Explain the logic.** Update the stream tracker with why the order exists, which branches are parallel, where human gates sit, what finishes the stream, and the Plan review block. Store no statuses or copied task content there.
11. **Mark and stop.** Append ` (octoplanned)` to the stream name if absent. Report the plan, then ask for execution approval exactly as the runtime reference requires. Do not launch anything yet.

## Task template

```text
Plan review:
- Lead: <model> · effort <level> — <detection target; why this route; mandate>
- Specialist: <model> · effort <level> — <orthogonal target; why this route; mandate>
```

Omit Specialist unless the two-review gate passes.

```text
Title: #N - <task title>

**Exec: <Codex model> · effort <level>** — <why>
**Review: required** — <detection target>
**Review route: <Codex model> · effort <level>** — <why this route; lead mandate>
**Specialist review route: <Codex model> · effort <level>** — <why this route; orthogonal mandate>
**Parallel-safe with: <immutable task ID> — <task title>; ...**
Preconditions: <what must already be live>

Why: <why this task exists and what it builds on>
What: <one job, scope, and boundaries>
How: <verified execution guidance: exact pointers, paths or symbols, approach and existing patterns, integration points, edge cases, invariants, approval gates>
Verify: <exact runnable commands or observable checks>
Done when: <durable result in its system of record>
Next: <the next task, parallel group, human gate, or none>
```

Keep `Specialist review route` only when its two-review gate passes. Keep `Parallel-safe with` only for a proven symmetric group and name every sibling by immutable ID. Omit `Preconditions` when none exist.

A fresh executor has no memory of the planning conversation, but it does have Octopad `build_context` plus access to the exact repository, document, page, and Decision pointers saved by the planner. Build the handoff in two layers:

1. The saved task carries the execution contract: expected result and reason; scope boundaries; accepted decisions; inputs and dependencies; verified execution guidance; exact pointers; acceptance criteria and verification; and the risks, safeguards, proof artifacts, or stop conditions that affect the job.
2. The executor starts by calling `build_context` in task mode, then rereads the current task, linked Octopad sources, and cited repository or document sources before acting.

Keep live source content in its system of record. A resolvable pointer is enough; do not copy pages, files, or broad background that `build_context` and the cited sources can supply. Put execution guidance in `How` and checks in `Verify`, and include only the conditional details that affect this job.

For engineering, use the planning pass's grounded analysis to identify the likely files and symbols, the expected change or approach, the existing pattern to follow, integration points, contracts or invariants to preserve, edge cases and regressions to watch, and exact test commands. Save the applicable guidance and pointers, not copied implementation context; the executor rereads the code before editing.

For business communication or editorial deliverables, also save the audience and channel, intended reader action or decision, and any message hierarchy, voice guidance, format, length, or editorial criteria that affect execution. Save permitted claims with sources whenever the work makes factual claims. Subjective quality never replaces factual verification.

For code, `Done when` names the repository's actual terminal state. If the repository requires a merged pull request, say so; do not stop at tests passing or a branch existing. Human-only tasks have no title rank, Exec, Review, Review route, or Next.

A placeholder keeps its ranked title and required Octopad sections:

```text
Why: <why the future task exists>
What: ⚠️ Octoplan flesh-out required: run an Octoplan pass before building, because <verified missing input>.
Done when: <the future observable result>
```

## Parallel work

Parallelism is exceptional. Every pair in a group must share no file, symbol, contract, generated artifact, editorial structure, migration, lockfile, or scarce external resource. Every member must have the same readiness frontier. Save `Parallel-safe with` symmetrically only after all tasks exist, using immutable Octopad IDs.

Continuation follows the dependency frontier. The owner that opens a parallel group claims and creates the complete saved group. Each member may advance only after the lead records durable completion following every required PASS. At fan-in, earlier siblings stop because the successor is not ready; the last reviewed completion sees every dependency satisfied and tries the guarded claim. If completions race, only the session whose claim succeeds creates the successor. `Next` plus dependency edges are sufficient, so existing plans need no new relay field.

## Multi-stream efforts and Blueprint

When one outcome needs several autonomous work streams, write one effort-level scoping brief before cutting it into streams. The brief must expose the proposed seams and what each stream owns. A later full Octoplan pass on one stream writes its own stream-level brief because the effort brief did not settle that stream's internals.

1. Link the streams to one goal and keep each autonomous package in its logical stream.
2. Wire real dependencies across streams in the same workspace.
3. Create one light Blueprint page containing the outcome, each stream's role, global order, parallel branches, major dependencies, human gates, and finish condition.
4. Keep statuses and copied task content out of the Blueprint.
5. Add Blueprint archival to the effort's final validation task.

The Blueprint explains the logic. The Octopad dependency graph enforces it.

## Replanning

Replan only when reality changes the plan, not on a schedule. A reduced event-driven rebalance may add or materially rewrite at most two tasks without rerunning the scoping brief, and only when the approved result, scope, material risk, cost, and definition of success stay unchanged. Mechanical title renumbering, dependency rewiring, and Next-line repairs do not count toward that limit. Revalidate affected specs, repair the graph and tracker logic, then rerun the relevant self-check and one fresh review.

Pure plan-hygiene repairs that add, remove, or materially rewrite no executable work may continue under the existing execution approval. Any added, removed, or materially rewritten executable task requires showing the revised saved plan and receiving fresh execution approval before execution continues.

Three or more added or materially rewritten tasks, added scope, materially changed risk or cost, or a changed definition of success are not a reduced rebalance. Pause execution and start a fresh full planning pass: return a new scoping brief and wait for confirmation before saving the revised plan. After review, show the revision and request explicit execution approval again.

## Saved-state self-check

For every executable task:

- The ranked title is unique.
- Why, What, Done when, impact, and impact rationale exist.
- Exec and Review match the runtime rubric; for objectively specified implementation with qualitative acceptance, the Exec rationale distinguishes choices the executor must originate from review-only judgment; every executable task has an exact lead Review route and rationale, any Specialist route has a justified orthogonal mandate, and every Sol rationale states why Luna and Terra are inadequate.
- How cites verified sources and a concrete existing pattern when one exists.
- Verify is exact and runnable now.
- Preconditions name every live assumption and external gate.
- The task contains one job and fits one session.
- The task carries a complete execution contract and enough verified guidance to focus the work; live source content remains reachable through `build_context` and exact pointers instead of being duplicated.
- A business communication or editorial task records its audience, channel, intended effect, and the message, voice, format, claim-source, factual-review, and editorial-review constraints that apply.
- Parallel links are immutable, complete, symmetric, and genuinely independent.
- Next matches the dependency graph.

For the plan:

- The user confirmed the scoping brief in a reply sent after seeing it, before any planning artifact was written.
- Every assumption in the brief was confirmed, corrected, or saved as a Question with affected tasks left as flesh-out placeholders.
- Every saved spec matches the confirmed brief and its corrections.
- The definition of success matches real scope.
- Every material choice is a recorded Decision.
- Every real dependency is wired.
- Final validation follows all delivery tasks.
- The reread Plan review block matches created reviewers and the runtime rubric.
- Tracker and Blueprint contain logic only.
- Nothing exists merely to serve process.
