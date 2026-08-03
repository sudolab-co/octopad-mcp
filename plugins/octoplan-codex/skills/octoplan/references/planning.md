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
- Save the environment-bound `octoplan-supervision-v3` contract for every executable plan. An older plan must be replanned, not silently granted repair, wake, or autonomous-launch authority.
- On every full planning pass, return the scoping brief below as the whole reply and wait for the user's later confirmation before any planning write. The brief includes validation timing. Only a material replan returns to this gate; bounded runtime repairs do not.
- Run the scoping brief, saved-state self-check, and adversarial plan review on every full planning pass. Runtime repairs use the bounded repair loop; material changes return to a full pass.

## Workflow

1. **Review or discover.** Read the whole existing stream. If it is thin, interview the user one material theme at a time: outcome, audience, scope, constraints, proof, and human owners. Ask only questions whose answers can change the result, risk, order, or gate. No planning artifact is saved yet.
2. **Scoping brief — reflect back, then wait.** Merge the user's words with verified sources and return one short brief as the entire reply. Include:
   - **Understanding:** purpose and deliverable in the planner's own words.
   - **In scope / out of scope:** both explicit, including the nearest adjacent excluded result.
   - **Success:** the definition of success the plan will use.
   - **Assumptions:** every inference and its verified basis. If none remain, show where scope edges, audience, ordering, and quality bar were settled.
   - **Open questions:** only points the planner cannot settle safely.
   - **Validation mode:** `gradual` reviews each human-reviewable artifact as it becomes ready; `final` stacks every safe agent-owned artifact and places human review at the end. Recommend one. Name any unavoidable mid-run human gate, especially a migration that must be applied before later proof can run.
   Then stop. Confirmation must be a later user reply. Apply corrections before proceeding. Ask an unanswered material point once more, then save it as a Question and leave affected tasks as flesh-out placeholders.
3. **Lock decisions.** Present each remaining material choice as Deciding, Options with gain and cost, Recommendation, and Reversibility. Save only accepted choices as Octopad Decisions. Record the confirmed validation mode.
4. **Ground and preflight.** Verify repository or governing-source patterns, checks, data changes, permissions, rollback, access, and exact native targets. Simulate the first ready frontier. A plan whose first agent-owned task is already blocked is incomplete: add the missing prerequisite to the draft or return the unresolved choice to the user before saving.
5. **Draft the complete graph off-record.** Give every draft task one stable symbolic key, then draft ranked delivery tasks, separate human tasks, dependencies, routes, repair envelope, final validation, tracker logic, and any Blueprint without writing partial tasks to Octopad. Parallel and dependency references use symbolic keys until Octopad assigns immutable IDs. One task equals one coherent job. Every delivery task ends at a review-ready agent-owned artifact; merge, migration application, deployment, publication, and human acceptance live in separate human tasks.
6. **Calibrate task review.** Every delivery task gets an adversarial check. Save the narrowest adequate class: `targeted` for exact metadata or mechanical changes with deterministic proof and no fresh thread; `independent` for normal artifact review in one fresh thread; `specialist` only for a second orthogonal material failure domain. Review timing follows the confirmed validation mode.
7. **Adversarially review the draft.** One fresh subagent checks design soundness, memory-less executability, dependency feasibility, human/agent separation, repair bounds, and consistency with the confirmed brief. Add one simultaneous specialist only for an orthogonal material risk. Fix confirmed findings in the draft and rerun only the affected lens. Reviewers do not create user-owned threads.
8. **Write the reviewed final plan to Octopad.** Save Decisions, Questions, tasks, dependencies, final validation, tracker logic, Blueprint, and one Plan manifest. Resolve every symbolic key to its new immutable ID as one mechanical transcription step. Append ` (octoplanned)` to participating stream names if absent. Do not save review drafts as tasks.
9. **Read back and fingerprint.** Reopen every saved item and deterministically normalize immutable IDs back to the reviewed symbolic keys. Compare that semantic form with the reviewed draft, repair literal transcription defects, and reread repairs. Canonicalize the complete saved contract and save its SHA-256 in the Plan manifest and every tracker pointer. Derive the final binding record from the draft-review PASS, reviewed draft digest, exact final hash, and deterministic equality proof. Wake the existing plan reviewer only if a semantic delta exists; then return to step 7 for the affected lens.
10. **Ask before launch.** Record the verified plan and exact final hash in the Plan manifest and ledger, report the plan without printing that hash, ask the runtime execution question, and stop. Do not create any execution session until a later explicit yes binds the saved hash.

## Task template

```text
Supervision contract:
- Schema: octoplan-supervision-v3
- Coordination ledger task ID: <immutable task ID>
- Policy: dedicated for 4+ remaining delivery tasks (final validation excluded), any parallel fan-out/fan-in, multi-stream, or 2+ tasks across a human, external, or explicit interruption gate
- Validation mode: gradual | final
- Repair envelope: within one approved task's result, scope, risk, and acceptance; max 2 sequential repairs per delivery task; max depth 1; one active repair per task
- Follow-up policy: record non-blocking work outside the active participant set; never execute it in this run
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

Each tracker stores only `Supervision: octoplan-supervision-v3 · ledger <ID> · plan <SHA-256>`.

```text
Plan review:
- Reviewed draft digest: <SHA-256 over normalized symbolic draft>
- Lead: <model> · effort <level> — <detection target; why this route; mandate>
- Specialist: <model> · effort <level> — <orthogonal target; why this route; mandate>
- Final binding: <final plan SHA-256 · deterministic saved-state equality proof>
```

Save Plan review in the same manifest. Omit Specialist unless the two-review gate passes.

```text
Title: #N - <task title>

**Exec: <Codex model> · effort <level>** — <why>
**Review: targeted | independent | specialist** — <detection target and why this is the narrowest adequate class>
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
Done when: <agent-owned durable review-ready result: immutable artifact, required checks, review evidence, complete repository-required PR or handoff metadata, and handoff evidence; never merge, migration application, deployment, publication, or human acceptance>
Next: <the next task, parallel group, human gate, or none>
```

Keep `Review route` only for independent or specialist review. A targeted review names its deterministic checks and reuses the current executor or supervisor context; it never creates a fresh review thread. Keep `Specialist review route` only when its two-review gate passes. Keep `Fallback`, `Recovery override`, and `Lineage override` only when justified; contract defaults otherwise apply. Keep `Parallel-safe with` only for a proven symmetric group and name every sibling by immutable ID. Omit `Preconditions` when none exist.

Create a separate human task for each human review, merge, migration application, deployment, publication, access grant, or acceptance gate. It has Why, What, Done when, owner, impact, and dependencies, but no rank, Exec, Review, route, or Next. Its Done when names only the human-owned action and exact evidence. When an external event can resume it, save a wake predicate naming provider, repository and artifact, accepted event/action, expected owner or approval rule, required checks, and head-revision relation. In final validation mode, wire these tasks after the complete safe artifact stack unless a verified live prerequisite makes an earlier gate unavoidable.

## Fingerprint

Build canonical JSON from the schema and ledger ID; validation mode, repair envelope, follow-up policy, routes, binding execution targets, defaults, and Plan review routes; participating stream IDs and tracker text; governing Decision IDs and text; and every planned agent and human task's ID, title, description, dependencies, assignment, impact, and routes. Task and tracker text remains authoritative; the manifest stores IDs, not copies. Canonicalize each project target as project ID plus environment and each projectless target as directory name plus rationale; include each task-role override once under its task ID and role. The current supervision mode is excluded, along with observed host, path, and Git evidence, tracker `Supervision` lines, statuses, comments, timestamps, claims, owners, epochs, attempts, artifact revisions, thread IDs, run-scoped repair subtasks, and follow-ups outside the participant set.

Sort object keys lexicographically, sort set-like arrays by immutable ID, preserve semantic sequences, and remove insignificant whitespace. Hash with SHA-256 after saved-state readback. The final binding record combines the draft-review PASS, normalized draft digest, deterministic saved-state equality proof, and exact final hash. Every execution consent binds that exact final hash.

A fresh executor has only Octopad `build_context` and the saved pointers. Its task must carry result and reason, boundaries, decisions, inputs, dependencies, verified guidance, acceptance, checks, risks, gates, and exact sources. It starts with task-mode `build_context`, then rereads the task and sources. Keep live content at source rather than copying it.

For engineering, save likely files and symbols, approach and existing pattern, integration points, invariants, edge cases, and exact commands. For communication or editorial work, save audience, channel, intended effect, hierarchy, voice, format, length, claim sources, and review criteria. Subjective quality never replaces factual verification.

For code, the delivery task's `Done when` ends at the repository's review-ready agent state, including the immutable revision, required CI, adversarial PASS, and required handoff. A separate human task carries merge and any post-merge action. Human-only tasks have no title rank, Exec, Review, Review route, or Next. A repository rule may still require the delivery handoff to happen only after green CI; that handoff remains agent-owned even though the decision it requests is human-owned.

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

## Runtime discoveries: repair, follow-up, or replan

Classify every discovery against the confirmed brief and the affected task before writing:

- **Repair:** blocks an approved task but stays inside its result, scope, risk, acceptance, route bounds, and protected-action boundary. The supervisor saves one guarded repair record, routes it to the cheapest adequate existing executor or a justified fresh agent, reviews only the affected surface, and resumes the parent. Create an Octopad repair subtask only when it needs separate ownership, a distinct route, or persistence across a wake. The approved repair envelope, not the future repair record or subtask text, is fingerprinted. Use at most one active repair, two sequential repairs per parent, and depth one. Exceeding any bound requires replan.
- **Follow-up:** concrete, useful work that does not block the active definition of success. Create a normal todo task outside the active participant set with provenance, reason, acceptance criterion, deduplication check, and routing rationale. Do not execute it in this run. Report it in the final recap.
- **Replan:** changes result, scope, material cost, risk, success, architecture, task meaning, route bounds, validation mode, or protected actions. Guardedly pause and supersede the run, review the revised plan, obtain the required consent, and start a new run.

PR metadata correction, source-date completion, migration renumbering after upstream drift, CI configuration repair, and verifier repair are repairs only when the predicate above is true. Every change to a planned task, dependency, route, tracker logic, or other fingerprinted field is a replan, even when mechanical. Never call work a repair merely because asking the user is inconvenient. Persist the comparison with the confirmed brief before any artifact write so the task reviewer can reject a misclassification.

## Saved-state self-check

For every executable task:

- The ranked title is unique.
- Why, What, Done when, impact, and impact rationale exist.
- Exec and Review match the runtime rubric; every delivery task has targeted, independent, or specialist review with a concrete detection target; targeted review has deterministic proof and no fresh route, every independent review has an exact lead route, any Specialist route has a justified orthogonal mandate, and every Sol rationale states why Luna and Terra are inadequate.
- Fallback, when present, names the executor's exact route, repeated-evidence count, required non-capability observations, and bound. Any Recovery or Lineage override explains why the default is inadequate.
- How cites verified sources and a concrete existing pattern when one exists.
- Verify is exact and runnable now.
- Preconditions name every live assumption and external gate.
- The task contains one job and fits one session.
- Delivery Done when ends at a review-ready agent artifact. Every human review, merge, migration application, deployment, publication, access grant, and acceptance action is a separate owned task.
- A business communication or editorial task records its audience, channel, intended effect, and the message, voice, format, claim-source, factual-review, and editorial-review constraints that apply.
- Every ready frontier is exactly one task or one complete immutable, symmetric, genuinely independent parallel group.
- Next matches the dependency graph.

For the plan:

- The user confirmed the scoping brief in a reply sent after seeing it, before any planning artifact was written.
- Every assumption in the brief was confirmed, corrected, or saved as a Question with affected tasks left as flesh-out placeholders.
- Every saved spec matches the confirmed brief and its corrections.
- The definition of success matches real scope.
- Validation mode was explicitly confirmed, and every unavoidable mid-run human gate was disclosed in the brief.
- Every material choice is a recorded Decision.
- Every real dependency is wired.
- The first agent-owned frontier is executable from current access; no hidden dependency can block the run at task one.
- Final validation follows every delivery task and every human task whose evidence is required by the definition of success.
- The inline supervisor target, any dedicated supervisor target, default executor target, and every task-role override resolve uniquely through `list_projects`; projectless is explicit and justified.
- Every tracker carries the same schema, ledger pointer, and plan hash; the ledger carries one complete Plan manifest.
- The canonical input includes every field required by Fingerprint, uses its ordering rules, and excludes only its named execution state.
- Every final binding record carries the reviewed draft digest, matching review PASS, deterministic saved-state equality proof, current hash, saved routes, mandates, and runtime rubric.
- The manifest carries the bounded repair envelope and follow-up policy; no planned task relies on dynamic repair to fill a known prerequisite.
- Tracker and Blueprint contain logic only.
- Nothing exists merely to serve process.
