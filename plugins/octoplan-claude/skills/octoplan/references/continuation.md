# Continuation — block formats and Next-line patterns

Load this before writing or rewiring any Next line (steps 5 and 7, and every rebalance), and before emitting any continuation or supervisor block (step 11, a handover, a recovery). The core rules — pointer never payload, settings line under every block, one relay per parallel group — are in SKILL.md; this file carries the exact formats.

## The task block

```
<work stream> #N - <task title>
Octopad · Organisation: <organisation> · Workspace: <workspace>
```

The first line is the readable label (sessions are named after it); write the stream's plain name, without the ` (octoplanned)` suffix. The second line is the address — workspace names repeat across organisations, so both are needed.

The user pastes a task's block into a fresh session, which briefs itself entirely from Octopad (`start_session` on the workspace, `build_context` on the task) and reads the stream's contract Decisions before it starts.

## The supervisor handoff block

Supervision changes hands with a block of its own, whether the planner hands it over at the delivery go, a running supervisor hands over the rest of the stream, or a dead session has to be replaced (the one exception is a running supervisor delegating to a subagent it spawns — no block, no paste; see Delegating the run in `references/supervision.md` — the block remains the path whenever a human launches the successor):

```
Octoplan <work stream>
Octopad · Organisation: <organisation> · Workspace: <workspace>
```

Same discipline as above. The session that receives it sees the recorded go and lands straight in supervision, so the user is never asked again for a decision they already made. Add a third line only for something true of the environment that Octopad cannot hold, such as which branch the chain stacks on. Anything Octopad can hold belongs in Octopad, not in the block.

## The settings line

Every block handed to the user in chat carries its launch settings: one plain line directly under the fence (outside it) naming the model and reasoning effort the new session should run at, and solo or parallel-safe. For a task block those come from that task's saved Exec line, which the emitting session reads in Octopad when it checks the task is ready; for a supervisor block, from the supervisor route recorded in the go Decision. The Next patterns below carry this instruction in their own words, because the session that emits a block from a Next line has never read this file.

## The Next-line patterns

A session learns to emit a block from ONE place: the **Next** line of the task it just finished. The planner writes that line as a verbatim instruction, using these patterns, with the real names filled in and `<block>` standing for the two-line task block above built for the named task:

- **Sequential** — successor is one executable task:
  `**Next:** #4 - <title>. When this task is fully done and verified, check in Octopad that #4 is still open and unclaimed and its dependencies are done, then end your reply with a fenced code block containing exactly: <block for #4>, and directly under the block one plain line quoting #4's Exec line (model · effort) plus the word solo — or parallel-safe if #4 belongs to a parallel group — so the user launches the session at the plan's route. If #4 is not ready, end instead with one line naming what it waits on.`
- **Human gate next** — successor is a human-only task:
  `**Next:** waits on "<human task title>" (owner: <name/role>). When this task is done, end your reply by stating in one line that the chain waits on that action, then give the user this block to paste once it is done: <block for the task after the gate>, with that task's Exec line (model · effort · solo, or parallel-safe if the plan marks it so) quoted on a plain line under the block.`
- **Parallel fan-out** — several independent siblings become ready at once:
  `**Next:** parallel group #2 + #3. When this task is done and both are confirmed ready in Octopad, emit one fenced code block PER sibling (<block for #2>, then <block for #3>), each with its task's Exec line (model · effort · parallel-safe) quoted on a plain line under its block — the user opens one fresh session per block; the siblings are safe to run at the same time.`
- **Inside a parallel group** — exactly ONE sibling is the **relay** (it carries the chain); the others are **terminal**:
  - Relay: `**Next:** #6 - <title>, after the whole group (#2, #3) is done. Relay: check in Octopad whether every sibling is done. If yes, emit the #6 continuation block with #6's Exec line (model · effort · solo, or parallel-safe if the plan marks #6 so) quoted on a plain line under it. If not, name what is still running and give the user the #6 block (same settings line) to paste once the group is done.`
  - Terminal: `**Next:** none — terminal branch; #3 carries the continuation.` (The finishing session ends with its wrap-up and NO continuation prompt, so the chain never forks.)
- **Terminal human gate** — the stream ends on a landing task nobody automated follows:
  `**Next:** none — the stream ends on "<landing task title>" (owner: <name/role>). End with the wrap-up and one line naming what that person still has to do.`
- **End of chain:** `**Next:** none — last task of the stream. End with the wrap-up only.`

Every pattern carries one more clause when the stream is delivered under a contract: `Before starting, read this work stream's Decisions in Octopad — they carry the delivery contract that governs this task.` Add it verbatim to the Next line of every task on a stream that has contract Decisions, so a session opened by hand works under the same mandate a worker would.

A Next line that points into another work stream (a multi-stream effort) works the same way: the block simply names that stream, and the organisation and workspace stay as they are.
