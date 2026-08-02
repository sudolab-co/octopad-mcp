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
- Save the environment-bound `octoplan-supervision-v2` contract for every executable plan. A pre-4.0 plan must be replanned, not silently migrated.
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
5. **Ground and make runnable.** For engineering, verify repository patterns, tests, data changes, permissions, rollback, and exact commands. For content or operations, read the governing canon and live surfaces. Call `list_projects` and select the exact native target for the inline supervisor, any dedicated supervisor, and every task role. Missing access or an unavailable project becomes a blocking task. Anything that must already be live appears under `Preconditions`.
6. **Spec every task.** Fill the template below with exact sources, boundaries, edge cases, checks, routing, and completion state. A task depending on unknown output stays a flesh-out placeholder.
7. **Add final validation.** Wire one final-validation task after all delivery tasks. Give it one subtask per runnable check and include any manual acceptance checklist. For one stream, this task is also the coordination ledger.
8. **Explain and bind.** Update each tracker with order, parallel branches, human gates, finish condition, and only the supervision pointer below. Append ` (octoplanned)` to each stream name if absent. For multi-stream work, designate one cross-stream coordination/final-validation task. Save one Plan manifest there with participant IDs, supervision policy and routes, execution environment, defaults, and Plan review routes.
9. **Self-check and fingerprint.** Re-open every tracker and task, repair failures, then reread repairs. Canonicalize the complete contract as specified below, save its SHA-256 in the Plan manifest and every tracker pointer, and reread them.
10. **Adversarial review.** One fresh subagent, routed by the runtime's plan-review rubric, checks plan soundness, memory-less executability, supervision, and every spec against the confirmed brief. Spawn exactly the saved lead and specialist, never user-owned threads. Add one simultaneous specialist only for two orthogonal material risks passing the runtime gate. Every PASS is persisted on the ledger and names the exact plan hash. Any change invalidates PASS and returns to step 9.
11. **Report and stop.** Report the verified plan and its hash, then ask for execution approval exactly as the runtime reference requires. Do not launch anything yet.

## Task template

```text
Supervision contract:
- Schema: octoplan-supervision-v2
- Coordination ledger task ID: <immutable task ID>
- Policy: dedicated for 4+ remaining delivery tasks (final validation excluded), any parallel fan-out/fan-in, multi-stream, or 2+ tasks across a human, external, or explicit interruption gate
- Inline route: <model> · effort <level>
- Dedicated route: <model> · effort <level> — <why this is the cheapest adequate scheduler>
- Dedicated replacement: max 1 per run — authoritative terminal non-resumable evidence required
- Default recovery: same saved route; max 1 per role — authoritative terminal non-resumable evidence required
- Default lineage: roots use a clean base; successors use accepted dependency revisions; fan-in uses a named integrated revision
```

Save this contract once in the ledger's Plan manifest. Omit Dedicated route and replacement when no dedicated predicate is true; later expansion needs a new plan.

```text
Execution environment:
- Inline supervisor target: <project ID · local|worktree · observed host ID, canonical path, and Git true|false> | <projectless · directory name · explicit rationale>
- Dedicated supervisor target: <exact target> | none
- Default executor target: <exact target>
- Task-role target overrides: <task ID · executor|lead-reviewer|specialist-reviewer → exact target> | none
- Reviewer default: inherit the executor creation record's exact target
```

Resolve every project through `list_projects` during planning. A project target binds project ID and environment; also record the observed host ID, canonical path, and Git flag as non-binding discovery evidence. A projectless target binds its directory name and explicit rationale; absence of a project field never means projectless. Default Git children use a worktree unless the plan explicitly saves `local`. Reviewer and same-role recovery sessions inherit the executor or superseded creation record's exact target unless a task-role override is saved.

Each tracker stores only `Supervision: octoplan-supervision-v2 · ledger <ID> · plan <SHA-256>`.

```text
Plan review:
- Lead: <model> · effort <level> — <detection target; why this route; mandate>
- Specialist: <model> · effort <level> — <orthogonal target; why this route; mandate>
```

Save Plan review in the same manifest. Omit Specialist unless the two-review gate passes.

```text
Title: #N - <task title>

**Exec: <Codex model> · effort <level>** — <why>
**Review: required** — <detection target>
**Review route: <Codex model> · effort <level>** — <why this route; lead mandate>
**Specialist review route: <Codex model> · effort <level>** — <why this route; orthogonal mandate>
**Fallback: Exec → <Codex model> · effort <level>; max <N>** — <at least 2 required observations and exact count; observations that would establish sound prompt, context, access, environment, and verifier>
**Recovery override: same saved route; max <N> per role** — <why the contract default is inadequate; terminal evidence required>
**Lineage override: <approved stacked branch|named merge or integration gate>** — <why the contract default is inadequate>
**Parallel-safe with: <immutable task ID> — <task title>; ...**
Preconditions: <what must already be live>

Why: <why this task exists and what it builds on>
What: <one job, scope, and boundaries>
How: <verified execution guidance: exact pointers, paths or symbols, approach and existing patterns, integration points, edge cases, invariants, approval gates>
Verify: <exact runnable commands or observable checks>
Done when: <durable result in its system of record>
Next: <the next task, parallel group, human gate, or none>
```

Keep `Specialist review route` only when its two-review gate passes. Keep `Fallback`, `Recovery override`, and `Lineage override` only when justified; contract defaults otherwise apply. Keep `Parallel-safe with` only for a proven symmetric group and name every sibling by immutable ID. Omit `Preconditions` when none exist.

## Fingerprint

Build canonical JSON from the schema and ledger ID; manifest policy, routes, binding execution targets, defaults, and Plan review routes; participating stream IDs and tracker text; governing Decision IDs and text; and every executable task's ID, title, description, dependencies, assignment, impact, and routes. Task and tracker text remains authoritative; the manifest stores IDs, not copies. Canonicalize each project target as project ID plus environment and each projectless target as directory name plus rationale; include each task-role override once under its task ID and role. The current supervision mode is excluded, along with observed host, path, and Git evidence, tracker `Supervision` lines, statuses, comments, timestamps, claims, owners, epochs, attempts, artifact revisions, and thread IDs.

Sort object keys lexicographically, sort set-like arrays by immutable ID, preserve semantic sequences, and remove insignificant whitespace. Hash with SHA-256 before plan review. Every plan-review PASS and execution consent binds that exact hash.

A fresh executor has only Octopad `build_context` and the saved pointers. Its task must carry result and reason, boundaries, decisions, inputs, dependencies, verified guidance, acceptance, checks, risks, gates, and exact sources. It starts with task-mode `build_context`, then rereads the task and sources. Keep live content at source rather than copying it.

For engineering, save likely files and symbols, approach and existing pattern, integration points, invariants, edge cases, and exact commands. For communication or editorial work, save audience, channel, intended effect, hierarchy, voice, format, length, claim sources, and review criteria. Subjective quality never replaces factual verification.

For code, `Done when` names the repository's actual terminal state. If the repository requires a merged pull request, say so; do not stop at tests passing or a branch existing. Human-only tasks have no title rank, Exec, Review, Review route, or Next.

A placeholder keeps its ranked title and required Octopad sections:

```text
Why: <why the future task exists>
What: ⚠️ Octoplan flesh-out required: run an Octoplan pass before building, because <verified missing input>.
Done when: <the future observable result>
```

## Parallel work

Parallelism is exceptional. Every pair in a group must share no file, symbol, contract, generated artifact, editorial structure, migration, lockfile, or scarce external resource. Every member must have the same readiness frontier. Save `Parallel-safe with` symmetrically only after all tasks exist, using immutable Octopad IDs.

The supervisor claims and creates the complete saved group. Each member advances only after its lead records durable completion following every required PASS. At fan-in, the supervisor waits for every dependency, records one integrated revision, and makes one guarded successor claim. Children and reviewers never relay.

## Multi-stream efforts and Blueprint

When one outcome needs several autonomous work streams, write one effort-level scoping brief before cutting it into streams. The brief must expose the proposed seams and what each stream owns. A later full Octoplan pass on one stream writes its own stream-level brief because the effort brief did not settle that stream's internals.

1. Link the streams to one goal and keep each autonomous package in its logical stream.
2. Wire real dependencies across streams in the same workspace.
3. Create one light Blueprint page containing the outcome, each stream's role, global order, parallel branches, major dependencies, human gates, finish condition, and shared coordination-ledger task ID.
4. Keep statuses and copied task content out of the Blueprint.
5. Add Blueprint archival to the effort's final validation task.

The Blueprint explains the logic. The Octopad dependency graph enforces it.

## Replanning

Replan only when reality changes the plan, not on a schedule. Before changing an executing plan, guardedly pause and supersede its run; child guards then block further writes. A reduced event-driven rebalance may add, remove, or materially rewrite at most two tasks without rerunning the scoping brief only when result, scope, material cost, risk, and success stay unchanged. Every saved plan change, including hygiene, needs a new hash, review, consent, and run.

Three or more added, removed, or materially rewritten tasks, added scope, or changed material cost, risk, or success require a fresh full planning pass.

## Saved-state self-check

For every executable task:

- The ranked title is unique.
- Why, What, Done when, impact, and impact rationale exist.
- Exec and Review match the runtime rubric; for objectively specified implementation with qualitative acceptance, the Exec rationale distinguishes choices the executor must originate from review-only judgment; every executable task has an exact lead Review route and rationale, any Specialist route has a justified orthogonal mandate, and every Sol rationale states why Luna and Terra are inadequate.
- Fallback, when present, names the executor's exact route, repeated-evidence count, required non-capability observations, and bound. Any Recovery or Lineage override explains why the default is inadequate.
- How cites verified sources and a concrete existing pattern when one exists.
- Verify is exact and runnable now.
- Preconditions name every live assumption and external gate.
- The task contains one job and fits one session.
- A business communication or editorial task records its audience, channel, intended effect, and the message, voice, format, claim-source, factual-review, and editorial-review constraints that apply.
- Every ready frontier is exactly one task or one complete immutable, symmetric, genuinely independent parallel group.
- Next matches the dependency graph.

For the plan:

- The user confirmed the scoping brief in a reply sent after seeing it, before any planning artifact was written.
- Every assumption in the brief was confirmed, corrected, or saved as a Question with affected tasks left as flesh-out placeholders.
- Every saved spec matches the confirmed brief and its corrections.
- The definition of success matches real scope.
- Every material choice is a recorded Decision.
- Every real dependency is wired.
- Final validation follows all delivery tasks.
- The inline supervisor target, any dedicated supervisor target, default executor target, and every task-role override resolve uniquely through `list_projects`; projectless is explicit and justified.
- Every tracker carries the same schema, ledger pointer, and plan hash; the ledger carries one complete Plan manifest.
- The canonical input includes every field required by Fingerprint, uses its ordering rules, and excludes only its named execution state.
- Every persisted Plan review PASS matches the current hash, saved routes, mandates, and runtime rubric.
- Tracker and Blueprint contain logic only.
- Nothing exists merely to serve process.
