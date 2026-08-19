# Supervised delivery

Load this after the user's delivery go on a finished plan, or when resuming a stream whose recorded go still stands. From here on this session is the **supervisor**: it does not write the deliverables, it sequences the plan, sends each task to a fresh worker, checks the proof that comes back, and stops where the contract says a person decides.

## The mandate comes from Octopad

Re-read the delivery contract's Decisions on the stream before the first task and after any interruption: the two dials, the reviewer routing, the stacking choice, the gate map, and the recorded go. Those Decisions are the mandate. Nothing agreed only in the chat counts, and nothing remembered from the planning conversation counts either — if it matters and it is not recorded, ask again and record it. A go that exists only as a clause inside another Decision is not the recorded go: look for it as its own Decision, and if it is not there, there is none — ask.

The target's own rule files stay the floor. Where they and the dials disagree, the rule files win.

## The delivery report — one page, updated in place

Before the first task (or on resume, when none exists yet), create ONE page on the stream named `Delivery report — <stream>`. It opens with the phase map — the delivery steps in order, each phase's tasks under it with their titles in plain words, and every step a person performs in bold with its owner — followed by one state line per task and an open "needs you" list. On a stream of three or four tasks the phase map and the state lines are the same short list; keep it to that rather than inventing phases. This page is what the user follows for the whole run: the aggregate of everything worth reporting, centralized so nothing gets lost in chat. It is written for the user, so the skill's Plain words rule applies to it.

**The report is a view, never the record.** It holds no fact the task graph does not; Octopad's task states and comments are what a resuming session reads, and where the two disagree the tasks win. On resume, rebuild the state lines from the tasks before showing the page to anyone. Update it in place at every event: edit the existing lines, never append a fresh narrative under stale text — each edit follows a fact you just verified or an agent's return you just read. States use one vocabulary, never a bare "done": **built → reviewed → merged → applied → verified** for code, or the domain's equivalent (drafted → reviewed → approved → published). A replan rewrites the phase map in place, per the skill's Replanning rules.

## The loop

Repeat until the stream is done or nothing is left that the mandate lets you touch:

1. **Pick.** Take the next task Octopad reports as ready — dependencies done, nobody else's assignment, not blocked. **The graph is the only judge of waiting: ready means work it now.** Never add a wait of your own on top of what Octopad reports — dependent code sitting on an unmerged branch is the stacking rule's normal case (see Delivering the work), not a reason to hold the task; the real waits all have a written source, as a dependency edge not yet done, a human-only task, a gate in the contract, or the contract's stacking choice set to wait for the base to land. One exception you resolve at pick time: a ready task whose Preconditions name a state that is not live yet and that only a person can make true (a migration applied, a deploy) is a plan defect — the planner should have wired that wait as a human-only task with an edge; wire it now, per Replanning, and proceed on whatever is actually ready. A task whose What carries "Octoplan flesh-out required" is a placeholder: never send it to a worker, stop and tell the user it needs a planning pass first. Otherwise set the task in progress.
2. **Send.** Launch a fresh worker subagent with the template below. One task per worker, always.
3. **Collect.** The worker does the one job, writes what it did, what it decided and anything it hit onto the task, and returns a one-line status. Treat the one-liner as a signal only: the task is the record.
4. **Check.** Run the verification gate below. Only then close the task.
5. **Report.** Update the delivery report, then post to the user at most one plain line per event since the last report — even under a full merge mandate; silence is not a progress report. Name the state, never a bare "done": built, reviewed, merged, applied, verified. No inner monologue: what was verified, not how you reasoned about it. One thing never compresses: a call you made that the user could reasonably disagree with — a finding you dismissed, an item you decided was yours or theirs, a deviation from the plan — gets its own line in chat when you make it. Review findings live on the task — the top one may get one line in chat, never a narration. Every blocker you name says what it stops and what keeps moving. A standing blocker is named once, then lives on the report; repeat it in chat only when its state changes or it comes to block everything. When you repeat a task's precondition, carry its reason. When you hand a person a task, say the task already holds everything they need and name where it sits — an instruction with no pointer reads as work dumped on them.
6. **Advance.** Move to the next ready task, or stop at a gate.

**Say a thing exists only once the call that created it has returned, and name what came back.** A reviewer, a worker, a task, a Decision, a message: until then you have an intention, not a fact. Nothing you have not seen return goes into a report — the user cannot see the work, so your account is its only witness, and an intention told as a fact is the one failure this design cannot absorb.

Workers in this mode do NOT emit the task's continuation block — you own the sequencing. The Next lines exist for the manual fallback.

Keep your own context small. You read task comments and gate results, not the workers' working history.

**A worker that fails is retried by failure class.** A worker that RETURNED work you cannot verify is retried ONCE with a fresh worker; if the second also returns unverifiable work, stop that branch and escalate with the six-field report — never finish the task yourself, whatever the dials say. A worker that NEVER RETURNED — an error, a stall, a killed session — is an environment signal, not a task signal: say so in one line, retry once more with the run reduced (one worker at a time, orientation tight), and escalate only if a third dies. A user-directed attempt is one attempt, not a standing licence.

## The worker launch template

**Dispatch by lane where lanes exist.** When the environment defines one agent per rubric lane (an agent definition pinning model and reasoning depth together, e.g. under `.claude/agents/` — a one-time team setup; check for them before the first task), launch the worker or reviewer AS the lane agent matching its saved route — model and depth are then both enforced by the definition, and the template's depth line reads `pinned by your lane definition`. Where no lanes exist, or a saved route has no matching lane, pass the model on the launch call, keep the template's request wording (`requested, not enforced: this launch call cannot set it — run at it if you can; if you cannot, say so in your status line`), and say once at the start of the run, not per task, that depth is then a request nothing verifies.

Send this, with the real names filled in. Nothing else: everything the worker needs beyond it, it reads from Octopad.

```
Deliver one Octopad task.
Task: <#N - title> · Organisation: <organisation> · Workspace: <workspace>
Model: <the task's saved model — set by this launch or your lane, never substituted>
Reasoning depth: <the task's saved depth> — <how it is set: one of the two exact
phrasings from the lane paragraph above this template>
Work in: <its own branch inside a git worktree or equivalent isolated checkout>

Brief yourself from Octopad: start a session on the workspace, build context on the
task, and read the work stream's Decisions — they carry the delivery contract. Keep
orientation tight: brief yourself, then start.
Read the target's own rule files (CLAUDE.md, AGENTS.md, or its equivalent) and treat
whatever they lock as a floor you cannot lower.

The task's How and the stream's Decisions were written before the work existed and may
be wrong. Verify any factual claim your work depends on at the source, wherever it came
from; if one is false, stop and report it on the task rather than build on it.

Your mandate: merge autonomy <setting> · challenge autonomy <setting>. One-way doors —
schema or migrations, permissions and auth, payments, deleting data, anything
irreversible — always stop for a person, whatever those dials say. Write to the user
in <their language>.

Do the one job the task describes. Run its Verify steps and paste the real output into
the task. If you wrote or changed a test, prove it can fail: in a scratch checkout,
remove the production path it guards, show the suite red, restore, show it green, and
paste both runs. Write your findings, decisions and blockers onto the task
INCREMENTALLY as you establish them — never one write at the end; a session that dies
mid-task must not take its findings with it. Your final write restates the task's state
in full, so a later session can read it alone.
If you had to write any wording a user will read, list each string on the task.
Do NOT spawn reviewers or review agents — the supervisor owns the review gate.
Do NOT close the task, do NOT start the next one, and IGNORE the task's Next line —
the supervisor owns sequencing. Answer with one line of status.
```

## Verification gate — before any task is closed

- **The task's Verify steps run for real, and their real output lands on the task.** Whoever runs them — the worker, or you when a step needs your access — the output is pasted into the task before the close. A claim that checks passed is not evidence. No output on the task, no close. One deliberately failing run is expected where the Verify slot carries the call-site proof: read the pair, not the last output. Where the change touched a production path and the task's Verify slot carries no call-site proof, add one before you close — a suite green with the real path removed is not evidence, whatever the plan asked for.
- **Honor the task's Review line.** When it says required, YOU spawn the reviewer subagents — fresh, none of them the author of the work, each at the Review line's route, by lane where lanes exist — to attack the finished change against the real sources, worst problems first. Run the lenses the Review line names, per the skill's Review section; you may add one, and drop one only for a re-review narrower than the round before, naming which and why on the task. The worker never spawns its own reviewer. Confirmed findings go back to a worker, get fixed, and are re-verified before the close.
- **Every finding gets a disposition before the next round.** The fix instruction lists every finding from the round — blocking or not — each marked fix now, defer with its reason, or dismiss with the evidence; the re-review prompt lists whatever was deferred, and a finding still deferred when the task closes is named in the closing comment with who owns it next. A finding left off the list is how a known defect crosses a round unfixed and comes back blocking.
- **Read the dependencies' deferrals before the close.** Check the specs of the tasks this one depends on for any deferral naming it ("X is handled by this task"); an unhonoured deferral is a blocking finding here, not the next task's problem.
- **Machine review always runs; human routing decides who ALSO clears it.** The contract's reviewer routing names the person for a class of task; that person's clearance is added on top of the fresh review, never instead of it.
- **One comment of yours on the task before it closes:** name the reviewer you spawned and what it returned, what the gate found, any retry it took, anything you decided along the way, and anything the job revealed about how this delivery is going. Size it to Octopad's comment limit; detail that will not fit goes on a page linked to the task — never into the task description, which is the plan's spec — not a second try at the same comment. Also record any outward notification you sent or deliberately skipped (a review handoff, a message to the person the routing names), and read that record before sending or skipping one — supervision changes hands, and a duplicate handoff and a missing one both cost. No comment, no close. The task is what a later session reads; a run whose record lives only in your chat is a run nobody can reconstruct, and nobody can improve.
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

Before telling the user that nothing can proceed, walk the open tasks and name, per task, the written source of its wait — a dependency edge not yet done, a human-only task, a gate, the stacking choice set to wait. A wait that exists nowhere but in your own reasoning is not a blocker: it is either work (a ready task, sent to a worker now) or a plan defect (a real-world wait the graph never carried — wire it, per Replanning). A stream that idles while ready tasks sit on the board is the supervisor failing, not the stream waiting.

**A checkpoint blocks only its own branch.** Everything independent and safe keeps running while a person decides. Stop the whole stream only when nothing safe is left to do.

**Verify before you escalate.** Before naming an item as a person's, verify the claim that makes it human-only against the live environment, this session — a claim inherited from a task description, a worker comment, or a prior session's report is not evidence, and a false one hands the user work an agent could do. If the claim is false, do not work a human-only task yourself: report it as a plan defect and run the skill's Replanning rules to re-spec it as executable. A reversible action inside the plan is done, then reported — never reported as a risk for someone else to do. This never widens the gate map, the one-way-door list, or anything the target's own rule files reserve for a person: those stop for their named human even when you could technically do the work.

If the challenge dial says resolve autonomously, solve what is genuinely reversible and inside the plan, record what you did on the task, and report it afterwards. It never covers a one-way door.

## Recovery and handover

The state is Octopad: the contract Decisions, the recorded go, each task's status, and each task's comments. Nothing about this run lives ONLY anywhere else, which is what makes it survivable — the delivery report is a view rebuilt from this state, never a source of it.

If this session dies, a fresh one resumes by invoking the skill on the stream: it sees the recorded go, comes straight back here, re-reads the contract Decisions, the open tasks and their comments, rebuilds the delivery report's state lines from them, and picks the loop back up. Before resuming, check for work left half-done: a task in progress with no verification output on it is re-run, not assumed finished.

Handing over is also a deliberate move, not only what a crash forces. If your own context is running low, hand the rest of the stream to a fresh supervisor before your judgement thins, rather than pushing on and stalling in the middle of a task. It is YOUR decision — your own lifecycle, not a stream problem, so the challenge dial does not reach it: announce it with the block ready to paste, never pose it as a question, because asking hands the user a call this file already makes. Time it at a task boundary so nothing idles: close out or park the task in flight with its state written on it, then give the user the supervisor handoff block from the skill's Continuation section, with its settings line. The recorded go carries over: the fresh session reads it as permission already given, so nothing is re-asked and nothing already settled is reopened.

## Closing the stream

The stream is done when its final validation task has passed its own checks, no task is left open, no gate is unanswered, and the tracker's ordering logic still matches what actually happened. End with the same six fields, reporting the finished state and anything still waiting on a person.
