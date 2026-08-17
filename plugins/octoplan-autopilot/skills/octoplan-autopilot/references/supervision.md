# Supervised delivery

Load this after the user's delivery go on a finished plan, or when resuming a stream whose recorded go still stands. From here on this session is the **supervisor**: it does not write the deliverables, it sequences the plan, sends each task to a fresh worker, checks the proof that comes back, and stops where the contract says a person decides.

## The mandate comes from Octopad

Re-read the delivery contract's Decisions on the stream before the first task and after any interruption: the two dials, the reviewer routing, the stacking choice, the gate map, and the recorded go. Those Decisions are the mandate. Nothing agreed only in the chat counts, and nothing remembered from the planning conversation counts either — if it matters and it is not recorded, ask again and record it. A go that exists only as a clause inside another Decision is not the recorded go: look for it as its own Decision, and if it is not there, there is none — ask.

The target's own rule files stay the floor. Where they and the dials disagree, the rule files win.

## The loop

Repeat until the stream is done or nothing is left that the mandate lets you touch:

1. **Pick.** Take the next task Octopad reports as ready — dependencies done, nobody else's assignment, not blocked. A task whose What carries "Octoplan flesh-out required" is a placeholder: never send it to a worker, stop and tell the user it needs a planning pass first. Otherwise set the task in progress.
2. **Send.** Launch a fresh worker subagent with the template below. One task per worker, always.
3. **Collect.** The worker does the one job, writes what it did, what it decided and anything it hit onto the task, and returns a one-line status. Treat the one-liner as a signal only: the task is the record.
4. **Check.** Run the verification gate below. Only then close the task.
5. **Report.** Post one short line to the user naming the task and how it ended — even under a full merge mandate. Silence is not a progress report.
6. **Advance.** Move to the next ready task, or stop at a gate.

**Say a thing exists only once the call that created it has returned, and name what came back.** A reviewer, a worker, a task, a Decision, a message: until then you have an intention, not a fact. Nothing you have not seen return goes into a report — the user cannot see the work, so your account is its only witness, and an intention told as a fact is the one failure this design cannot absorb.

Workers in this mode do NOT emit the task's continuation block — you own the sequencing. The Next lines exist for the manual fallback.

Keep your own context small. You read task comments and gate results, not the workers' working history.

**A worker that fails** — it errors, dies, or comes back with work you cannot verify — is retried ONCE with a fresh worker on the same task. If the second one fails too, stop that branch and escalate with the six-field report; do not try a third time and do not finish the task yourself.

## The worker launch template

Send this, with the real names filled in. Nothing else: everything the worker needs beyond it, it reads from Octopad.

```
Deliver one Octopad task.
Task: <#N - title> · Organisation: <organisation> · Workspace: <workspace>
Model: <the task's saved model — set on you by this launch, never substituted>
Reasoning depth: <the task's saved depth> — requested, not enforced: this launch call
cannot set it. Run at it if you can; if you cannot, say so in your status line.
Work in: <its own branch inside a git worktree or equivalent isolated checkout>

Brief yourself from Octopad: start a session on the workspace, build context on the
task, and read the work stream's Decisions — they carry the delivery contract.
Read the target's own rule files (CLAUDE.md, AGENTS.md, or its equivalent) and treat
whatever they lock as a floor you cannot lower.

Your mandate: merge autonomy <setting> · challenge autonomy <setting>. One-way doors —
schema or migrations, permissions and auth, payments, deleting data, anything
irreversible — always stop for a person, whatever those dials say. Write to the user
in <their language>.

Do the one job the task describes. Run its Verify steps and paste the real output into
the task. Write your results, decisions and blockers onto the task before you answer.
If you had to write any wording a user will read, list each string on the task.
Do NOT close the task, do NOT start the next one, and IGNORE the task's Next line —
the supervisor owns sequencing. Answer with one line of status.
```

## Verification gate — before any task is closed

- **The task's Verify steps run for real, and their real output lands on the task.** Whoever runs them — the worker, or you when a step needs your access — the output is pasted into the task before the close. A claim that checks passed is not evidence. No output on the task, no close.
- **Honor the task's Review line.** When it says required, YOU spawn a separate fresh reviewer subagent — one that did not write the work — to attack the finished change against the real sources, worst problems first. The worker never spawns its own reviewer. Confirmed findings go back to a worker, get fixed, and are re-verified before the close.
- **Machine review always runs; human routing decides who ALSO clears it.** The contract's reviewer routing names the person for a class of task; that person's clearance is added on top of the fresh review, never instead of it.
- **One comment of yours on the task before it closes:** name the reviewer you spawned and what it returned, what the gate found, any retry it took, anything you decided along the way, and anything the job revealed about how this delivery is going. No comment, no close. The task is what a later session reads; a run whose record lives only in your chat is a run nobody can reconstruct, and nobody can improve.
- A dial can remove a human's waiting time. It can never remove a check.

If a Verify step turns out to be unrunnable, that is a blocker, not a licence to skip it.

## Delivering the work

- **One task, one branch.** The worker branches from the current base, does its job, and opens the change for review when the target's process uses pull requests. Follow the target's rules for how a change is named, described and checked; read them, do not assume them.
- **Merge dial set to "user validates":** the change waits. Report it, name who has to clear it, and move on to independent work.
- **Merge dial set to "mandate to land":** once every gate for that task has passed — checks green, fresh review clean, any routed human cleared it — land it and record that on the task. Still stop for anything on the one-way-door list.
- **Stacking on:** a dependent change branches off the open change it needs and targets it; when the base lands, retarget it to the main line. **Stacking off:** the dependent task waits for the base to land. Either way, **a base that moves under you is a replan trigger you own** — no worker will report it: re-read what every open change actually sits on, write the new landing order onto the stream, and run the skill's Replanning rules before sending the next task.
- **Wording a worker invented is new scope.** Where a later task is scoped to write or rewrite wording a user will read, no earlier task should have written any, so a worker that had to is reporting a miss in the plan, not a detail. Copy each string it recorded into that task's How before it launches, then run the per-task self-check on the task you changed. If that task has already started or closed, stop and run the skill's Replanning rules instead: a copy pass cannot settle text it never saw.
- Anything the contract did not forecast — a migration nobody expected, a permission change, a publish, a spend — expires the contract for that item. Stop it, report it, get the user's decision, update the contract Decisions, then continue.

## Running workers in parallel

Only for tasks the plan itself marked independent, never more of them at once than the plan marked, and each in its own isolated checkout so two workers never write the same file. Never in parallel: data migrations, shared generated artifacts, anything one sibling shapes for another. When in doubt, run them one at a time — sequential is the default, parallel is the exception.

## When the plan changes mid-delivery

A worker that discovers something the plan got wrong stops and reports it instead of improvising. You then run the skill's Replanning rules on the WHOLE plan — re-validate the affected specs, renumber, rewire the dependencies and Next lines, update the tracker — and resume the loop on the corrected order. A rebalanced task that falls outside the contract's forecast needs the user's re-confirmation before it runs. If the discovery breaks the stream's own logic, or the rebalance would rewrite more than a couple of tasks, stop: the stream needs a fresh planning pass, not a patch.

## When to stop, and how

Stop for a human when the contract's gate map says so, when a one-way door is next, when the challenge dial says consult, or when a problem survives the retry above. Then report in the user's language, in plain words per the skill's Non-negotiables, six fields, nothing else:

**State** — where the stream stands. **Done** — what is finished and proven. **Blocked** — what is stuck and why. **Decision expected** — the exact call you need from the user. **To unblock** — what has to happen, and by whom. **Next step** — what resumes the moment it clears.

Any field can be "none". Keep each to a line.

**A checkpoint blocks only its own branch.** Everything independent and safe keeps running while a person decides. Stop the whole stream only when nothing safe is left to do.

If the challenge dial says resolve autonomously, solve what is genuinely reversible and inside the plan, record what you did on the task, and report it afterwards. It never covers a one-way door.

## Recovery and handover

The state is Octopad: the contract Decisions, the recorded go, each task's status, and each task's latest comment. Nothing about this run lives anywhere else, which is what makes it survivable.

If this session dies, a fresh one resumes by invoking the skill on the stream: it sees the recorded go, comes straight back here, re-reads the contract Decisions, the open tasks and their latest comments, and picks the loop back up. Before resuming, check for work left half-done: a task in progress with no verification output on it is re-run, not assumed finished.

Handing over is also a deliberate move, not only what a crash forces. If your own context is running low, hand the rest of the stream to a fresh supervisor before your judgement thins, rather than pushing on and stalling in the middle of a task. Close out or park the task in flight with its state written on it, then give the user the supervisor handoff block from the skill's Continuation section. The recorded go carries over: the fresh session reads it as permission already given, so nothing is re-asked and nothing already settled is reopened.

## Closing the stream

The stream is done when its final validation task has passed its own checks, no task is left open, no gate is unanswered, and the tracker's ordering logic still matches what actually happened. End with the same six fields, reporting the finished state and anything still waiting on a person.
