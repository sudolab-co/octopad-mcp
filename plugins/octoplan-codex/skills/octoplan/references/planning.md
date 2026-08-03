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
- Save the environment-bound `octoplan-supervision-v4` contract for every executable plan. A plan without that contract must be replanned, not silently granted fingerprint, repair, wake, or autonomous-launch authority. An existing 6.0 plan with that contract and normal later final-hash consent remains valid.
- On every full planning pass, return the scoping brief below as the whole reply and wait for the user's later confirmation before any planning write. The brief includes validation timing. Only a material replan returns to this gate; bounded runtime repairs do not.
- A user may combine that later confirmation with explicit advance execution authorization. Record the exact source reply and time. Never infer advance authorization from a bare brief confirmation, broad autonomy language, a prior chat, or permission to plan.
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
   Then stop. Confirmation must be a later user reply. Apply corrections before proceeding. Ask an unanswered material point once more, then save it as a Question and leave affected tasks as flesh-out placeholders. The same later reply may explicitly authorize automatic execution of the reviewed plan if it remains within the confirmed brief. Keep that authorization as run-authority evidence; it does not relax planning, review, fingerprint, protected-action, or human-gate requirements.
3. **Lock decisions.** Present each remaining material choice as Deciding, Options with gain and cost, Recommendation, and Reversibility. Save only accepted choices as Octopad Decisions. Record the confirmed validation mode.
4. **Ground and preflight.** Verify repository or governing-source patterns, checks, data changes, permissions, rollback, access, and exact native targets. Simulate the first ready frontier. A plan whose first agent-owned task is already blocked is incomplete: add the missing prerequisite to the draft or return the unresolved choice to the user before saving.
5. **Draft the complete graph off-record.** Give every draft task one stable symbolic key, then draft ranked delivery tasks, separate human tasks, dependencies, routes, repair envelope, final validation, tracker logic, and any Blueprint without writing partial tasks to Octopad. Parallel and dependency references use symbolic keys until Octopad assigns immutable IDs. One task equals one coherent job. Every delivery task ends at a review-ready agent-owned artifact; merge, migration application, deployment, publication, and human acceptance live in separate human tasks.
6. **Calibrate task review.** Every delivery task gets an adversarial check. Save the narrowest adequate class: `targeted` for exact metadata or mechanical changes with deterministic proof and no fresh thread; `independent` for normal artifact review in one fresh thread; `specialist` only for a second orthogonal material failure domain. Review timing follows the confirmed validation mode.
7. **Adversarially review the draft.** One fresh subagent checks design soundness, memory-less executability, dependency feasibility, human/agent separation, repair bounds, and consistency with the confirmed brief. Add one simultaneous specialist only for an orthogonal material risk. Fix confirmed findings in the draft and rerun only the affected lens. Reviewers do not create user-owned threads.
8. **Write the reviewed final plan to Octopad.** Save Decisions, Questions, tasks, dependencies, final validation, tracker logic, Blueprint, and one Plan manifest. Resolve every symbolic key to its new immutable ID as one mechanical transcription step. Append ` (octoplanned)` to participating stream names if absent. Do not save review drafts as tasks.
9. **Read back and fingerprint.** Reopen every saved item and deterministically normalize immutable IDs back to the reviewed symbolic keys. Compare that semantic form with the reviewed draft, repair literal transcription defects, and reread repairs. Set saved-state equality to PASS only after exact semantic equality. Canonicalize the complete saved contract and save its SHA-256 in the Plan manifest and every tracker pointer. Derive the final binding record from the draft-review PASS, reviewed draft digest, exact final hash, and saved-state equality PASS. Wake the existing plan reviewer only if a semantic delta exists; then return to step 7 for the affected lens.
10. **Resolve launch authority.** Record the verified plan and exact final hash in the Plan manifest and ledger. If no valid advance authorization exists, report the plan without printing that hash, ask the runtime execution question, and stop until a later explicit yes binds the saved hash. If explicit advance authorization was given after the confirmed brief, verify again that the final reviewed plan has no unresolved Question or material delta from that brief in result, scope, material cost, risk, success, architecture, route bounds, validation mode, or protected actions. On PASS, use `tasks(action: "update")` with the coordination-ledger task's current `expected_updated_at` to append one launch-binding record as a ledger comment containing the source reply and time, confirmed-brief digest, exact final plan hash, review PASS, saved-state equality PASS, and no-material-delta assertion; never put the record in the task description or Plan manifest. Then report that the verified plan is launching under the prior authority and continue into supervision. Any mismatch, missing evidence, failed guarded update, or material replan invalidates advance authorization and returns to the normal execution question. Never create an execution session before either a later final-hash yes or a valid launch-binding record exists.

## Task template

```text
Supervision contract:
- Schema: octoplan-supervision-v4
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
- Task-role target override: <task ID> · <executor|lead-reviewer|specialist-reviewer> → <exact target>
- Task-role target overrides: none
- Reviewer default: inherit the executor creation record's exact target
```

Use one singular `Task-role target override` line per override; use the plural `Task-role target overrides: none` line only when the list is empty. Resolve every project through `list_projects` during planning. A project target binds project ID and environment; also record the observed host ID, canonical path, and Git flag as non-binding discovery evidence. A projectless target binds its directory name and explicit rationale; absence of a project field never means projectless. Default Git children use a worktree unless the plan explicitly saves `local`. Reviewer and same-role recovery sessions inherit the executor or superseded creation record's exact target unless a task-role override is saved.

Each tracker stores only `Supervision: octoplan-supervision-v4 · ledger <ID> · plan <SHA-256>`.

Save `Plan hash: <SHA-256>` once as a top-level field in the ledger's Plan manifest.

Store the complete Plan manifest inside the ledger task description between exactly one pair of sentinel lines, each on its own line: `OCTOPLAN_PLAN_MANIFEST_V4_BEGIN` and `OCTOPLAN_PLAN_MANIFEST_V4_END`. No other content uses either sentinel.

```text
Plan review:
- Reviewed draft digest: <SHA-256 over normalized symbolic draft>
- Lead: <model> · effort <level> — <detection target; why this route; mandate>
- Specialist: <model> · effort <level> — <orthogonal target; why this route; mandate>
- Review PASS: <matching draft-review PASS record>
- Final binding:
  - Plan hash: <final plan SHA-256>
  - Saved-state equality: PASS
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

Build exactly one `octoplan-fingerprint-v1` input object from the current durable sources. Every shown key is present. Replace angle-bracket values with the saved value, use `null` for an inapplicable scalar, and use `[]` for an inapplicable list.

```json
{
  "fingerprint_schema": "octoplan-fingerprint-v1",
  "ledger_task_id": "<immutable ledger task ID>",
  "plan_hash": "PENDING",
  "manifest": {
    "supervision_contract": {
      "schema": "octoplan-supervision-v4",
      "policy": "<exact Policy value>",
      "validation_mode": "<gradual|final>",
      "repair_envelope": "<exact Repair envelope value>",
      "follow_up_policy": "<exact Follow-up policy value>",
      "inline_route": "<exact Inline route value>",
      "dedicated_route": "<exact Dedicated route value or null>",
      "dedicated_replacement": "<exact Dedicated replacement value or null>",
      "default_recovery": "<exact Default recovery value>",
      "default_lineage": "<exact Default lineage value>"
    },
    "execution_environment": {
      "inline_supervisor_target": {
        "kind": "<project|projectless>",
        "project_id": "<project ID or null>",
        "environment": "<local|worktree or null>",
        "directory_name": "<projectless directory name or null>",
        "rationale": "<projectless rationale or null>"
      },
      "dedicated_supervisor_target": {
        "kind": "<project|projectless>",
        "project_id": "<project ID or null>",
        "environment": "<local|worktree or null>",
        "directory_name": "<projectless directory name or null>",
        "rationale": "<projectless rationale or null>"
      },
      "default_executor_target": {
        "kind": "<project|projectless>",
        "project_id": "<project ID or null>",
        "environment": "<local|worktree or null>",
        "directory_name": "<projectless directory name or null>",
        "rationale": "<projectless rationale or null>"
      },
      "task_role_target_overrides": [
        {
          "task_id": "<task ID>",
          "role": "<executor|lead-reviewer|specialist-reviewer>",
          "target": {
            "kind": "<project|projectless>",
            "project_id": "<project ID or null>",
            "environment": "<local|worktree or null>",
            "directory_name": "<projectless directory name or null>",
            "rationale": "<projectless rationale or null>"
          }
        }
      ],
      "reviewer_default": "<exact Reviewer default value>"
    },
    "plan_review": {
      "reviewed_draft_digest": "<lowercase SHA-256>",
      "lead": "<literal Lead line>",
      "specialist": "<literal Specialist line or null>",
      "review_pass": "<literal matching Review PASS record>",
      "final_binding": {
        "plan_hash": "PENDING",
        "saved_state_equality": true
      }
    }
  },
  "streams": [
    {
      "id": "<stream ID>",
      "title": "<stream title>",
      "tracker_text": "<tracker text without its generated Supervision line>"
    }
  ],
  "decisions": [
    {
      "id": "<Decision ID>",
      "work_stream_id": "<owning stream ID or null>",
      "title": "<exact title>",
      "content": "<exact chosen outcome>",
      "rationale": "<exact rationale>",
      "decision_status": "<exact decision status>"
    }
  ],
  "tasks": [
    {
      "id": "<task ID>",
      "work_stream_id": "<owning stream ID>",
      "parent_task_id": "<parent task ID or null>",
      "title": "<task title>",
      "description": "<task description>",
      "dependencies": [
        { "id": "<dependency task ID>", "rationale": "<edge rationale>" }
      ],
      "assignment": "<saved assignee or owner, or null>",
      "impact": 1,
      "impact_rationale": "<impact rationale>",
      "routes": {
        "exec": "<literal Exec line or null>",
        "review": "<literal Review line or null>",
        "review_route": "<literal Review route line or null>",
        "specialist_review_route": "<literal Specialist review route line or null>",
        "fallback": "<literal Fallback line or null>",
        "recovery_override": "<literal Recovery override line or null>",
        "lineage_override": "<literal Lineage override line or null>",
        "parallel_safe_with": ["<sibling task ID>"]
      }
    }
  ]
}
```

Extract every supervision-contract string as the exact value after its unique `- <Label>: ` prefix. A missing or duplicate required label stops fingerprinting. Use `null` only for an omitted Dedicated route and Dedicated replacement. The coordination-ledger ID is represented only by root `ledger_task_id`.

Parse every saved target into the five-key target object shown for `inline_supervisor_target`; `dedicated_supervisor_target` alone is JSON `null` when the saved value is `none`. For a project target, split on the first two literal ` · ` separators: the first field is `project_id`, the second is `environment`, and the remaining observed evidence is excluded; set `directory_name` and `rationale` to `null`. For a projectless target, require `projectless · <directory name> · <rationale>` and reject a directory name containing the literal separator ` · ` before saving the plan. Preserve the complete remainder after the second separator as `rationale`, set `project_id` and `environment` to `null`, and do not infer a missing field. Parse each singular target-override line at its first literal ` · ` and first literal ` → ` into `task_id`, `role`, and the same target object; the plural `none` line produces `[]`. A missing, duplicate, or malformed binding field stops fingerprinting.

`plan_review` retains the reviewed draft digest, review routes, matching review PASS, and boolean saved-state equality result, but its final plan hash is always normalized to `PENDING`. Equality is `true` only for the literal saved value `PASS`; any other or missing value stops fingerprinting. Extract every other Plan review string as the exact value after its unique label.

For each governing Octopad Decision, read the durable `id`, `work_stream_id`, `title`, `content`, `rationale`, and `decision_status` fields directly; use JSON `null` for an absent nullable field and never compose them into a synthetic text string. Include all planned agent and human tasks with their owning stream and nullable parent. Human tasks use `null` and `[]` for inapplicable route fields; their owner remains in `assignment`. Extract each route as the exact saved line value; a missing optional line is `null` or `[]`, never an invented default. Task and tracker text remains authoritative; the manifest stores IDs, not copies. The concrete `impact` value is a JSON number from 1 through 5, never a string.

For the task whose ID equals `ledger_task_id`, normalize LF first, then remove the one complete Plan-manifest region from the beginning of its `OCTOPLAN_PLAN_MANIFEST_V4_BEGIN` sentinel through the end of its `OCTOPLAN_PLAN_MANIFEST_V4_END` sentinel; preserve every byte before and after that region as the task's fingerprinted `description`. Missing, duplicate, nested, or reversed sentinels stop fingerprinting. The removed manifest is represented only by the structured root `plan_hash` and `manifest` fields. After the two structured final-hash fields are set to `PENDING` and generated tracker pointers and the ledger manifest region are removed, scan every included JSON string value. If any still contains the persisted final plan digest, stop instead of hashing it.

The current supervision mode is excluded, along with observed host, path, and Git evidence, generated tracker `Supervision` lines, statuses, comments, timestamps, claims, runtime owners, epochs, attempts, artifact revisions, thread IDs, execution-consent evidence, launch-binding records, run-scoped repair records or subtasks, external-event receipts, and follow-ups outside the participant set. Ledger comments and tracker pointers are not fingerprint inputs.

Normalize line endings in source text to LF only before extracting fields. Do not otherwise trim source text or normalize Unicode. Reject an unpaired Unicode surrogate. Sort object keys by Unicode scalar-value order over their unescaped names. Sort `streams`, `decisions`, `tasks`, each task's `dependencies`, and `parallel_safe_with` by immutable `id`; sort `task_role_target_overrides` by `task_id`, then `role`; preserve every other sequence order.

Serialize JSON strings by emitting every Unicode scalar value directly as UTF-8 except: encode quotation mark as `\"`, reverse solidus as `\\`, and each U+0000 through U+001F control as lowercase `\u00xx`. Never escape solidus `/` or non-ASCII scalar values. Emit `true`, `null`, array and object delimiters, commas, and colons as their ASCII JSON literals with no insignificant whitespace; emit `impact` as the single ASCII digit `1` through `5`. SHA-256 those exact bytes and encode the digest as lowercase hexadecimal.

Before every calculation or verification, set both `plan_hash` fields shown above to `PENDING`. Hash the normalized JSON object, never the persisted digest or a ledger or tracker copy that carries it. Retain `reviewed_draft_digest`: it identifies the independently reviewed symbolic draft and is not the final plan hash. After calculation, save the resulting digest in the Plan manifest, its Final binding, and every tracker pointer. Every execution consent binds that exact saved digest; every later verification rebuilds the same input with both final-hash fields reset to `PENDING`.

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
- Any advance execution authorization is explicit in that reply or a later reply, names automatic execution after plan verification, and has an exact source and time; a bare confirmation is not authorization.
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
- Every final binding record carries the reviewed draft digest, matching review PASS, saved-state equality PASS, current hash, saved routes, mandates, and runtime rubric.
- Before automatic launch under advance authority, the launch-binding record proves no unresolved Question or material delta from the confirmed brief and binds that authority to the current final hash; otherwise the planner asks for normal final-hash consent.
- The manifest carries the bounded repair envelope and follow-up policy; no planned task relies on dynamic repair to fill a known prerequisite.
- Tracker and Blueprint contain logic only.
- Nothing exists merely to serve process.
