---
name: octoplan-autopilot
description: Use when the user says "Octoplan Autopilot" followed by a work-stream name, when the user asks for a work stream to be planned and then delivered under supervision or autonomously, when an Octopad work stream needs turning into an execution-ready plan, when a task marked "Octoplan flesh-out required" needs speccing, or when a session executing a planned stream discovers something that adds a task or changes the order — it invokes this skill to rebalance the plan. Planning is implementation-free until the user's explicit delivery go; after that go the stream is supervised, by that same session or by a fresh supervisor session it hands to. When installed it supersedes the planning-only Octoplan skill, so use it for a plain "Octoplan" request too. Requires a connected Octopad MCP server.
---
Version: 0.10.0

# Octoplan Autopilot — work-stream planning and supervised delivery for Octopad

Octoplan Autopilot turns an Octopad work stream into a plan of detailed, ordered, self-contained tasks, and then — once the user says go — supervises their delivery, either from the planning session or from a fresh supervisor session it hands to. It works for any kind of stream — engineering, marketing, content, operations, legal — because Octopad holds the plan, the state, and the order: any session working the stream briefs itself from Octopad and needs nothing else.

**Everything a later session needs lives in the task itself.** A session that picks a task up has no memory of this one and normally does not load this skill, so the planner writes its hand-off instruction into the task description, verbatim, using the patterns in `references/continuation.md`. That holds for the supervised path too: it is what lets a fresh session take the stream over if this one dies. The one exception is replanning (see Replanning): a session whose discovery changes the plan loads this skill to rebalance it.

## Load the right reference at the right moment

This file is the core every session reads. The rest loads by what you are doing, not who you are:

- **Running a planning pass** (the resume check below says so) — load `references/planning.md` now; it holds the eleven steps.
- **Writing or rewiring any Exec or Review line** — the planner speccing tasks, a rebalance adding or rewriting one — load `references/routing.md` first.
- **Writing, rewiring, or emitting any Next line or continuation block** — speccing, the hand-off, a rebalance, a supervisor handing over — load `references/continuation.md` first.
- **Delivering** — after the delivery go, or resuming a stream whose recorded go stands — load `references/supervision.md`. Never during planning.
- **Touching a multi-stream effort in any way** — planning it (the cut test in `references/planning.md` fires), rebalancing a stream that belongs to one, or supervising one — load `references/multi-stream.md` too.

## Resuming a stream — check this first

Before planning anything, look at the stream you were invoked on. If ALL THREE hold — its name already ends with ` (octoplanned)`, it carries the delivery contract's Decisions, and one of them is a Decision whose own subject is the delivery go, which the user has not withdrawn — then this is a resume, not a new plan. A go mentioned in passing inside another Decision does not satisfy this. Do not re-plan, do not re-run the brief, do not re-ask for the dials, and do not re-ask for the delivery go: the recorded go is the user's permission, already given. Load `references/supervision.md`, re-read the contract Decisions, the open tasks and each one's comments, rebuild the delivery report's state lines from them (see that file), and rejoin the delivery loop where it stopped.

Anything less than all three is a planning pass: load `references/planning.md` and run its steps, in order. Their shape, so you know what you are loading: 1 review or discover · 2 scoping brief, then wait · 3 delivery contract, then wait · 4 lock decisions · 5 plan hygiene + execution order · 6 ground in reality + runnability · 7 spec into tasks · 8 self-check · 9 adversarial review · 10 tracker logic · 11 hand-off and the delivery go. Never run the pass from this summary. A stream that was planned but never given a delivery go simply reaches the hand-off again and waits there.

## What Octoplan needs

- The **Octopad MCP server** connected, with access to the workspace holding the stream. Orient with `start_session`, then `build_context` (mode `work_stream` or `task`). Note the organisation and workspace this session authenticated into — continuation prompts name both.
- Octopad vocabulary used below: every work stream has a **tracker** (its living overview page); **Decisions** and **Questions** are knowledge items of those types, attached to the stream; **goals** sit above streams; **pages** hold documents.
- Octopad enforces a task-creation contract — respect it exactly or the create is rejected:
  - Every task description must contain **Why** and **What** sections; every top-level task also needs **Done when**. Accepted header forms: `**Why**` (bold, with or without a colon), `## Why`, or `Why:` at line start. Synonyms (Context, Goal, Build, Scope) are rejected.
  - Every task needs the `impact` (1–5) and `impact_rationale` creation parameters, subtasks included. These are tool-call parameters, not description text. Anchors: 5 = the stream fails without it; 3 = clearly advances the stream; 1 = nice-to-have.
  - Subtasks (`parent_task_id` on create) need only Why + What.
  - Dependency edges (`depends_on_task_id` on create, or the `link_dependency` action) require a one-line rationale when added.

## Non-negotiables

- **Implementation-free until the delivery go.** While planning, the session's outputs are tasks, Decisions, Questions, design pages, and plan-hygiene edits to existing items — no code, no content deliverables, no "quick fix while we're here". That holds until the user gives an explicit delivery go on the finished plan. After that go this session stops planning: it either supervises delivery by the rules in `references/supervision.md`, or hands supervision to a fresh session (planning step 11). Neither of them writes a deliverable itself.
- **Verified facts only.** Every file path, symbol, command, source claim, or task status cited in a spec must come from THIS session's tool output (reads, searches, Octopad calls), never from memory or plausibility. Can't verify it right now → ask the user or log a Question; never fill a spec slot with a guess.
- **Plain words in everything the user reads.** The scoping brief, the delivery contract, every decision put to them, the hand-off message, and every report from delivery: name what will happen and who does it, in words a reader who does not code can answer without asking what one means, and precise enough that a reader who does finds nothing vague. This skill's vocabulary belongs to the planner, so keep contract, gate, routing, stacking, dial, floor and one-way door out of those messages, along with any synonym doing the same job, and say the thing itself: "your team's own rules already require this", "this cannot be undone". Never the empty passive — "it goes for review", with nobody in it, is the failure; name the person, the role where a rule forbids the name, or the automatic check that clears it with no person involved. This rule covers what you write to the USER, in the chat. What you write for another session keeps the planner's precise wording, untouched: the Octopad records, every task description and Next line, the continuation blocks, and the worker launch template.
- **Every gate runs on every full planning pass.** A small stream is not a reason to skip the scoping brief (step 2), the delivery contract (step 3), the self-check (step 8), or the adversarial review (step 9). A mid-execution rebalance runs only the reduced set named in Replanning.

## When NOT to use

A single small task: just write a good task description.

## Keep the plan simple

Spec the simplest plan that fully delivers the definition of success — least new process, fewest moving parts. Reuse the stream's existing conventions before inventing new ones; when two structures both work, pick the one an executor can follow with less ceremony. No speculative scaffolding: no extra tiers, bespoke status markers, or synchronization steps the stream doesn't need yet. Apply this bar to the plan itself, not only to what it produces — an over-engineered process costs as much as over-engineered code.

Simplicity means cutting invented process, never correct decomposition. Decompose to one real job per task, and size each task to **one focused executor session**: a single coherent job that leaves the work verifiable on its own and touches only what the change genuinely requires. If a job won't fit one session or would leave a broken intermediate state, split it at a natural seam (schema → backend → frontend, as separate ordered tasks), never mid-change — but do NOT split an atomic change (a rename and its call sites) just to lower a file count. Concrete too-big signals — any one means split: the How describes more than one coherent job; Verify lists more than ~5 independent checks (the final validation task is the exception — it stays ONE task with one subtask per check); the change would sprawl wide without being one atomic edit. Two different splitting tools: separate ordered tasks split work BETWEEN sessions; **Octopad subtasks** structure work WITHIN one session. Whenever a task has 3+ distinct internal steps a memory-less executor could lose track of, create one subtask per step so the executor works a visible checklist instead of a wall of prose. Don't over-split either: a task below a meaningful verifiable state is noise, and so is a subtask below one concrete step.

## Task template

Octopad rejects the create if Why / What / Done when are missing or renamed, or if the impact parameters aren't set. The other slots are Octoplan's conventions — executors read them as plain language, so write them as instructions, not codes. Before filling the template: load `references/routing.md` for the Exec and Review slots, and `references/continuation.md` for the Next slot.

```
Title: #N - <task title>

**Why:** <why this task exists and what it builds on — enough for a memory-less session>
**What:** <the one job in a sentence, plus scope and boundaries — what's out when ambiguous>
**How:** <exact paths or source documents, the outcome and constraint, a checked precedent where one carries, edge cases to cover>
**Verify:** <exact copy-pasteable commands or concrete checks>
**Done when:** <the concrete end state, named in the system of record where the deliverable lives — for content or ops, the approved/published/filed state and where it sits; for code, the state the target's rules actually let this session reach, never just "tests pass" — see the note under this template>
**Exec:** <recommended model tier · reasoning depth> — <why>
**Review:** <required | skip> — <why>
**Preconditions:** <what must be LIVE or matured, not just written>
**Next:** <the hand-off instruction — the matching pattern, copied verbatim>
```

Creation parameters alongside the description: `impact` (1–5) and `impact_rationale`, plus `parent_task_id` for subtasks and `depends_on_task_id` (+ rationale) for dependencies. The `**Preconditions:**` slot is omitted entirely when not needed — never left as placeholder text. Subtasks carry only Why + What (put the subtask's concrete check or step in its What).

A Done when never names a state this session's own rules forbid it reaching: where the finish line is out of reach, the task ends at open-green-handed-off and a human-only landing task carries the rest (the landing-task rule, planning step 5). Where the change ships behavior a user or the team will see, its Done when includes recording the documentation consequence in the target's own mechanism (for a repository, its per-change doc-impact convention) — the final validation task only confirms what the delivery tasks recorded.

**The Verify slot of a task that changes production code carries one call-site proof per production path the task changes or guards.** Each in this fixed two-line shape, with the real names filled in: "In a scratch checkout, remove or disable <the exact call/filter/write>, run <the exact suite command>, paste the failing output; discard the edit, run it again, paste the passing output." A suite that stays green with a real path removed proves the tests attack helpers instead of the change, and the worker proves the opposite for almost nothing, where a review round buys the same finding late and expensively. Where the suite is slow, the narrowest suite covering the path is enough.

## Exec & Review — the core rules

The rubric, the lane dispatch mechanics, the effort vocabulary, availability conditions, and reviewer lens counts live in `references/routing.md` — load it before writing any Exec or Review line. Always true, whoever is reading:

- The planner records the model and reasoning depth for each task's launch. **The saved route is a floor:** the executor may escalate when live work proves harder than specced, never weaken it, and it must not silently drop the Sonnet floor or substitute a model that cannot provide the saved effort. If the exact route is unavailable or its data-retention policy is unacceptable, say so and recommend the best compatible fallback — never quietly swap.
- The five lanes the rubric can save: **Sonnet 5 · xhigh, Opus 5 · high, Opus 5 · xhigh, Opus 5 · max, Fable 5 · xhigh** — which profile takes which lane, and the conditions on Fable and `max`, are in `references/routing.md`.
- **Review:** `required` whenever a mistake would be costly — real decision-making, security/permissions, a data migration, cross-file logic, anything published or client-facing. `skip` only for genuinely trivial mechanical changes a fresh pass would find nothing in. Default to `required` when unsure. When required, one or more separate fresh agents — no memory of writing the work — attack just the finished change, worst problems first, and confirmed findings are fixed before delivering. Under manual execution the executor session runs that review itself; under supervised delivery the supervisor spawns the reviewers and the worker never does. A required Review line names its lens count in its why (`references/routing.md`). **The reviewer's route is never cheaper than the work it attacks.**

## Continuation — how the chain moves between sessions

Sessions are chained by a **minimal continuation prompt**: a fenced code block holding two lines of plain text, no links and no formatting. The exact block formats, the six Next-line patterns, and the settings-line rule live in `references/continuation.md` — load it whenever you write, rewire, or emit one of these.

What is always true:

- **The prompt is a pointer, never a payload.** The receiving session briefs itself entirely from Octopad (`start_session`, then `build_context`), so the block can never go stale. Anything Octopad can hold belongs in Octopad, not in the block.
- **Every block handed to the user carries its launch settings** on one plain line directly under the fence (outside it): model, reasoning effort, and solo or parallel-safe. The user launching the session sets those, so a block without this line hands them a decision the plan already made.
- Under supervised delivery the blocks are the **fallback path, not the normal one**: the supervisor sequences the work itself and its workers emit no continuation block. They still get written on every task — they are the manual path (the user running one task by hand) and the recovery path. If the supervising session dies, the first recovery move is to invoke this skill on the stream again (see Resuming a stream) — the supervisor handoff block in `references/continuation.md` is that move written down.
- Parallelize only on true independence: no shared file, symbol, or contract for code; no shared editorial structure, template, or deliverable one sibling shapes for another, for content; never data migrations or shared generated artifacts. Parallel is the exception, and every parallel group has exactly ONE relay sibling that carries the chain.
- Executors work only tasks assigned to them or unassigned — **a task assigned to another person is theirs; the plan assigns tasks accordingly, and an executor finding a foreign assignment warns the user instead of working it.**

## Multi-stream efforts

A request too big for one work stream is planned as ONE effort across several autonomous streams — a goal, several work streams, and one light Blueprint page, all in the same workspace. The cut test that decides it runs in planning step 1 (`references/planning.md`); the full protocol is `references/multi-stream.md`, loaded by any session that plans, rebalances, or supervises a stream belonging to an effort.

## Replanning — when execution changes the plan

A plan has no scheduled revisions. It changes only when reality changes it: a session executing a task discovers something that adds a task, drops one, changes the order, or moves the base the work sits on. The session that makes the discovery invokes this skill right then and rebalances the WHOLE plan, never just its own corner:

- When what the work builds on has moved, re-read the final validation task's spec FIRST, not last: every earlier task gets corrected as it is worked, and that one is corrected by nothing. Then re-read what each unfinished piece actually sits on now, and write the resulting order onto the stream, not into the chat.
- Re-validate every spec the change touches against the current sources.
- Renumber the `#N` prefixes so the rank stays unambiguous.
- Rewire the dependency edges and every Next line the change affects (load `references/continuation.md`) — a stale Next line kills the chain.
- A task added or materially rewritten gets every template slot, Exec and Review included (load `references/routing.md`), and passes the per-task self-check below before the session ends.
- Update the tracker's ordering logic if the why-this-order changed — rewrite it in place. Never append a correction under stale text: a reader meets the wrong version first and stops there.

Then hand the user the corrected continuation prompt, or — if a supervisor is running the stream — hand the rebalanced order back to it, and go back to work. On a multi-stream effort a supervisor rebalances only its own stream; a change touching a seam — a cross-stream dependency, the Blueprint's order, the effort's end condition — stops for the user, per `references/multi-stream.md`. The implementation-free rule binds planning passes; a rebalance inside a delivery or execution session covers exactly these plan edits, nothing more. Neither the scoping brief nor the delivery contract is rerun on a rebalance: both belong to full planning passes, and the standing contract keeps governing the rebalanced tasks — except where a new task falls outside its forecast, which expires the contract for that task and needs the user's re-confirmation before it runs. One limit: if the discovery breaks the stream's own logic — its definition of success no longer matches reality — or the rebalance would add or materially rewrite more than a couple of tasks or move the scope, that is not a rebalance: stop and tell the user the stream needs a fresh "Octoplan Autopilot" pass on it instead of patching it mid-flight.

## Per-task self-check

Run this on every executable task you write or materially rewrite — the planner at step 8 (which adds the per-plan list in `references/planning.md`), a rebalance before its session ends. Re-read the task FROM OCTOPAD (what was actually saved, not what you remember writing); fix failures on the spot, then re-check the fixed task.

Human-only tasks: check they carry no `#N` prefix, no Exec/Review lines, no Next line — but do carry Why/What/Done when, the impact parameters, and an owner. Placeholders: check the title prefix, the required headers, and the flesh-out note. Subtasks: check only Why + What.

Per executable task:
- Title carries `#N - `; the rank is unambiguous among the stream's executable tasks.
- Why / What / Done when present under those literal names; impact parameters set.
- Exec and Review lines present, each with its why, matching the rubric.
- A task with 3+ distinct internal steps carries one subtask per step.
- How names the specific files or source documents to touch, plus the outcome and the constraint — a memory-less session could open the right things from this text alone. "Follow the existing pattern" fails this row. Every named precedent carries the evidence that it fits THIS case, not just its name.
- Every path, symbol, command, source claim, claim about how the product behaves, and claim about what the environment can reach in the spec appeared in this session's tool output — and every claim naming a version, an identifier, or a count was re-derived here, not recalled. Can't re-derive it now: cut it, and log a Question if the plan needs it. A precise-sounding wrong fact invites no check, which is what makes it worse than a vague one.
- Verify steps are exact and need no login, no third-party seat and no browser the executor cannot drive — any of those is a human-only task, not a Verify line; anything that can only mature later is named in `**Preconditions:**`.
- One job; fits one executor session; independently verifiable.
- Anything assumed LIVE is named in `**Preconditions:**`; where only a person can make it true, a human-only task with a dependency edge carries the wait, not the line alone.
- The Next line uses one of the patterns in `references/continuation.md` verbatim (with real names filled in) and matches the dependency graph; exactly one relay per parallel group; terminals really are terminal.
- No guesses: every gap is a Question, a Decision, or a flesh-out placeholder.

## Changing this skill

This skill is distributed as a plugin. To change it, edit the repository it is published from and release it there, following that repository's contribution guide; never edit an installed copy — plugin auto-update silently overwrites it.
