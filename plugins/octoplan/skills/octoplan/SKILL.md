---
name: octoplan
description: Use when the user says "Octoplan <work stream>" or "Octoplan checkpoint <work stream>", when an Octopad work stream needs turning into an execution-ready plan, or when a task marked "Octoplan flesh-out required" needs speccing. Planning only — an Octoplan session never implements. Requires a connected Octopad MCP server.
---
Version: 1.2.0

# Octoplan — work-stream planning protocol for Octopad

Octoplan turns an Octopad work stream into a plan of detailed, ordered, self-contained tasks that fresh AI sessions then execute one at a time. It works for any kind of stream — engineering, marketing, content, operations, legal — because Octopad holds the plan, the state, and the order: an executor session briefs itself from Octopad and needs nothing else.

**Everything a later session needs lives in the task itself.** The session that picks a task up has no memory of this one and does not load this skill, so the planner writes its hand-off instruction into the task description, verbatim, using the patterns below. The planner plans, never implements.

## What Octoplan needs

- The **Octopad MCP server** connected, with access to the workspace holding the stream. Orient with `start_session`, then `build_context` (mode `work_stream` or `task`). Note the organisation and workspace this session authenticated into — continuation prompts name both.
- Octopad vocabulary used below: every work stream has a **tracker** (its living overview page); **Decisions** and **Questions** are knowledge items of those types, attached to the stream; **goals** sit above streams; **pages** hold documents.
- Octopad enforces a task-creation contract — respect it exactly or the create is rejected:
  - Every task description must contain **Why** and **What** sections; every top-level task also needs **Done when**. Accepted header forms: `**Why**` (bold, with or without a colon), `## Why`, or `Why:` at line start. Synonyms (Context, Goal, Build, Scope) are rejected.
  - Every task needs the `impact` (1–5) and `impact_rationale` creation parameters, subtasks included. These are tool-call parameters, not description text. Anchors: 5 = the stream fails without it; 3 = clearly advances the stream; 1 = nice-to-have.
  - Subtasks (`parent_task_id` on create) need only Why + What.
  - Dependency edges (`depends_on_task_id` on create, or the `link_dependency` action) require a one-line rationale when added.

## Non-negotiables

- **Planning only.** No code, no content deliverables, no "quick fix while we're here". The session's outputs are tasks, Decisions, Questions, design pages, and plan-hygiene edits to existing items — nothing else.
- **Verified facts only.** Every file path, symbol, command, source claim, or task status cited in a spec must come from THIS session's tool output (reads, searches, Octopad calls), never from memory or plausibility. Can't verify it right now → ask the user or log a Question; never fill a spec slot with a guess.
- **Every gate runs on every plan.** A small stream is not a reason to skip the self-check (step 6) or the adversarial review (step 7).

## When NOT to use

A single small task: just write a good task description.

## Keep the plan simple

Spec the simplest plan that fully delivers the definition of success — least new process, fewest moving parts. Reuse the stream's existing conventions before inventing new ones, and when two structures both work, pick the one an executor can follow with less ceremony. No speculative scaffolding: no extra tiers, bespoke status markers, or synchronization steps the stream doesn't actually need yet. Apply this bar to the plan itself, not only to what it produces — an over-engineered process costs as much as over-engineered code.

Simplicity means cutting invented process, never correct decomposition. Decompose to one real job per task, and size each task to **one focused executor session**: a single coherent job that leaves the work verifiable on its own and touches only what the change genuinely requires. If a job won't fit one session or would leave a broken intermediate state, split it at a natural seam (schema → backend → frontend, as separate ordered tasks), never mid-change — but do NOT split an atomic change (a rename and its call sites) just to lower a file count. Concrete too-big signals — any one means split: the How describes more than one coherent job; Verify lists more than ~5 independent checks (the final validation task is the exception — it stays ONE task with one subtask per check); the change would sprawl wide without being one atomic edit. Two different splitting tools: separate ordered tasks split work BETWEEN sessions; **Octopad subtasks** structure work WITHIN one session. Whenever a task has 3+ distinct internal steps a memory-less executor could lose track of, create one subtask per step so the executor works a visible checklist instead of a wall of prose. Don't over-split either: a task below a meaningful verifiable state is noise, and so is a subtask below one concrete step.

## Stream-type lenses (steps 1 & 5)

One Octoplan for every domain — but the interview questions and the How/Verify slots take the stream's own best practices. A lens is a checklist of questions, not extra process: if a lens question has an obvious answer in the stream's source of truth, verify it there instead of asking the user.

- **Engineering.** Settle before planning: what merged-and-deployed behavior defines success; how it will be proven (which test suite, what new test); whether the data model changes (a migration is always a recorded Decision, and never runs in parallel with anything); what permission, security, or auth surface it touches (always recommend a review); how it rolls back if it breaks.
- **Content / marketing.** Ground in the governing canon (positioning, voice, channel history); settle the measurable outcome, the distribution channel, and who approves before publish. Publishing is outward-facing — the approval gate is a wired task in the plan, never an afterthought.
- **Ops / finance / legal.** Settle the source documents, the hard deadlines (dates written as absolutes, never "next month"), and the audit trail — every figure traceable to a named document.

## Steps, in order

1. **Review or discover.** Read everything that exists: the stream's tracker, every task, linked design pages, prior Decisions. A loose plan exists → review and improve it. The stream is thin or empty → interview the user first (purpose, scope, constraints, who it serves — one theme at a time), letting the stream-type lens shape the questions, then draft a design page and propose the task breakdown. Also settle two practical facts you'll need later: which AI models and reasoning-depth settings the team's environment offers (for Exec recommendations), and who on the team owns each human gate.
2. **Lock decisions.** Surface every open call and present each in this shape before locking: **Deciding** (what and why it matters, in real-world terms) → **Options** (each with what you gain and what you give up) → **Recommendation** (your pick and why) → **Reversibility** (how hard to undo). Confirm ONE decision at a time — a "go ahead" locks only the item just confirmed, never neighboring proposals. Record each as a Decision on the stream.
3. **Plan hygiene + execution order.** Close done-but-open tasks; align the stream's definition of success with real scope; log open Questions. Then wire the order so "what's next" is never ambiguous:
   - **Dependencies are the machine-readable order.** Wire a dependency edge (with its one-line rationale) for every real "B needs A" relation — edges work across work streams in the same workspace. Octopad's next-task resolution skips tasks whose dependencies aren't done.
   - **Title prefix is the human-readable order.** Name every executable task `#N - <title>`, N being its rank among the stream's executable tasks. The rank shows in every task list and in the continuation prompt.
   - **A Next line closes every executable task's description** — the hand-off instruction the finishing session follows. Write it using the exact patterns in the Continuation section; it is the only way the chain moves.
   - Add the **final validation task** — whatever proves the stream's definition of success (an end-to-end test for a build stream, a publish-readiness review for a content stream), wired after the delivery tasks, with one subtask per check. Producing a manual checklist for the user is part of its Done when.
   - **Human-only tasks** (approvals, access grants) get no `#N` prefix, no Exec/Review lines, and no Next line — dependencies gate them, and the preceding executable task's Next line carries the resume instruction (see Continuation). They still need Why, What, Done when, and the impact parameters like any task, and are assigned to the team member who owns the action.
4. **Ground in reality + runnability.** Engineering streams: map the repository's real conventions with read-only exploration; anything written into a spec must be confirmed by a direct read. Business/content streams: ground in the governing documents instead — read them IN FULL plus the live external surfaces; never spec from memory. If the planner itself lacks access to a governing surface, log a Question and mark the affected tasks as flesh-out placeholders rather than speccing blind. All streams: confirm every Verify step is executable with access that exists today — missing access (a database, analytics, posting rights) becomes its own task wired before its dependents. A check that can only mature later (a metric measured weeks after delivery) is not a runnability failure: name the event or date it waits on in a `**Preconditions:**` line. Any spec that assumes prior work is LIVE (deployed / published), not merely written, also gets a `**Preconditions:**` line naming what must be live first.
5. **Spec into tasks — fill the template.** Write every executable task with the template below, every required slot filled before saving. Implementation-grade detail goes INTO the description — exact paths or source documents, patterns to copy, edge cases, and the exact verify steps (precise commands or concrete checks, not "run the tests" — the executor has no memory of any chat and can't infer them). The How must call for the simplest implementation that fully solves the job — reuse existing functions, templates, and patterns before adding new ones; simple, complete, and matching the surrounding conventions beats clever. A task that can't be fully specced yet (it depends on another task's output) is a **placeholder**: it keeps its `#N - ` title AND the required Why / What / Done when headers and impact parameters (or the create is rejected), but each body slot holds one line only, with this note as the What: "⚠️ Octoplan flesh-out required: run an Octoplan pass before building, because <what is missing>" — an executor reading it flags the user instead of building on a placeholder.
6. **Self-check gate.** After all tasks are written, re-open every one FROM OCTOPAD (re-read what was actually saved, not what you remember writing) and walk it against the self-check list below. Fix failures on the spot, then re-check the fixed task.
7. **Adversarial review — never skip.** 2+ fresh-eyes agents attack the plan against the real source of truth — the repository for engineering, the governing documents and live surfaces for content — worst problems first. Give each reviewer the verbatim saved task text (fetched from Octopad, never your summary) plus access to that source, and have it verify claims with its own reads. Assign each agent one lens: (a) **design soundness** — is this the right plan; wrong decomposition, missing decision, simpler structure available; (b) **executability** — can a memory-less session complete each task from its spec alone; paths real, steps runnable, dependencies and Next lines correct. For a stream of 8+ tasks or anything touching data migrations, permissions or auth, or money, add a third lens: (c) **risk** — what breaks, what loses data, what needs a human sign-off the plan doesn't flag. A finding may be dismissed only by verifying the contrary in this session's tool output — otherwise fix the specs or log a Question.
8. **Write the plan's logic into the stream tracker.** Every work stream has a tracker page carrying the sections the planner owns (Scope, Rationale, Definition of Success) alongside the system-generated Progress Report and Activity Log. Update it so the ordering makes sense to anyone opening the stream later: **why the tasks run in this order**, which branches are parallel and why they are safe to split, where a human gate sits, and what ends the stream. Keep it short and keep it logic-only — no task statuses, no copies of task content, nothing the task graph already holds, or it goes stale the first time work moves. This is the same job the Blueprint page does for a multi-stream effort, at single-stream scale. Never hand-write the Progress Report or the Activity Log; the system owns those.
9. **Hand off.** Rename the work stream so its name ends with ` (octoplanned)` — skip if it already does — so anyone scanning the workspace sees which streams have been through a full Octoplan pass. The suffix is a marker for humans reading the workspace, not part of the stream's identity: continuation prompts always use the plain name. Then end with a short wrap-up (what the plan contains — task count, decisions locked, open questions) and the continuation prompt for the first ready task, in the exact fenced format defined in Continuation. Do NOT restate chain state or the team's standing rules in the handoff: state lives in Octopad, rules live in the team's own instruction files. If you're tempted to add a fact to the handoff, it belongs in an Octopad task, Decision, or knowledge item — put it there.

## Task template

Octopad rejects the create if Why / What / Done when are missing or renamed, or if the impact parameters aren't set. The other slots are Octoplan's conventions — executors read them as plain language, so write them as instructions, not codes.

```
Title: #N - <task title>

**Why:** <why this task exists and what it builds on — enough for a memory-less session>
**What:** <the one job in a sentence, plus scope and boundaries — what's out when ambiguous>
**How:** <exact paths or source documents, patterns or templates to copy, edge cases to cover>
**Verify:** <exact copy-pasteable commands or concrete checks>
**Done when:** <the concrete end state, named in the system of record where the deliverable lives — for code, the merged/deployed state the team's process requires, never just "tests pass"; for content or ops, the approved/published/filed state and where it sits>
**Exec:** <recommended model tier · reasoning depth — see the rubric> — <why>
**Review:** <required | skip> — <why>
**Preconditions:** <what must be LIVE or matured, not just written>
**Next:** <the hand-off instruction — copy the matching pattern from the Continuation section>
```

Creation parameters alongside the description: `impact` (1–5) and `impact_rationale`, plus `parent_task_id` for subtasks and `depends_on_task_id` (+ rationale) for dependencies. The `**Preconditions:**` slot is omitted entirely when not needed — never left as placeholder text. Subtasks carry only Why + What (put the subtask's concrete check or step in its What).

## Exec & Review recommendations

**Exec.** The planner just read the real sources and specced the task, so it knows how hard the task is — record a model recommendation the user applies when launching the executor session. Express it in the model names or tiers the team's environment actually offers (settled in step 1), with the depth-of-reasoning setting if the environment has one. Rubric:

| Task profile | Recommend |
|---|---|
| Mechanical, well-specced copy of an existing pattern or template | mid-tier model, standard depth |
| Standard delivery with a clear pattern to copy — a routine feature, a templated deliverable | mid-tier model, deeper reasoning |
| Hard but well-bounded work — tricky logic or structure, no open design questions | mid-tier model, maximum depth |
| Cross-file or cross-document coordination, data migrations, permissions/security, money, or high-stakes hard-to-reverse deliverables (brand-defining copy, legal text, anything published where wrong is costly) | top-tier model, deeper reasoning |
| Genuinely open design problem where the approach itself is uncertain | top-tier model, maximum depth (rare) |
| Broad read-only audit or "find/verify every X" sweep | a multi-agent sweep mode if the environment offers one — costly, needs the user's opt-in |

Recommend generously — a failed session usually costs more than a stronger model would have. The recommendation is not a lock: the executor escalates if the task turns out harder than specced.

**Review.** `required` whenever a mistake would be costly: real decision-making, security/permissions, a data migration, cross-file logic, anything published or client-facing. `skip` only for genuinely trivial mechanical changes a fresh pass would find nothing in. When required, the executor has a separate fresh agent — no memory of writing the work — attack just the finished change, worst problems first, and fixes confirmed findings before delivering. Default to `required` when unsure.

## Continuation — how the chain moves between sessions

Sessions are chained by a **minimal continuation prompt**: a fenced code block holding two lines of plain text, no links and no formatting.

```
<work stream> #N - <task title>
Octopad · Organisation: <organisation> · Workspace: <workspace>
```

The work and the rank come first because the assistant names the session after the start of what it is given, so that line has to be the readable label. Write the stream's plain name, without the ` (octoplanned)` suffix — it says nothing to the session reading it, and Octopad matches names loosely enough to resolve either way. The second line is the address: workspace names can repeat across organisations, so both are needed to land in the right place with no guessing.

The user pastes the block into a fresh session, which briefs itself entirely from Octopad (`start_session` on the workspace, `build_context` on the task). The prompt is a pointer, never a payload, so it can never go stale. A session learns to emit it from ONE place: the **Next** line of the task it just finished. So the planner writes that line as a verbatim instruction, using these patterns, with the real names filled in and `<block>` standing for the two-line block above built for the named task:

- **Sequential** — successor is one executable task:
  `**Next:** #4 - <title>. When this task is fully done and verified, check in Octopad that #4 is still open and unclaimed and its dependencies are done, then end your reply with a fenced code block containing exactly: <block for #4>. If #4 is not ready, end instead with one line naming what it waits on.`
- **Human gate next** — successor is a human-only task:
  `**Next:** waits on "<human task title>" (owner: <name/role>). When this task is done, end your reply by stating in one line that the chain waits on that action, then give the user this block to paste once it is done: <block for the task after the gate>.`
- **Parallel fan-out** — several independent siblings become ready at once:
  `**Next:** parallel group #2 + #3. When this task is done and both are confirmed ready in Octopad, emit one fenced code block PER sibling (<block for #2>, then <block for #3>) — the user opens one fresh session per block.`
- **Inside a parallel group** — exactly ONE sibling is the **relay** (it carries the chain); the others are **terminal**:
  - Relay: `**Next:** #6 - <title>, after the whole group (#2, #3) is done. Relay: check in Octopad whether every sibling is done. If yes, emit the #6 continuation block. If not, name what is still running and give the user the #6 block to paste once the group is done.`
  - Terminal: `**Next:** none — terminal branch; #3 carries the continuation.` (The finishing session ends with its wrap-up and NO continuation prompt, so the chain never forks.)
- **End of chain:** `**Next:** none — last task of the stream. End with the wrap-up only.`

A Next line that points into another work stream (a multi-stream effort) works the same way: the block simply names that stream, and the organisation and workspace stay as they are.

Parallelize only on true independence: no shared file, symbol, or contract for code; no shared editorial structure, template, or deliverable one sibling shapes for another, for content; never data migrations or shared generated artifacts. Parallel is the exception. Executors work only tasks assigned to them or unassigned — **a task assigned to another person is theirs; the plan assigns tasks accordingly, and an executor finding a foreign assignment warns the user instead of working it.**

## Multi-stream efforts (Blueprint)

When a request is too big for one work stream, plan it as ONE effort across several autonomous streams. No new Octopad object is needed — an effort is a goal + several work streams + one Blueprint page, all in the same workspace (dependency edges cannot cross workspaces):

1. **Cut the work into autonomous packages**, one work stream each. A package stays a top-level task of its own stream — never artificially demoted to a subtask of another stream's task. Link every stream to the same goal. Wire the real dependencies between tasks across streams and note what can run in parallel.
2. **Write one Blueprint page** — deliberately light: the expected outcome, each stream's role, the global order, the parallel branches, the few dependencies that matter, the human validation points, and the effort's end condition. Link it to the tasks it governs so every executor immediately sees where its work sits in the whole. The Blueprint explains the logic; the Octopad dependency graph enforces it — the page carries no statuses and no copies of task content, so it never goes stale.
3. **Plan at effort scale.** Continuation crosses stream boundaries like any other step: a task's Next line may point into another stream — the continuation prompt then names that stream. The effort's final validation task includes one closing subtask: **archive the Blueprint page** once the effort is done.

If one work stream suffices, none of this applies.

## Checkpoints

After every 3–4 closed tasks, or a long execution gap, the user runs "Octoplan checkpoint <stream>": re-validate remaining specs against the current sources, refresh `#N` prefixes and Next lines if tasks were added, surface any stranded in-progress task. Ten minutes, not a full Octoplan. Any task a checkpoint adds or materially rewrites re-runs the per-task self-check; a checkpoint that adds three or more tasks is a full Octoplan, not a checkpoint. Recurring streams (a monthly issue, a quarterly report) are normally planned one cycle at a time — re-running Octoplan per cycle is the intended rhythm, not a failure.

## Self-check list (step 6)

Human-only tasks: check they carry no `#N` prefix, no Exec/Review lines, no Next line — but do carry Why/What/Done when, the impact parameters, and an owner. Placeholders: check the title prefix, the required headers, and the flesh-out note. Subtasks: check only Why + What.

Per executable task:
- Title carries `#N - `; the rank is unambiguous among the stream's executable tasks.
- Why / What / Done when present under those literal names; impact parameters set.
- Exec and Review lines present, each with its why, matching the rubric.
- A task with 3+ distinct internal steps carries one subtask per step.
- How names the specific files or source documents to touch and a concrete existing example to copy — a memory-less session could open the right things from this text alone. "Follow the existing pattern" fails this row.
- Every path, symbol, command, and source claim in the spec appeared in this session's tool output.
- Verify steps are exact; access exists today; anything that can only mature later is named in `**Preconditions:**`.
- One job; fits one executor session; independently verifiable.
- Anything assumed LIVE is named in `**Preconditions:**`.
- The Next line uses one of the Continuation patterns verbatim (with real names filled in) and matches the dependency graph; exactly one relay per parallel group; terminals really are terminal.
- No guesses: every gap is a Question, a Decision, or a flesh-out placeholder.

Per plan:
- Definition of success matches real scope; final validation task wired after the delivery tasks.
- Every point where the plan chose between real alternatives is a recorded Decision, not an unstated default.
- Parallel groups only on truly independent siblings.
- Dependencies wired for every real "B needs A", including across streams.
- The stream tracker explains why the tasks run in this order, names the parallel branches and the human gates, and carries no task statuses or copied task content.
- Multi-stream efforts: Blueprint page exists, is light, is linked, and its archiving is a closing subtask.
- Nothing exists to serve process rather than the outcome.

## Common planning mistakes

| Mistake | Consequence |
|---|---|
| Skipping the runnability check | A late task (e.g. a check needing access nobody has) turns out impossible after sunk cost |
| Speccing from memory instead of the real sources | Specs cite files or documents that have since changed |
| Speculative scaffolding — tiers, options, or process the stream doesn't need yet | Executors pay a ceremony cost for scale that never arrives |
| A handoff that dumps chain state instead of pointing to it | A bloated, self-staling prompt duplicating Octopad — the continuation prompt is a pointer |
| A build task that sprawls past one session | The executor can't finish or verify it cleanly — split at natural seams, never mid-change |
| A titanic validation task — a dozen checks crammed into one description | The executor drowns mid-task and progress is invisible — one subtask per check |
| Choosing the Exec recommendation by gut instead of the rubric | Over- or under-powered sessions: maximum depth overthinks routine work, standard depth under-serves a migration |
| A Next line that names the successor but not the emit instruction | The executor doesn't know this skill — the chain dies after one task; copy the Continuation patterns verbatim |
| Two relays in one parallel group, or none | The chain forks, or dies silently — exactly one sibling carries the continuation |
| A placeholder without the required headers | Octopad rejects the create — placeholders keep Why/What/Done when around the flesh-out note |
| A plan whose ordering logic lives nowhere a human reads | The dependency graph enforces an order nobody can explain six weeks later — put the reasoning in the stream tracker |
| Copying task statuses or task content into the tracker or the Blueprint | Both go stale the first time work moves — they carry logic, the task graph carries state |
| Renaming the template's section names | Octopad literally matches Why / What / Done when at creation and rejects the write |
