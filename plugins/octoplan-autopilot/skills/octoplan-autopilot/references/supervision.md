# Supervised delivery

Load this only after the user's explicit delivery go on a finished plan. From here on this session is the **supervisor**: it does not write the deliverables, it sequences the plan, sends each task to a fresh worker, checks the proof that comes back, and stops where the contract says a person decides.

## The mandate comes from Octopad

Re-read the delivery contract's Decisions on the stream before the first task and after any interruption: the two dials, the reviewer routing, the stacking choice, the gate map. Those Decisions are the mandate. Nothing agreed only in the chat counts, and nothing remembered from the planning conversation counts either — if it matters and it is not recorded, ask again and record it.

The target's own rule files stay the floor. Where they and the dials disagree, the rule files win.

## The loop

Repeat until the stream is done or nothing is left that the mandate lets you touch:

1. **Pick.** Take the next task Octopad reports as ready — dependencies done, nobody else's assignment, not blocked. Set it in progress.
2. **Send.** Launch a fresh worker subagent with a pointer, not a payload: the organisation and workspace, the task, and the mandate that governs it (the dials, the gates that apply to this task, who reviews it). The worker connects to Octopad and briefs itself from the task; do not paste the task's contents, your reading of it, or a restatement of how Octopad works — that arrives with the task.
3. **Collect.** The worker does the one job, writes what it did, what it decided, and anything it hit onto the task, and returns a one-line status. Treat the one-liner as a signal only: the task is the record.
4. **Check.** Run the verification gate below. Only then close the task.
5. **Advance.** Move to the next ready task, or stop at a gate.

Workers in this mode do NOT emit the task's continuation block — you own the sequencing. The Next lines exist for recovery (below).

Keep your own context small. You read task comments and gate results, not the workers' working history.

## What every worker is told

- Which workspace and which single task. One task per worker, always.
- Its mandate: what it may decide alone, what it must bring back, which gates apply.
- Where it works: its own branch, or its own isolated copy of the repository when it runs beside another worker.
- That its results, decisions and blockers go onto the task before it answers, in the user's language.
- That it must not close its own task, start the next one, or emit a continuation block.

Nothing else. A worker that needs more context reads it from Octopad or asks.

## Verification gate — before any task is closed

- **Run the task's Verify steps yourself, or have the worker run them and paste the real output into the task.** A worker's claim that checks passed is not evidence. No output, no close.
- **Honor the task's Review line.** When it says required, a separate fresh reviewer subagent — one that did not write the work — attacks the finished change against the real sources, worst problems first. Confirmed findings are fixed and re-verified before the close.
- **Machine review always runs; human routing decides who ALSO clears it.** The contract's reviewer routing names the person for a class of task; that person's clearance is added on top of the fresh review, never instead of it.
- A dial can remove a human's waiting time. It can never remove a check.

If a Verify step turns out to be unrunnable, that is a blocker, not a licence to skip it.

## Delivering the work

- **One task, one branch.** The worker branches from the current base, does its job, and opens the change for review when the target's process uses pull requests. Follow the target's rules for how a change is named, described and checked; read them, do not assume them.
- **Merge dial set to "user validates":** the change waits. Report it, name who has to clear it, and move on to independent work.
- **Merge dial set to "mandate to land":** once every gate for that task has passed — checks green, fresh review clean, any routed human cleared it — land it and record that in the task. Still stop for anything on the one-way-door list.
- **Stacking on:** a dependent change branches off the open change it needs and targets it; when the base lands, retarget it to the main line. **Stacking off:** the dependent task waits for the base to land.
- Anything the contract did not forecast — a migration nobody expected, a permission change, a publish, a spend — expires the contract for that item. Stop it, report it, get the user's decision, update the contract Decisions, then continue.

## Running workers in parallel

Only for tasks the plan itself marked independent, each in its own isolated copy of the repository or workspace so two workers never write the same file. Never in parallel: data migrations, shared generated artifacts, anything one sibling shapes for another. When in doubt, run them one at a time — sequential is the default, parallel is the exception.

## When to stop, and how

Stop for a human when the contract's gate map says so, when a one-way door is next, when the challenge dial says consult, or when a problem survives your own attempts to solve it. Then report in the user's language, six fields, nothing else:

**State** — where the stream stands. **Done** — what is finished and proven. **Blocked** — what is stuck and why. **Decision expected** — the exact call you need from the user. **To unblock** — what has to happen, and by whom. **Next step** — what resumes the moment it clears.

Any field can be "none". Keep each to a line.

**A checkpoint blocks only its own branch.** Everything independent and safe keeps running while a person decides. Stop the whole stream only when nothing safe is left to do.

If the challenge dial says resolve autonomously, solve what is genuinely reversible and inside the plan, record what you did on the task, and report it afterwards. It never covers a one-way door.

## Recovery

The state is Octopad: the contract Decisions, each task's status, and each task's latest comment. Nothing about this run lives anywhere else, which is what makes it survivable.

If this session dies, a fresh one resumes by invoking this skill on the stream, reading the contract Decisions and the open tasks, and picking the loop back up — or, if that session was never given the delivery go, by taking the next task's continuation block the normal way. Before resuming, check for work left half-done: a task in progress with no verification output is re-run, not assumed finished.

## Closing the stream

The stream is done when its final validation task has passed its own checks, no task is left open, no gate is unanswered, and the tracker's ordering logic still matches what actually happened. End with the same six fields, reporting the finished state and anything still waiting on a person.
