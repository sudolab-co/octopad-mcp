---
name: octopad-notepad
description: The full contract for the organization's Notepad — the org-wide page agents use as working memory between sessions. Load only when session orientation actually shows an org-wide Notepad page — before writing to it, when cleaning up or promoting its entries, or when the user asks what was in progress last time. When orientation shows no Notepad page this skill never applies — a session opening or a what-should-I-work-on question is not a trigger on its own.
---

Version: 1.0.1-public-r2 (first declared version; covers this skill)
Candidate status: local and unreleased

# Two blocks

The notepad is org-wide: one page for every workspace and every agent. It holds state only; these are the rules.

- `open_loops`: a thread you stopped before it ended. Each loop carries its own `next:`, the best known next step for THAT thread. There is no global focus pointer, because two agents working in parallel overwrite one.
- `premises`: what the user said they want, believe, or judged, for as long as it is neither a task nor knowledge. Each carries its `exit:`, the condition that ends it: it becomes work (name the task you created), or the user drops it. A premise with no exit condition is invalid. Whoever is in the conversation when a premise's subject comes up raises it, its author or not: the signature records who wrote an entry, it does not hand a duty to a session that has gone. A premise no conversation will ever touch was never one, and belongs in Octopad as an open Question.

There is no third block. What to work on next is the task tree, which Octopad already keeps and ranks; missing context you still need is a loop's `next:`.

# Writing

Write only what deserves to survive the conversation, in the matching block, at the moment you leave the thread. One trigger is **mandatory**: work with no trace anywhere else, done in a browser or an external tool, a verdict on a subject with no task, an intention voiced with no follow-up. If the session closes without you noting it, nothing remains anywhere. The rest is judgment: a fork, a blocker, an advance that changes a loop's `next:`.

- **Append, don't rewrite.** Adding an entry is safe; rewriting a whole block is last-writer-wins and erases other agents. Modify only your own entries; another agent's entry you verify and comment on, never rewrite.
- Re-read the current version before modifying (`expected_updated_at`). A refused write means someone got there first: re-read, then re-apply on the fresh state.
- One entry, one idea, brief. Octopad references (links, ids), never copies.
- **Sign every entry** you add or modify, on its last line: `by: <agent name and model> | session <your full session id> | <YYYY-MM-DD>`. The signature is the only trail this page leaves, and it is what makes any later review of it possible. An unsigned entry is marked `by: unknown` while you verify it, never deleted.

# Using it in conversation

- The session opens with no specific ask: offer the most relevant loop's `next:` in one sentence.
- The request touches an open loop or a premise: say so and connect it, instead of starting from zero.
- The user wants to know where things stood: give the loops, each checked against the live graph first. A pointer Octopad no longer matches is reported as stale, not repeated.

# Leaving

- Engaged work becomes a task; durable information becomes knowledge. The notepad keeps pointers and temporary state, and never duplicates a status, priority, owner, dependency, fact or decision Octopad already maintains.
- Promote the moment an item becomes one of those two: create the task or the knowledge entry per the methodology, name it in the notepad entry, then remove the entry. A recurring premise the user confirms as a working rule becomes knowledge; it does not squat here.
- Remove your own finished entries at your next write to the page, a closed loop or an exited premise, each carrying the reference to what replaced it. That is the cleanup with a named owner and a named moment; there is no other.
- Before adding a sixth loop, resolve the oldest first: promote it, or remove it with a one-line reason. A swelling notepad means engaged work went unpromoted.
- Never remove or rewrite another agent's entry. After verifying its reference in Octopad, append a signed one-line comment naming the original entry and its verified outcome; preserve the original entry intact.
