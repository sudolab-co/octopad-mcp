# Manual continuation

Load this only when a human actually launches an executor or successor, or an existing manual Next instruction needs repair. Automatic delivery uses the selected runtime profile; supervised tasks do not need newly written Next lines. Existing valid Next lines remain readable and are ignored by supervised workers.

## Pointers and settings

A continuation is a pointer, never a payload. Persist facts, authority, pending effects and work state in Octopad before handing over. The receiving session reads current workspace/task context and the stream's Decisions; it does not infer authority or completion from the block. A block is not an active successor. Manual launch does not widen the mandate or require a duplicate go.

Task pointer:

```text
<work stream> #N - <task title>
Octopad · Organisation: <organisation> · Workspace: <workspace>
```

Supervisor pointer:

```text
Octoplan <work stream>
Octopad · Organisation: <organisation> · Workspace: <workspace>
```

Use the stream's plain name without ` (octoplanned)`. Retain these older Claude blocks unchanged when saved. Also accept existing Codex pointers:

```text
Use $octoplan to resume delivery of <work stream>.
Octopad: <organization> / <workspace>. Delivery authorization is recorded in the stream Decisions; do not ask for it again.
```

A third line may name an indispensable environment fact Octopad cannot hold, such as the branch the chain stacks on. Every block emitted to the user has one plain settings line immediately below its fence: exact saved model, effort, and `solo` or `parallel-safe`. Task settings come from its freshly read Exec line; supervisor settings come from the recorded supervisor route. Read only the actual runtime's profile when interpreting these settings. The receiver verifies readiness, ownership, authority and the predecessor's cessation before any work; a block offered before a gate clears is expressly for later use and cannot waive that gate.

## Next instructions for manual tasks

Write or update Next only where manual execution is actually used. The instruction is plain text in the existing task description, not another task or state system. Fill actual titles, addresses and settings from current Octopad records. It must say to read the stream's contract Decisions before starting and must match the dependency graph.

- **Sequential:** after verification, check the named successor is open, unclaimed and ready. Emit its two-line task block and saved settings. If not ready, name the written wait instead.
- **Human gate next:** name the action and its owner. Offer the next executable task's block and saved settings explicitly for use after that action is verified; the receiving session checks the gate again.
- **Parallel fan-out:** only after each named independent sibling is ready, emit one task block and settings line per sibling, marked `parallel-safe`. Shared write surfaces or one sibling shaping another's contract rule this out.
- **Inside a parallel group:** exactly one sibling carries the continuation and the others are terminal. That relay checks the whole group before offering the successor. If unfinished, name what remains and label its successor block for use only once the group is verified done. Terminal siblings name the relay and emit no block.
- **Terminal human gate:** give a wrap-up and the remaining action with its owner; no executable successor is implied.
- **End of chain:** wrap up without a continuation block.

Existing literal Next patterns are compatible if their readiness, gate, settings and single-relay constraints still hold. On replan, update only affected manual pointers. Never assign an executor another person's claimed task; record the conflict for reconciliation. A manually launched executor performs its task and required independent review within its recorded mandate, then follows its Next instruction. A manually launched supervisor owns sequencing after accepted takeover and uses the selected runtime's supported worker mechanisms; if those are unavailable, report the actual limit rather than silently acting as its own workers.
