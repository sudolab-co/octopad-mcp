---
name: octoplan-autopilot
description: Use when the user says "Octoplan Autopilot" followed by a work-stream name, when the user asks for a work stream to be planned and then delivered under supervision or autonomously, when an Octopad work stream needs turning into an execution-ready plan, when a task marked "Octoplan flesh-out required" needs speccing, or when a session executing a planned stream discovers something that adds a task or changes the order — it invokes this skill to rebalance the plan. Planning is implementation-free until the user's explicit delivery go; after that go the stream is supervised, by that same session or by a fresh supervisor session it hands to. When installed it supersedes the planning-only Octoplan skill, so use it for a plain "Octoplan" request too. Requires a connected Octopad MCP server.
---
Version: 0.4.0

# Octoplan Autopilot — work-stream planning and supervised delivery for Octopad

Octoplan Autopilot turns an Octopad work stream into a plan of detailed, ordered, self-contained tasks, and then — once the user says go — supervises their delivery, either from the planning session or from a fresh supervisor session it hands to. It works for any kind of stream — engineering, marketing, content, operations, legal — because Octopad holds the plan, the state, and the order: any session working the stream briefs itself from Octopad and needs nothing else.

**Everything a later session needs lives in the task itself.** A session that picks a task up has no memory of this one and normally does not load this skill, so the planner writes its hand-off instruction into the task description, verbatim, using the patterns below. That holds for the supervised path too: it is what lets a fresh session take the stream over if this one dies. The one exception is replanning (see Replanning): a session whose discovery changes the plan loads this skill to rebalance it.

## Resuming a stream — check this first

Before planning anything, look at the stream you were invoked on. If ALL THREE hold — its name already ends with ` (octoplanned)`, it carries the delivery contract's Decisions, and one of them is a Decision whose own subject is the delivery go, which the user has not withdrawn — then this is a resume, not a new plan. A go mentioned in passing inside another Decision does not satisfy this. Do not re-plan, do not re-run the brief, do not re-ask for the dials, and do not re-ask for the delivery go: the recorded go is the user's permission, already given. Load `references/supervision.md`, re-read the contract Decisions, the open tasks and each one's latest comment, and rejoin the delivery loop where it stopped.

Anything less than all three is a planning pass: the steps below, in order. A stream that was planned but never given a delivery go simply reaches the hand-off again and waits there.

## What Octoplan needs

- The **Octopad MCP server** connected, with access to the workspace holding the stream. Orient with `start_session`, then `build_context` (mode `work_stream` or `task`). Note the organisation and workspace this session authenticated into — continuation prompts name both.
- Octopad vocabulary used below: every work stream has a **tracker** (its living overview page); **Decisions** and **Questions** are knowledge items of those types, attached to the stream; **goals** sit above streams; **pages** hold documents.
- Octopad enforces a task-creation contract — respect it exactly or the create is rejected:
  - Every task description must contain **Why** and **What** sections; every top-level task also needs **Done when**. Accepted header forms: `**Why**` (bold, with or without a colon), `## Why`, or `Why:` at line start. Synonyms (Context, Goal, Build, Scope) are rejected.
  - Every task needs the `impact` (1–5) and `impact_rationale` creation parameters, subtasks included. These are tool-call parameters, not description text. Anchors: 5 = the stream fails without it; 3 = clearly advances the stream; 1 = nice-to-have.
  - Subtasks (`parent_task_id` on create) need only Why + What.
  - Dependency edges (`depends_on_task_id` on create, or the `link_dependency` action) require a one-line rationale when added.

## Non-negotiables

- **Implementation-free until the delivery go.** While planning, the session's outputs are tasks, Decisions, Questions, design pages, and plan-hygiene edits to existing items — no code, no content deliverables, no "quick fix while we're here". That holds until the user gives an explicit delivery go on the finished plan. After that go this session stops planning: it either supervises delivery by the rules in `references/supervision.md`, or hands supervision to a fresh session (step 11). Neither of them writes a deliverable itself.
- **Verified facts only.** Every file path, symbol, command, source claim, or task status cited in a spec must come from THIS session's tool output (reads, searches, Octopad calls), never from memory or plausibility. Can't verify it right now → ask the user or log a Question; never fill a spec slot with a guess.
- **Every gate runs on every full planning pass.** A small stream is not a reason to skip the scoping brief (step 2), the delivery contract (step 3), the self-check (step 8), or the adversarial review (step 9). A mid-execution rebalance runs only the reduced set named in Replanning.

## When NOT to use

A single small task: just write a good task description.

## Keep the plan simple

Spec the simplest plan that fully delivers the definition of success — least new process, fewest moving parts. Reuse the stream's existing conventions before inventing new ones, and when two structures both work, pick the one an executor can follow with less ceremony. No speculative scaffolding: no extra tiers, bespoke status markers, or synchronization steps the stream doesn't actually need yet. Apply this bar to the plan itself, not only to what it produces — an over-engineered process costs as much as over-engineered code.

Simplicity means cutting invented process, never correct decomposition. Decompose to one real job per task, and size each task to **one focused executor session**: a single coherent job that leaves the work verifiable on its own and touches only what the change genuinely requires. If a job won't fit one session or would leave a broken intermediate state, split it at a natural seam (schema → backend → frontend, as separate ordered tasks), never mid-change — but do NOT split an atomic change (a rename and its call sites) just to lower a file count. Concrete too-big signals — any one means split: the How describes more than one coherent job; Verify lists more than ~5 independent checks (the final validation task is the exception — it stays ONE task with one subtask per check); the change would sprawl wide without being one atomic edit. Two different splitting tools: separate ordered tasks split work BETWEEN sessions; **Octopad subtasks** structure work WITHIN one session. Whenever a task has 3+ distinct internal steps a memory-less executor could lose track of, create one subtask per step so the executor works a visible checklist instead of a wall of prose. Don't over-split either: a task below a meaningful verifiable state is noise, and so is a subtask below one concrete step.

## Stream-type lenses (steps 1, 2 & 7)

One Octoplan for every domain — but the interview questions, the brief's assumption hunt, and the How/Verify slots take the stream's own best practices. A lens is a checklist of questions, not extra process: if a lens question has an obvious answer in the stream's source of truth, verify it there instead of asking the user.

- **Engineering.** Settle before planning: what merged-and-deployed behavior defines success; how it will be proven (which test suite, what new test); whether the data model changes (a migration is always a recorded Decision, and never runs in parallel with anything); what permission, security, or auth surface it touches (always recommend a review); how it rolls back if it breaks.
- **Content / marketing.** Ground in the governing canon (positioning, voice, channel history); settle the measurable outcome, the distribution channel, and who approves before publish. Publishing is outward-facing — the approval gate is a wired task in the plan, never an afterthought.
- **Ops / finance / legal.** Settle the source documents, the hard deadlines (dates written as absolutes, never "next month"), and the audit trail — every figure traceable to a named document.

## Steps, in order

1. **Review or discover.** Read everything that exists: the stream's tracker, every task, linked design pages, prior Decisions. A loose plan exists → review and improve it. The stream is thin or empty → interview the user first (purpose, scope, constraints, who it serves — one theme at a time), letting the stream-type lens shape the questions; the answers feed the scoping brief (step 2), and the design page and proposed task breakdown come only after the brief is confirmed. Also settle two practical facts you'll need later: which AI models and reasoning-depth settings the team's environment offers (for Exec recommendations), and who on the team owns each human gate.
2. **Scoping brief — reflect back, then wait.** Before locking any decision, drafting any design page, or writing any task, merge what the user said with what the sources hold and hand it back as ONE short brief (aim for half a page) in the chat — a stream that already looks fully specced is where an unchecked misreading survives longest. The brief is the ENTIRE message: no decision proposals, no draft breakdown riding along — end the turn on it. Five parts, each present every time, with the stream-type lens shaping what belongs in each:
   - **Understanding** — the stream's purpose and deliverable, restated in the planner's own words.
   - **In / out of scope** — both lists explicit. An empty "out" list is a red flag: name at least the nearest adjacent thing the stream does NOT deliver.
   - **Success** — the definition of success the planner intends to plan against.
   - **Assumptions** — every point the planner settled by inference instead of a source or the user's words, one line each, with where the inference came from. An empty list must show its work: name where each usual hiding place (scope edges, audience, ordering, quality bar) was settled — a source read this session, or the user's words.
   - **Open questions** — what the planner cannot settle alone.
   Then STOP. Confirmation is a reply the user sends AFTER seeing the brief — no launch prompt, prior chat, or tracker note counts, however complete it looks. The reply confirms the brief as corrected: a correction replaces the assumption, and anything the reply leaves unanswered never defaults to the planner's assumption — re-ask once, then whatever stays open becomes a logged Question with its affected tasks as flesh-out placeholders. Do not start step 3 until that reply has arrived. The brief itself is a chat message, not an Octopad artifact — its confirmed content flows into Decisions, Questions, and the tracker, which are the durable records. A multi-stream effort writes ONE effort-level brief (see Multi-stream efforts).
3. **Delivery contract — one message, then wait.** The brief settled WHAT the stream delivers; this settles HOW it will be delivered and how much the session may do alone. First read the target the work lands in — the repository, site, or workspace — and its own rule files: a `CLAUDE.md`, an `AGENTS.md`, or whatever house rules the team keeps there. Read them at this moment, not from memory. **Whatever those rules lock is a floor this session cannot lower.** Then present ONE message and stop:
   - **Human gates forecast** — every point the plan will have to hand to a person: data-schema or migration work, permission, auth, and security surfaces, publishing, deploying, spend, and anything the target's own rules route to a human. Name each gate and who owns it.
   - **Reviewer routing** — which named person clears which class of task, and which classes are cleared by machine checks alone.
   - **Stacking** — whether dependent changes stack on each other's branches as they go, or each waits for the previous one to land.
   - **Two dials, both set by the user.** **Merge autonomy:** the user validates each change before it lands, or this session has a standing mandate to land it once the gates pass. **Challenge autonomy:** this session consults the user on every problem it meets, or resolves what it safely can alone and reports afterwards.
   Two things the dials never move. The rule files' floor wins: the dials only govern what those rules leave open. And **one-way doors always stop for the named human, whatever the dials say** — data schema and migrations, permissions and auth, payments, deleting data, anything that cannot be undone. Verification does not move either: a dial removes a human wait, never a check.
   A user who only wants a plan need not set the dials: the contract may close as "plan only — dials deferred until a delivery go", with the gates, routing and stacking still recorded. The dials are then settled at the hand-off, if and when the go comes.
   Record the confirmed contract as Decisions on the stream — the two dials (or that they are deferred), the reviewer routing, the stacking choice, and the gate map. **The contract lives in Octopad, never in this chat:** a worker session, or any session that resumes this stream later, reads its mandate from those Decisions and from nowhere else. Because this forecast is made before the tasks are specced, re-confirm the gate map as a short delta at hand-off (step 11), before any delivery go. And if delivery later meets work outside the classes the contract forecast, the contract expires for that item: stop, tell the user what turned up, and re-confirm before continuing it.
4. **Lock decisions.** Surface every open call and present each in this shape before locking: **Deciding** (what and why it matters, in real-world terms) → **Options** (each with what you gain and what you give up) → **Recommendation** (your pick and why) → **Reversibility** (how hard to undo). Confirm ONE decision at a time — a "go ahead" locks only the item just confirmed, never neighboring proposals. A call the user already settled in the brief reply is recorded as a Decision directly, not re-presented. Record each as a Decision on the stream.
5. **Plan hygiene + execution order.** Close done-but-open tasks; align the stream's definition of success with real scope; log open Questions. Then wire the order so "what's next" is never ambiguous:
   - **Dependencies are the machine-readable order.** Wire a dependency edge (with its one-line rationale) for every real "B needs A" relation — edges work across work streams in the same workspace. Octopad's next-task resolution skips tasks whose dependencies aren't done.
   - **Title prefix is the human-readable order.** Name every executable task `#N - <title>`, N being its rank among the stream's executable tasks. The rank shows in every task list and in the continuation prompt.
   - **A Next line closes every executable task's description** — the hand-off instruction the finishing session follows. Write it using the exact patterns in the Continuation section; it is the only way the chain moves.
   - Add the **final validation task** — whatever proves the stream's definition of success (an end-to-end test for a build stream, a publish-readiness review for a content stream), wired after the delivery tasks, with one subtask per check. Producing a manual checklist for the user is part of its Done when.
   - **Add a landing task wherever the finish line is out of reach.** Where the target's rules or the contract's merge dial stop this session short of the finished state — a change it may not merge, a draft it may not publish — the step that finishes the job becomes ONE human-only landing task, owned by the named person, wired last: it **depends on** the final validation task, which depends on the delivery tasks. Each delivery task's Done when is then the state it can actually reach — open, checks green, handed off — and the stream ends on the landing task. Skip this and the board reads delivered while nothing has shipped, with the step that decides whether it did nowhere on it.
   - **One owner per piece of user-facing text.** Where the plan holds a task scoped to write or rewrite wording a user will read, no earlier task may invent text inside that scope: it either writes the final wording against a standard locked as a Decision, or leaves it blank for the owning task. Two tasks writing the same sentence is rework the planner authored, and it costs twice again in every translation.
   - **Human-only tasks** (approvals, access grants, landing the work) get no `#N` prefix, no Exec/Review lines, and no Next line — dependencies gate them, and the preceding executable task's Next line carries the resume instruction (see Continuation). They still need Why, What, Done when, and the impact parameters like any task, and are assigned to the team member who owns the action.
6. **Ground in reality + runnability.** Engineering streams: map the repository's real conventions with read-only exploration; anything written into a spec must be confirmed by a direct read. Business/content streams: ground in the governing documents instead — read them IN FULL plus the live external surfaces; never spec from memory. If the planner itself lacks access to a governing surface, log a Question and mark the affected tasks as flesh-out placeholders rather than speccing blind. All streams: confirm every Verify step is executable with access that exists today. Three triggers say a step is not runnable as written: it needs a login, it needs a seat on a third-party product, or it needs a browser the executor cannot drive. Then split by remedy: access the team can simply grant becomes its own task wired before its dependents; access only a person can exercise becomes a human-only task with a named owner, and no Verify line at all. Settle in step 1 what the executor can and cannot drive, or the third trigger is unanswerable. A check that can only mature later (a metric measured weeks after delivery) is not a runnability failure: name the event or date it waits on in a `**Preconditions:**` line. Any spec that assumes prior work is LIVE (deployed / published), not merely written, also gets a `**Preconditions:**` line naming what must be live first.
7. **Spec into tasks — fill the template.** Write every executable task with the template below, every required slot filled before saving. Implementation-grade detail goes INTO the description — exact paths or source documents, the outcome and the constraint the work must satisfy, edge cases, and the exact verify steps (precise commands or concrete checks, not "run the tests" — the executor has no memory of any chat and can't infer them). The How must call for the simplest implementation that fully solves the job — reuse existing functions, templates, and patterns before adding new ones; simple, complete, and matching the surrounding conventions beats clever. State the outcome and the constraint; dictate a technique only where a real trap needs naming, and then say why. Name an existing thing as the precedent to copy only where this session checked that the precedent carries — an element's look, a mechanism's behaviour, a claim's truth — because a precedent named without that check hands the worker a defect nobody measured. A task that can't be fully specced yet (it depends on another task's output) is a **placeholder**: it keeps its `#N - ` title AND the required Why / What / Done when headers and impact parameters (or the create is rejected), but each body slot holds one line only, with this note as the What: "⚠️ Octoplan flesh-out required: run an Octoplan pass before building, because <what is missing>" — an executor reading it flags the user instead of building on a placeholder.
8. **Self-check gate.** After all tasks are written, re-open every one FROM OCTOPAD (re-read what was actually saved, not what you remember writing) and walk it against the self-check list below. Fix failures on the spot, then re-check the fixed task.
9. **Adversarial review — never skip.** 2+ fresh-eyes agents attack the plan against the real source of truth — the repository for engineering, the governing documents and live surfaces for content — worst problems first. Give each reviewer the verbatim saved task text (fetched from Octopad, never your summary) plus access to that source, and have it verify claims with its own reads. Assign each agent one lens: (a) **design soundness** — is this the right plan; wrong decomposition, missing decision, simpler structure available, and does every spec match the confirmed scoping brief, corrections included; (b) **executability** — can a memory-less session complete each task from its spec alone; paths real, steps runnable, dependencies and Next lines correct. For a stream of 8+ tasks or anything touching data migrations, permissions or auth, or money, add a third lens: (c) **risk** — what breaks, what loses data, what needs a human sign-off the plan doesn't flag. A finding may be dismissed only by verifying the contrary in this session's tool output — otherwise fix the specs or log a Question.
10. **Write the plan's logic into the stream tracker.** Every work stream has a tracker page carrying the sections the planner owns (Scope, Rationale, Definition of Success) alongside the system-generated Progress Report and Activity Log. Update it so the ordering makes sense to anyone opening the stream later: **why the tasks run in this order**, which branches are parallel and why they are safe to split, where a human gate sits, and what ends the stream. Keep it short and keep it logic-only — no task statuses, no copies of task content, nothing the task graph already holds, or it goes stale the first time work moves. This is the same job the Blueprint page does for a multi-stream effort, at single-stream scale. Never hand-write the Progress Report or the Activity Log; the system owns those.
11. **Hand off.** Rename the work stream so its name ends with ` (octoplanned)` — skip if it already does — so anyone scanning the workspace sees which streams have been through a full Octoplan pass. The suffix is a marker for humans reading the workspace, not part of the stream's identity: continuation prompts always use the plain name. Then end with a short wrap-up (what the plan contains — task count, decisions locked, open questions) and the continuation prompt for the first ready task, in the exact fenced format defined in Continuation. Do NOT restate chain state or the team's standing rules in the handoff: state lives in Octopad, rules live in the team's own instruction files. If you're tempted to add a fact to the handoff, it belongs in an Octopad task, Decision, or knowledge item — put it there.
    Two things ride with that wrap-up. First, **the contract delta**: the forecast (step 3) was made before the tasks existed, so name in a few lines every human gate the specced plan actually carries — which the forecast missed, which no longer apply — and every class of task that did not exist when the contract was agreed. Let the user correct it, and re-confirm the dials only if new classes turned up (or if they were deferred). Update the contract Decisions with whatever they settle. Second, **the delivery offer**: ask who should now supervise delivery under that contract, this session or a fresh one. Judge your own remaining context before you offer. Supervising is cheap per task, but its verification gate is not: reading each change and each reviewer's findings, task after task, is what spends the budget. Recommend a fresh supervisor session whenever the planning pass was heavy. Concrete signals: an adversarial review that came back with substantial findings, a replan, a target that changed under you mid-session, a long exploration phase, or any pass after which you cannot honestly say you have the budget left to verify every task properly. When in doubt, hand off: handing off costs the user one paste, while running out stalls the stream mid-flight, and by then summarising has already dulled the judgement the session was kept for. Supervising from here suits a light pass on a short plan.
    Either way, on the user's explicit go, first record the go itself as a Decision on the stream. That record is what lets a later session know it may resume, and it is what makes handing off safe: the fresh supervisor reads the go as permission already given and never asks for it again. Then either load `references/supervision.md` and follow it, or end with the supervisor handoff block (see Continuation). Without a go, nothing else happens here: the plan sits in Octopad and the continuation prompt is how it moves.

## Task template

Octopad rejects the create if Why / What / Done when are missing or renamed, or if the impact parameters aren't set. The other slots are Octoplan's conventions — executors read them as plain language, so write them as instructions, not codes.

```
Title: #N - <task title>

**Why:** <why this task exists and what it builds on — enough for a memory-less session>
**What:** <the one job in a sentence, plus scope and boundaries — what's out when ambiguous>
**How:** <exact paths or source documents, the outcome and constraint, a checked precedent where one carries, edge cases to cover>
**Verify:** <exact copy-pasteable commands or concrete checks>
**Done when:** <the concrete end state, named in the system of record where the deliverable lives — for content or ops, the approved/published/filed state and where it sits; for code, the state the target's rules actually let this session reach, never just "tests pass" — see the note under this template>
**Exec:** <recommended model tier · reasoning depth — see the rubric> — <why>
**Review:** <required | skip> — <why>
**Preconditions:** <what must be LIVE or matured, not just written>
**Next:** <the hand-off instruction — copy the matching pattern from the Continuation section>
```

Creation parameters alongside the description: `impact` (1–5) and `impact_rationale`, plus `parent_task_id` for subtasks and `depends_on_task_id` (+ rationale) for dependencies. The `**Preconditions:**` slot is omitted entirely when not needed — never left as placeholder text. Subtasks carry only Why + What (put the subtask's concrete check or step in its What).

A Done when never names a state this session's own rules forbid it reaching: where the finish line is out of reach, the task ends at open-green-handed-off and a human-only landing task carries the rest (step 5).

## Exec & Review recommendations

**Exec.** The planner just read the real sources and specced the task, so it knows how hard the task is — record the model and the reasoning depth to apply when the task is launched. How binding that is depends on who launches it, and the difference is real: **on the manual path both are binding**, because the user opening an executor session sets them themselves; **under supervised delivery the model is binding and the depth is requested rather than enforced**, because the call that launches a worker carries a model and no depth, so the supervisor can only ask for the depth in the worker's prompt and cannot verify it was honoured. That gap is a known one, not a policy: it closes when a team ships one agent definition per rubric lane and the supervisor dispatches by lane. Never substitute the model, and say so rather than quietly swapping when the exact route is unavailable. Use the exact model names and effort settings the team's environment offers (settled in step 1). When the current Claude models are available, use this capability-first rubric; it deliberately values avoiding a failed session over minimizing spend:

| Task profile | Recommend |
|---|---|
| Mechanical, fully specced copy of a verified pattern; reversible and concretely checkable | **Sonnet 5 · xhigh** — the only default Sonnet lane |
| Standard bounded delivery with a clear pattern — a routine feature, analysis, or templated deliverable | **Opus 5 · high** |
| Hard but well-bounded work — tricky logic, hidden invariants, or dense structure | **Opus 5 · xhigh** |
| Cross-file or cross-document coordination, data migrations, permissions/security, money, or high-stakes hard-to-reverse work (brand-defining copy, legal text, anything published where wrong is costly) | **Opus 5 · xhigh**, with Review required |
| Genuinely open design or long-horizon problem where the approach itself is uncertain | **Fable 5 · xhigh**, only after confirming availability and that its mandatory 30-day data retention is acceptable; otherwise **Opus 5 · xhigh** |
| Broad read-only audit or "find/verify every X" sweep | **Opus 5 · xhigh**, plus `/effort ultracode` only with the user's explicit opt-in |

Apply the effort vocabulary precisely:

| Setting | Octoplan policy |
|---|---|
| `low` | Native effort, but do not recommend it for Sonnet 5, Opus 5, or Fable 5 work. |
| `medium` | Native effort, but recommend it only when the user explicitly prioritizes latency or cost; never use it for Sonnet 5. |
| `high` | Default substantive route for Opus 5. It may be used with Fable 5 when the user already chose Fable for a bounded capability-sensitive task. Never use it for Sonnet 5. |
| extra high (`xhigh`) | Minimum Sonnet 5 route and the default for hard, long-running, or consequential work. |
| `max` | Rare. Recommend it only when `xhigh` has proved insufficient or the task is explicitly unconstrained and the extra latency, cost, and risk of overthinking are justified; write that reason in the Exec line. Prefer moving from Sonnet 5 to Opus 5 before maxing Sonnet. |
| `ultra` / `ultracode` | Not a native effort above `max`. The `/effort ultracode` session setting combines `xhigh` with automatic workflow orchestration; the `ultracode` prompt keyword starts one workflow at the session's current effort. Save the actual native effort, name the separate opt-in, and never write `effort: ultra`. |

Every Fable 5 recommendation, at any effort, requires confirmed availability and acceptance of its mandatory 30-day data retention. If either condition fails, use Opus 5 at the best compatible effort for the task.

Sonnet 5 below `xhigh` is outside this rubric. That floor is an Octoplan quality policy, not a claim that lower effort has a universally measured defect rate. Opus 4.6 is a deliberate compatibility or interaction-style lane, never an automatic downgrade: it has no `xhigh`, so use `high` for routine work; use `max` only when the user's live workload or tuned prompts favor 4.6 **and** the rare-`max` rule above is independently satisfied. Opus 4.6 and Opus 5 have the same list price; the older tokenizer can use fewer tokens for equivalent text, but that alone does not prove lower cost per successful task.

The native effort ladder and model defaults come from Anthropic's [effort guide](https://platform.claude.com/docs/en/build-with-claude/effort) and [model-selection guide](https://platform.claude.com/docs/en/about-claude/models/choosing-a-model). The Opus 4.6 compatibility facts come from the [migration guide](https://platform.claude.com/docs/en/about-claude/models/migration-guide). Claude Code's separate orchestration modes are defined in its [workflow guide](https://code.claude.com/docs/en/workflows).

Recommend generously. The saved route is a floor: the executor may escalate when live work proves harder than specced, never weaken it, and it must not silently drop the Sonnet floor or substitute a model that cannot provide the saved effort. If the exact route is unavailable or its data-retention policy is unacceptable, say so and recommend the best compatible fallback.

**Review.** `required` whenever a mistake would be costly: real decision-making, security/permissions, a data migration, cross-file logic, anything published or client-facing. `skip` only for genuinely trivial mechanical changes a fresh pass would find nothing in. When required, a separate fresh agent — no memory of writing the work — attacks just the finished change, worst problems first, and confirmed findings are fixed before delivering. Under manual execution the executor session runs that review itself; under supervised delivery the supervisor spawns the reviewer and the worker never does. Default to `required` when unsure. **The reviewer gets a route too, and it is never cheaper than the work it attacks:** the same model, asked for extra high depth. The review is the gate that catches what the work missed, so under-powering it removes the last check the plan has — and the same request-not-enforce limit applies to a spawned reviewer's depth as to a worker's.

## Continuation — how the chain moves between sessions

Sessions are chained by a **minimal continuation prompt**: a fenced code block holding two lines of plain text, no links and no formatting.

```
<work stream> #N - <task title>
Octopad · Organisation: <organisation> · Workspace: <workspace>
```

The work and the rank come first because the assistant names the session after the start of what it is given, so that line has to be the readable label. Write the stream's plain name, without the ` (octoplanned)` suffix — it says nothing to the session reading it, and Octopad matches names loosely enough to resolve either way. The second line is the address: workspace names can repeat across organisations, so both are needed to land in the right place with no guessing.

Under supervised delivery these blocks are the **fallback path, not the normal one**: the supervisor sequences the work itself and its workers emit no continuation block (see `references/supervision.md`). They still get written on every task. If the supervising session dies, the first recovery move is to invoke this skill on the stream again — it resumes supervision from Octopad (see Resuming a stream), and the supervisor handoff block below is that move written down. Pasting a task's block into a fresh session is the manual fallback when the user would rather run one task by hand; that session reads the stream's contract Decisions before it starts.

**Supervisor handoff block.** Supervision changes hands with a block of its own, whether the planner hands it over at the delivery go (step 11), a running supervisor hands over the rest of the stream, or a dead session has to be replaced:

```
Octoplan Autopilot <work stream>
Octopad · Organisation: <organisation> · Workspace: <workspace>
```

Same discipline as above: the plain stream name without the ` (octoplanned)` suffix, and both the organisation and the workspace, because workspace names repeat across organisations. The session that receives it sees the recorded go and lands straight in supervision (see Resuming a stream), so the user is never asked again for a decision they already made. Add a third line only for something true of the environment that Octopad cannot hold, such as which branch the chain stacks on. Anything Octopad can hold belongs in Octopad, not in the block.

The user pastes a task's block into a fresh session, which briefs itself entirely from Octopad (`start_session` on the workspace, `build_context` on the task). The prompt is a pointer, never a payload, so it can never go stale. A session learns to emit it from ONE place: the **Next** line of the task it just finished. So the planner writes that line as a verbatim instruction, using these patterns, with the real names filled in and `<block>` standing for the two-line block above built for the named task:

- **Sequential** — successor is one executable task:
  `**Next:** #4 - <title>. When this task is fully done and verified, check in Octopad that #4 is still open and unclaimed and its dependencies are done, then end your reply with a fenced code block containing exactly: <block for #4>. If #4 is not ready, end instead with one line naming what it waits on.`
- **Human gate next** — successor is a human-only task:
  `**Next:** waits on "<human task title>" (owner: <name/role>). When this task is done, end your reply by stating in one line that the chain waits on that action, then give the user this block to paste once it is done: <block for the task after the gate>.`
- **Parallel fan-out** — several independent siblings become ready at once:
  `**Next:** parallel group #2 + #3. When this task is done and both are confirmed ready in Octopad, emit one fenced code block PER sibling (<block for #2>, then <block for #3>) — the user opens one fresh session per block.`
- **Inside a parallel group** — exactly ONE sibling is the **relay** (it carries the chain); the others are **terminal**:
  - Relay: `**Next:** #6 - <title>, after the whole group (#2, #3) is done. Relay: check in Octopad whether every sibling is done. If yes, emit the #6 continuation block. If not, name what is still running and give the user the #6 block to paste once the group is done.`
  - Terminal: `**Next:** none — terminal branch; #3 carries the continuation.` (The finishing session ends with its wrap-up and NO continuation prompt, so the chain never forks.)
- **Terminal human gate** — the stream ends on a landing task nobody automated follows:
  `**Next:** none — the stream ends on "<landing task title>" (owner: <name/role>). End with the wrap-up and one line naming what that person still has to do.`
- **End of chain:** `**Next:** none — last task of the stream. End with the wrap-up only.`

Every pattern carries one more clause when the stream is delivered under a contract: `Before starting, read this work stream's Decisions in Octopad — they carry the delivery contract that governs this task.` Add it verbatim to the Next line of every task on a stream that has contract Decisions, so a session opened by hand works under the same mandate a worker would.

A Next line that points into another work stream (a multi-stream effort) works the same way: the block simply names that stream, and the organisation and workspace stay as they are.

Parallelize only on true independence: no shared file, symbol, or contract for code; no shared editorial structure, template, or deliverable one sibling shapes for another, for content; never data migrations or shared generated artifacts. Parallel is the exception. Executors work only tasks assigned to them or unassigned — **a task assigned to another person is theirs; the plan assigns tasks accordingly, and an executor finding a foreign assignment warns the user instead of working it.**

## Multi-stream efforts (Blueprint)

When a request is too big for one work stream, plan it as ONE effort across several autonomous streams. The scoping brief (step 2) is written ONCE for the whole effort, before the cut into streams — the assumptions worth catching (where the seams fall, what each stream owns) live at effort level. A later Octoplan pass on a single stream of an existing effort writes its own stream-level brief: the effort brief covered the cut, not the stream's internals. No new Octopad object is needed — an effort is a goal + several work streams + one Blueprint page, all in the same workspace (dependency edges cannot cross workspaces):

1. **Cut the work into autonomous packages**, one work stream each. A package stays a top-level task of its own stream — never artificially demoted to a subtask of another stream's task. Link every stream to the same goal. Wire the real dependencies between tasks across streams and note what can run in parallel.
2. **Write one Blueprint page** — deliberately light: the expected outcome, each stream's role, the global order, the parallel branches, the few dependencies that matter, the human validation points, and the effort's end condition. Link it to the tasks it governs so every executor immediately sees where its work sits in the whole. The Blueprint explains the logic; the Octopad dependency graph enforces it — the page carries no statuses and no copies of task content, so it never goes stale.
3. **Plan at effort scale.** Continuation crosses stream boundaries like any other step: a task's Next line may point into another stream — the continuation prompt then names that stream. The effort's final validation task includes one closing subtask: **archive the Blueprint page** once the effort is done.

If one work stream suffices, none of this applies.

## Replanning — when execution changes the plan

A plan has no scheduled revisions. It changes only when reality changes it: a session executing a task discovers something that adds a task, drops one, changes the order, or moves the base the work sits on. The session that makes the discovery invokes this skill right then and rebalances the WHOLE plan, never just its own corner:

- When what the work builds on has moved, re-read the final validation task's spec FIRST, not last: every earlier task gets corrected as it is worked, and that one is corrected by nothing. Then re-read what each unfinished piece actually sits on now, and write the resulting order onto the stream, not into the chat.
- Re-validate every spec the change touches against the current sources.
- Renumber the `#N` prefixes so the rank stays unambiguous.
- Rewire the dependency edges and every Next line the change affects — a stale Next line kills the chain.
- Update the tracker's ordering logic if the why-this-order changed — rewrite it in place. Never append a correction under stale text: a reader meets the wrong version first and stops there.
- Run the per-task self-check on any task added or materially rewritten, before the session ends.

Then hand the user the corrected continuation prompt, or — if a supervisor is running the stream — hand the rebalanced order back to it, and go back to work. The implementation-free rule binds planning passes; a rebalance inside a delivery or execution session covers exactly these plan edits, nothing more. Neither the scoping brief nor the delivery contract is rerun on a rebalance: both belong to full planning passes, and the standing contract keeps governing the rebalanced tasks — except where a new task falls outside its forecast, which expires the contract for that task and needs the user's re-confirmation before it runs. One limit: if the discovery breaks the stream's own logic — its definition of success no longer matches reality — or the rebalance would add or materially rewrite more than a couple of tasks or move the scope, that is not a rebalance: stop and tell the user the stream needs a fresh "Octoplan Autopilot" pass on it instead of patching it mid-flight.

## Self-check list (step 8)

Human-only tasks: check they carry no `#N` prefix, no Exec/Review lines, no Next line — but do carry Why/What/Done when, the impact parameters, and an owner. Placeholders: check the title prefix, the required headers, and the flesh-out note. Subtasks: check only Why + What.

Per executable task:
- Title carries `#N - `; the rank is unambiguous among the stream's executable tasks.
- Why / What / Done when present under those literal names; impact parameters set.
- Exec and Review lines present, each with its why, matching the rubric.
- A task with 3+ distinct internal steps carries one subtask per step.
- How names the specific files or source documents to touch, plus the outcome and the constraint — a memory-less session could open the right things from this text alone. "Follow the existing pattern" fails this row. Every named precedent carries the evidence that it fits THIS case, not just its name.
- Every path, symbol, command, and source claim in the spec appeared in this session's tool output — and every claim naming a version, an identifier, or a count was re-derived here, not recalled. Can't re-derive it now: cut it, and log a Question if the plan needs it. A precise-sounding wrong fact invites no check, which is what makes it worse than a vague one.
- Verify steps are exact and need no login, no third-party seat and no browser the executor cannot drive — any of those is a human-only task, not a Verify line; anything that can only mature later is named in `**Preconditions:**`.
- One job; fits one executor session; independently verifiable.
- Anything assumed LIVE is named in `**Preconditions:**`.
- The Next line uses one of the Continuation patterns verbatim (with real names filled in) and matches the dependency graph; exactly one relay per parallel group; terminals really are terminal.
- No guesses: every gap is a Question, a Decision, or a flesh-out placeholder.

Per plan:
- The scoping brief was confirmed by a user reply sent after seeing it, before any decision was locked or task written; every assumption in it was confirmed, corrected, or logged as a Question.
- The delivery contract was confirmed by the user and recorded as stream Decisions — both dials, the reviewer routing, the stacking choice, the gate map — with nothing load-bearing left only in the chat.
- Every human gate the specced plan carries appears in the gate map, and the plan's one-way doors are wired as gates no dial can skip.
- Every executable task's Next line carries the read-the-contract clause when the stream has contract Decisions.
- Definition of success matches real scope; final validation task wired after the delivery tasks.
- Every point where the plan chose between real alternatives is a recorded Decision, not an unstated default.
- Parallel groups only on truly independent siblings.
- Dependencies wired for every real "B needs A", including across streams. Mechanical test: every task whose How, Verify or Preconditions names another task's output carries an edge to it.
- No task authors user-facing text that a later task is scoped to rewrite.
- Every task whose Done when stops short of the finished state is wired to a landing task that depends on it — never the reverse, which would block the whole stream.
- The stream tracker explains why the tasks run in this order, names the parallel branches and the human gates, and carries no task statuses or copied task content.
- Multi-stream efforts: Blueprint page exists, is light, is linked, and its archiving is a closing subtask.
- Nothing exists to serve process rather than the outcome.

## Changing this skill

This skill is distributed as a plugin. To change it, edit the repository it is published from and release it there, following that repository's contribution guide; never edit an installed copy — plugin auto-update silently overwrites it.

## Common planning mistakes

| Mistake | Consequence |
|---|---|
| Planning straight from the sources, no scoping brief | A plausible misreading of intent ships into every spec — the user finds out after the tasks are built, not before |
| A scoping brief with an empty Assumptions list nobody hunted for | The brief becomes a rubber stamp; the hidden inferences it existed to surface stay hidden |
| A delivery contract agreed in chat and never written to Octopad | The mandate dies with the session — workers and any recovery session read it from the stream's Decisions, so that is where it has to live |
| Reading the target's rule files from memory, or letting a dial override them | The session grants itself autonomy the team never gave it; the rule files are read at contract time and are a floor |
| Skipping the runnability check | A late task (e.g. a check needing access nobody has) turns out impossible after sunk cost |
| Speccing from memory instead of the real sources | Specs cite files or documents that have since changed |
| Speculative scaffolding — tiers, options, or process the stream doesn't need yet | Executors pay a ceremony cost for scale that never arrives |
| A handoff that dumps chain state instead of pointing to it | A bloated, self-staling prompt duplicating Octopad — the continuation prompt is a pointer |
| A planner supervising its own plan after a heavy planning pass | The budget runs out mid-stream, and the judgement the session was kept for has already been dulled by summarising — hand off at the delivery go instead |
| A build task that sprawls past one session | The executor can't finish or verify it cleanly — split at natural seams, never mid-change |
| A titanic validation task — a dozen checks crammed into one description | The executor drowns mid-task and progress is invisible — one subtask per check |
| Naming a precedent as proof of itself, or dictating a technique the spec never tested | The worker inherits a defect nobody measured, and only the review round can catch it — if the plan bought one |
| Choosing the Exec recommendation by gut instead of the rubric | Over- or under-powered sessions: maximum depth overthinks routine work, standard depth under-serves a migration |
| A Next line that names the successor but not the emit instruction | The executor doesn't know this skill — the chain dies after one task; copy the Continuation patterns verbatim |
| Two relays in one parallel group, or none | The chain forks, or dies silently — exactly one sibling carries the continuation |
| A placeholder without the required headers | Octopad rejects the create — placeholders keep Why/What/Done when around the flesh-out note |
| A plan whose ordering logic lives nowhere a human reads | The dependency graph enforces an order nobody can explain six weeks later — put the reasoning in the stream tracker |
| Copying task statuses or task content into the tracker or the Blueprint | Both go stale the first time work moves — they carry logic, the task graph carries state |
| Renaming the template's section names | Octopad literally matches Why / What / Done when at creation and rejects the write |
