---
name: octoplan
description: Use when the user says "Octoplan" followed by a work-stream name, when the user asks for a work stream to be planned and then delivered under supervision or autonomously, when an Octopad work stream needs turning into an execution-ready plan, when a task marked "Octoplan flesh-out required" needs speccing, or when a session executing a planned stream discovers something that adds a task or changes the order — it invokes this skill to rebalance the plan. Planning is implementation-free until the user's explicit delivery go; after that go the stream is supervised, by that same session or by a fresh supervisor session it hands to. This is the Claude Code distribution of Octoplan; Codex runs its own. Requires a connected Octopad MCP server.
---
Version: 1.2.0

# Octoplan for Claude Code — work-stream planning and supervised delivery for Octopad

Octoplan turns a confirmed outcome into the smallest useful Octopad work graph — a plan of detailed, ordered, self-contained tasks — and then, once the user says go, advances every safe ready branch until the outcome is proven or a real human decision is required, either from the planning session or from a fresh supervisor session it hands to. It works for any kind of stream — engineering, marketing, content, operations, legal — because Octopad holds the plan, the state, and the order: any session working the stream briefs itself from Octopad, or from the task spec it was sent, and needs no memory of the session that planned it.

## One program, three moments

Whatever the stream, the user experiences every run as the same three-stage program: **Brief → Plan → Delivery**. Every message written for the user opens with the matching stage banner as its first line, exactly one of:

- `**Octoplan · Step 1 of 3 — Brief**`
- `**Octoplan · Step 2 of 3 — Plan**`
- `**Octoplan · Step 3 of 3 — Delivery**`

These banners are a contract shared across Octoplan implementations — same words, same order, every run — so the user learns one program. The internal steps below are the planner's machinery and never leak into user messages: the step-1 interview and the scoping brief speak under the Brief banner; step 4's decisions and the hand-off — the finished plan, its consequences, the one delivery question, the go — under the Plan banner; every delivery report, escalation, and mid-delivery consent under the Delivery banner.

**Octoplan runs inside the session's environment, never instead of it.** It says what the stream delivers and in what order; how work is done comes from the environment every session already has — the target's rule files, the skills installed there, Octopad's own and the user's alike, and the hooks — exactly as it would with no Octoplan in the room. That binds the supervisor as much as it binds a worker: a supervisor that opens, updates, or merges a change, or applies a migration, is a session delivering, and loads the skills that match that act. Nothing in this skill or its references stands in for them, and no prompt or template lists them, because what a session's environment holds is the user's to compose, not this skill's to know.

**Everything a later session needs lives in the task itself.** A session that picks a task up has no memory of this one and normally does not load this skill, so the planner writes everything the task needs into its description — the spec is the whole brief, and a worker is never sent to gather more — plus its hand-off instruction, verbatim, using the patterns in `references/continuation.md`. That holds for the supervised path too: it is what lets a fresh session take the stream over if this one dies. The one exception is replanning (see Replanning): a session whose discovery changes the plan loads this skill to rebalance it.

## Load the right reference at the right moment

This file is the core every session reads. The rest loads by what you are doing, not who you are:

- **Running a planning pass** (the resume check below says so) — load `references/planning.md` now; it holds the eleven steps.
- **Writing or rewiring any Exec or Review line** — the planner speccing tasks, a rebalance adding or rewriting one — load `references/routing.md` first.
- **Writing, rewiring, or emitting any Next line or continuation block** — speccing, the hand-off, a rebalance, a supervisor handing over — load `references/continuation.md` first.
- **Delivering** — after the delivery go, or resuming a stream whose recorded go stands — load `references/supervision.md`. Never during planning.
- **Touching a multi-stream effort in any way** — planning it (the cut test in `references/planning.md` fires), rebalancing a stream that belongs to one, or supervising one — load `references/multi-stream.md` too.

## Resuming a stream — check this first

Before planning anything, look at the stream you were invoked on. If ALL THREE hold — its name already ends with ` (octoplanned)`, it carries the delivery contract's Decisions, and one of them is a Decision whose own subject is the delivery go, which the user has not withdrawn — then this is a resume, not a new plan. A go mentioned in passing inside another Decision does not satisfy this. Do not re-plan, do not re-run the brief, do not re-ask the delivery mode, and do not re-ask for the delivery go: the recorded go is the user's permission, already given. One thing a resume MAY re-ask: a stream planned under an earlier version of this skill can lack a stakes Decision and carry a definition of success with no number — derive both from the tracker and the go record, put them to the user in one short exchange, and record the stakes Decision (kill question included) and the countable definition before the first dispatch; nothing else already settled is reopened. And check the go itself: a go Decision that names the hand-off message it answered and postdates it resumes on its face; one naming none is legacy — resume on its face and write the gap on the stream; one that predates the hand-off it names, or was recorded against a plan that was never shown, is not a go at all — re-authorize per the path in the next sentence before the first dispatch. A go resting on a standing intent the user gave before an away period resumes like any other, provided its Decision names the words that gave it, the message that showed the plan, and which disclosed effects those words covered (planning step 11); a Decision missing that effect list is not a standing-intent go, and every protected effect waits for a person until the user confirms. A stream whose contract Decisions predate delivery modes (they record two autonomy dials instead) is re-authorized, not resumed on its old go: show the CURRENT plan in the hand-off's form (the full step 11.1 list, bold consequence lines included, plus the outcome-and-kill-question lines), run the review the plan has not had under this contract, and ask the one mode question; the answer becomes a fresh go Decision with its disclosed list and reviewed graph. Old authority is never silently widened. And two things break any resume — the user explicitly asking for a re-plan, or a brief that no longer matches reality: either withdraws the go for this purpose and routes the invocation to the planning pass instead, carrying forward the recorded Decisions that still hold. Load `references/supervision.md`, re-read the contract Decisions, the open tasks and each one's comments, rebuild the delivery report's state lines from them where a report exists or applies (see that file), and rejoin the delivery loop where it stopped.

Anything less than all three is a planning pass: load `references/planning.md` and run its steps, in order. Their shape, so you know what you are loading: 1 review or discover · 2 scoping brief, then wait · 3 delivery groundwork, recorded not asked · 4 lock decisions · 5 plan hygiene + execution order · 6 ground in reality + runnability · 7 spec into tasks · 8 self-check · 9 adversarial review · 10 tracker logic · 11 hand-off, the delivery-mode question and the go. Never run the pass from this summary. A stream that was planned but never given a delivery go simply reaches the hand-off again and waits there.

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
- **Verified facts only.** Every file path, symbol, command, source claim, or task status cited in a spec must come from THIS session's tool output (reads, searches, Octopad calls), never from memory or plausibility. Can't verify it right now → ask the user or log a Question; never fill a spec slot with a guess. This binds every record and report a session writes — specs, Decisions, task comments, reports, and any retrospective account of a run: a quotation is copied from a source read this session, never recalled; a number is re-derived at the moment of writing, never recalled; and a number later work will move takes a pointer to the file that owns it instead of a copy. A record written from memory reads exactly as authoritative as a verified one, which is what makes it worse. And an auto-generated view — a tracker, a progress report — is never a source or an authorization: it points, and the tasks, Decisions, and target state prove.
- **Plain words in everything the user reads.** The scoping brief, the delivery terms, every decision put to them, the hand-off message, and every report from delivery: name what will happen and who does it, in words a reader who does not code can answer without asking what one means, and precise enough that a reader who does finds nothing vague. This skill's vocabulary belongs to the planner, so keep contract, gate, routing, stacking, floor and one-way door out of those messages, along with any synonym doing the same job, and say the thing itself: "your team's own rules already require this", "this cannot be undone". Every consent you ask states its consequence in words a non-expert can answer — "this deletes existing data", "this spends money" — and never asks the user to certify technical correctness: judging the work is the system's job, owning the consequence is theirs. Never the empty passive — "it goes for review", with nobody in it, is the failure; name the person, the role where a rule forbids the name, or the automatic check that clears it with no person involved. This rule covers what you write to the USER, in the chat. What you write for another session keeps the planner's precise wording, untouched: the Octopad records, every task description and Next line, the continuation blocks, and the worker launch template.
- **Staging first, reversible by design.** Where the target offers a staging surface, changes land there before production; prefer reversible designs, and a justified irreversible change is high-risk work (2+ review lenses, `references/routing.md`). This binds planning, every rebalance, and delivery alike.
- **Rigour is sized to the decision, in both directions.** Planning records the stream's stakes (step 3): the decision this stream feeds, its blast radius, and whether a wrong outcome can be undone. Every verification rule in this skill is then read against that record — where the outcome is reversible and internal, the review floor is one lens and Verify carries only the load-bearing facts; where it is irreversible or outward-facing, the full floors in `references/routing.md` apply. Verification that outgrows the decision it protects is a defect, the same as verification that falls short: every review round, re-check, and gate spends the user's time and money against the same stakes the work does.
- **Every stream carries its kill question, and it never stays answered.** One falsifiable sentence, recorded at planning with the stakes: what would make this stream's entire output worthless, and what observation would show it. It is confirmed at the hand-off, re-answered by every session that resumes or takes over the stream, and re-asked on a fixed cadence during delivery (`references/supervision.md`) — an answer from a previous leg, however well proven there, is not an answer on this one.
- **The brief and the review run on every full planning pass.** A small stream scales the scoping brief down (step 2) — it never skips it — and the adversarial review keeps its floor (step 9). The self-check (step 8) always runs. The user is interrupted at most twice on the happy path — the brief confirmation (reduced to the Readings playback when an unchanged confirmed brief stands) and the plan go — plus any step-4 decision only they can own. A mid-execution rebalance runs only the reduced set named in Replanning.

## When NOT to use

A single small task: just write a good task description — unless the user explicitly invoked Octoplan, which always runs the three moments; a one-task plan is a fine plan.

## Keep the plan simple

Spec the simplest plan that fully delivers the definition of success — least new process, fewest moving parts, no speculative scaffolding (extra tiers, bespoke status markers, synchronization steps the stream doesn't need yet). Reuse the stream's existing conventions before inventing new ones, and apply this bar to the plan itself, not only to what it produces. **Planning is overhead the outcome pays for**: when the pass is costing more than the first useful piece of delivery it enables, cut the plan, never the delivery. And a user who asks for simplicity is setting the plan's size, not describing a mood — record it with the stakes, and let it decide how many tasks this stream carries.

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
**Octopad:** <yes | no> — <why>
**Preconditions:** <what must be LIVE or matured, not just written>
**Next:** <the hand-off instruction — the matching pattern, copied verbatim>
```

Creation parameters alongside the description: `impact` (1–5) and `impact_rationale`, plus `parent_task_id` for subtasks and `depends_on_task_id` (+ rationale) for dependencies. The `**Preconditions:**` slot is omitted entirely when not needed — never left as placeholder text. Subtasks carry only Why + What (put the subtask's concrete check or step in its What).

A Done when never names a state this session's own rules forbid it reaching: where the finish line is out of reach, the task ends at open-green-handed-off and a human-only landing task carries the rest (the landing-task rule, planning step 5). Where the change ships behavior a user or the team will see, its Done when includes recording the documentation consequence in the target's own mechanism (for a repository, its per-change doc-impact convention) — the final validation task only confirms what the delivery tasks recorded.

**The Verify slot of a task that changes production code carries one call-site proof per production path the task changes or guards.** Each in this fixed two-line shape, with the real names filled in: "In a scratch checkout, remove or disable <the exact call/filter/write>, run <the exact suite command>, paste the failing output; discard the edit, run it again, paste the passing output." A suite that stays green with a real path removed proves the tests attack helpers instead of the change, and the worker proves the opposite for almost nothing, where a review round buys the same finding late and expensively. Where the suite is slow, the narrowest suite covering the path is enough.

The same discipline binds every check, code or not: **a check ships with its own defeat proof, designed before the check** — name how this check could pass while the thing it names is broken, and show that it does not. A check resting only on data the task produced itself always fails this test. And every Verify slot names its **proof surface** — the rendered page, the live API, the raw trace, the exact database, the source corpus — matched to the Done when: a source read or a passing test suite never satisfies a Done when whose surface is a rendered page or a live system, because the first real use is then the first real check. Where that surface needs a login, a seat, or a browser the executor cannot drive, the proof becomes a human-only verification task with a named owner (the runnability remedy, `references/planning.md` step 6), and the executable task's Done when steps back to the state it can actually reach.

## Octopad line — does the worker connect?

The planner decides, per task, whether the session doing it opens Octopad at all, and writes it as the `**Octopad:**` line. Opening Octopad is not free: the orientation a session receives on connecting, plus the task's own context, is a large fixed read that a small model pays before it opens the first file. So the line is **no** whenever the task's text is enough to do the job — the deliverable lives outside Octopad (code, files, a draft) and no slot of the spec names Octopad, a page, or the task itself as something to read or write while working. The line is **yes** whenever the work itself happens in Octopad (pages, knowledge, tasks), or the task must read or write something there mid-work. Under supervised delivery the supervisor applies the line without judging it: a **yes** worker connects and reads its task; a **no** worker receives the spec pasted into its launch message and never connects, and the supervisor records its report on the task (`references/supervision.md`). On the manual path the line is advice: the user's own session is connected anyway. A task written before this line existed carries none; the supervisor then answers the same question from the spec and writes its answer in the launch message.

## Exec & Review — the core rules

The rubric, the lane dispatch mechanics, the effort vocabulary, availability conditions, and reviewer lens counts live in `references/routing.md` — load it before writing any Exec or Review line. Always true, whoever is reading:

- The planner records the model and reasoning depth for each task's launch. **The saved route is a floor:** the executor may escalate when live work proves harder than specced, never weaken it, and it must not silently drop the Sonnet floor or substitute a model that cannot provide the saved effort. If the exact route is unavailable or its data-retention policy is unacceptable, say so and recommend the best compatible fallback — never quietly swap.
- The five lanes the rubric can save: **Sonnet 5 · xhigh, Opus 5 · high, Opus 5 · xhigh, Opus 5 · max, Fable 5.1 · xhigh** — which profile takes which lane, and the conditions on Fable and `max`, are in `references/routing.md`.
- **Review:** `required` whenever a mistake would be costly — real decision-making, security/permissions, a data migration, cross-file logic, anything published or client-facing. `skip` only for genuinely trivial mechanical changes a fresh pass would find nothing in. Default to `required` when unsure. When required, one or more separate fresh agents — no memory of writing the work — attack just the finished change, worst problems first, and confirmed findings are fixed before delivering, within the review-round budget in `references/supervision.md`: a finding class that budget stops is recorded as a stated limit of the deliverable, never silently dropped — unless it answers the stream's kill question, which no stated limit can hold. Under manual execution the executor session runs that review itself; under supervised delivery the supervisor spawns the reviewers and the worker never does. A required Review line names its lens count in its why (`references/routing.md`). **The reviewer's route is never cheaper than the work it attacks.**

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

A plan has no scheduled revisions. It changes only when reality changes it: a session executing a task discovers something that adds a task, drops one, changes the order, or moves the base the work sits on. **The user changing the mandate mid-delivery is the same trigger** — a scope cut, a corrected reading of what they asked for, a Decision superseded or retired — and it demands two sweeps before any further dispatch:

- **Sweep every open task's spec against the new mandate**, started or not, and rewrite the ones that contradict it. A prose Decision saying "stop doing X" does not visibly override a spec step saying "do X": a concrete instruction beats an abstract one for the session that reads only the spec, so no Decision may leave any task spec contradicting it.
- **Where a Decision was retired, sweep the artifacts it produced**: what did that decision put into code, configuration, or content, and does any of it still run? A decision's residue keeps executing after the reasoning behind it is withdrawn, and a comment justifying the retired decision is itself a defect — it makes the residue look intentional to the next reader. Record the sweep's result on the stream even when it is "nothing".

The session that makes the discovery invokes this skill right then and rebalances the WHOLE plan, never just its own corner:

- When what the work builds on has moved, re-read the final validation task's spec FIRST, not last: every earlier task gets corrected as it is worked, and that one is corrected by nothing. Then re-read what each unfinished piece actually sits on now, and write the resulting order onto the stream, not into the chat.
- Re-validate every spec the change touches against the current sources.
- Renumber the `#N` prefixes so the rank stays unambiguous.
- Rewire the dependency edges and every Next line the change affects (load `references/continuation.md`) — a stale Next line kills the chain.
- A task added or materially rewritten gets every template slot, Exec and Review included (load `references/routing.md`), and passes the per-task self-check below before the session ends.
- Update the tracker's ordering logic if the why-this-order changed — rewrite it in place. Never append a correction under stale text: a reader meets the wrong version first and stops there.

Then hand the user the corrected continuation prompt, or — if a supervisor is running the stream — hand the rebalanced order back to it, and go back to work. On a multi-stream effort a supervisor rebalances only its own stream; a change touching a seam — a cross-stream dependency, the Blueprint's order, the effort's end condition — stops for the user, per `references/multi-stream.md`. The implementation-free rule binds planning passes; a rebalance inside a delivery or execution session covers exactly these plan edits, nothing more, and the scoping brief is not rerun — it belongs to full planning passes. What a rebalance can and cannot carry:

- **Authority is monotonic inside a rebalance.** A valid recorded go persists through internal corrections; replanning and re-review do not themselves revoke it. Three things do, each named elsewhere: the user asking for a re-plan, a stream re-authorized because its contract predates delivery modes (Resuming a stream), and a discovery that breaks the stream's logic (the limit below).
- **New consent, only for a real change of authority:** a new or rewritten task carrying a protected effect missing from the go Decision's disclosed list, landing in a target or class of work the approved plan never named, or changing the substance of a user gate — dependency order or gate placement alone is not such a change. That task stops for the user's consent, stated as its consequence in plain words, before it runs.
- **A rerun after a material premise change is a new task** (or new tasks via this replan), never a reused task carrying two campaigns — the superseded results stay on the old task, attributable.
- **The limit:** if the discovery breaks the stream's own logic — its definition of success no longer matches reality — or the rebalance would add or materially rewrite more than a couple of tasks or move the scope, that is not a rebalance: stop and tell the user the stream needs a fresh "Octoplan" pass on it instead of patching it mid-flight. A fact ALREADY WRITTEN in the run's own records that breaks that logic is this trigger too — the trigger does not wait for a new discovery when the invalidating one is sitting in a comment.

## Per-task self-check

Run this on every executable task you write or materially rewrite — the planner at step 8 (which adds the per-plan list in `references/planning.md`), a rebalance before its session ends. Re-read the task FROM OCTOPAD (what was actually saved, not what you remember writing); fix failures on the spot, then re-check the fixed task.

Human-only tasks: check they carry no `#N` prefix, no Exec/Review lines, no Next line — but do carry Why/What/Done when, the impact parameters, and an owner. Placeholders: check the title prefix, the required headers, and the flesh-out note. Subtasks: check only Why + What.

Per executable task:
- Title carries `#N - `; the rank is unambiguous among the stream's executable tasks.
- Why / What / Done when present under those literal names; impact parameters set.
- Exec and Review lines present, each with its why, matching the rubric; the Octopad line present, and **no** only where no slot of the spec names Octopad, a page, or the task as a surface to read or write while working.
- A task that causes a protected effect names that effect in its spec in plain consequence words — the worker's authorization test reads it there, against the go Decision's disclosed list.
- A task with 3+ distinct internal steps carries one subtask per step.
- How names the specific files or source documents to touch, plus the outcome and the constraint — a memory-less session could open the right things from this text alone. "Follow the existing pattern" fails this row. Every named precedent carries the evidence that it fits THIS case, not just its name.
- Every path, symbol, command, source claim, claim about how the product behaves, and claim about what the environment can reach in the spec appeared in this session's tool output — and every claim naming a version, an identifier, or a count was re-derived here, not recalled. Can't re-derive it now: cut it, and log a Question if the plan needs it. A precise-sounding wrong fact invites no check, which is what makes it worse than a vague one.
- Every Verify check names how it could pass while the thing it names is broken, and shows that it does not (the defeat-proof rule above).
- Verify steps are exact and need no login, no third-party seat and no browser the executor cannot drive — any of those is a human-only task, not a Verify line; anything that can only mature later is named in `**Preconditions:**`.
- One job; fits one executor session; independently verifiable.
- A task that builds an experiment, a staging reproduction, a fixture environment, or a simulation carries its parity manifest, and — where the run it enables is materially expensive — its rehearsal item (`references/planning.md`, step 6, validity half).
- Anything assumed LIVE is named in `**Preconditions:**`; where only a person can make it true, a human-only task with a dependency edge carries the wait, not the line alone.
- The Next line uses one of the patterns in `references/continuation.md` verbatim (with real names filled in) and matches the dependency graph; exactly one relay per parallel group; terminals really are terminal.
- No guesses: every gap is a Question, a Decision, or a flesh-out placeholder.

## Changing this skill

This skill is distributed as a plugin. To change it, edit the repository it is published from and release it there, following that repository's contribution guide; never edit an installed copy — plugin auto-update silently overwrites it.
