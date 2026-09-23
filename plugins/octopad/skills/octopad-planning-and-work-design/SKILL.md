---
name: octopad-planning-and-work-design
description: How work is shaped and how a whole effort is laid out — the number of tasks a request really is, what each one must settle before anyone could run it, nesting, the scales, dates and repeating work, together with goals, streams, order and dependencies, and what an effort owes when it ends or changes shape. Use it when an ask arrives with its own boundaries still open, when several tasks are laid out together as a roadmap, a plan or a launch, when the user wants work already on the board cleared away, re-homed or put right, and when a stream or a goal has moved on from what its tracker still says.
---

Version: 1.0.0-public-r2 (first declared version; qualified source unchanged)

# Shaping the work

- Where a task's scope is ambiguous at its edge, write down what it does NOT cover; an unstated exclusion is how two people build the same half twice.
- Count the deliverables before you count tasks: a deliverable is something that could be shipped, reviewed or closed on its own, and the number of those is the number of top-level tasks — no more and no fewer.
- One reason licenses nesting: a single deliverable needs three or more steps, a step being a piece you would move to `in_progress` and to `done` by itself. Those steps become its subtasks, and nothing else earns a subtask.
- Never open a top-level task whose only job is to hold the others beneath it. An umbrella restates the stream and delivers nothing of its own.
- Steps taken one after another are flat all the same — build, then verify, then deploy, is three top-level tasks joined by dependencies and not three phases.
- A subtask may not fall due after the task above it.
- Join two deliverables only where one truly cannot start until the other lands; an edge added for tidiness serialises work that could have run side by side.
- Order is what dependencies carry, and priority says how much a thing matters within an order already settled. Reaching for priority to make something happen sooner is the sign that a dependency is missing.
- To hold sibling top-level tasks in a chosen order, add or reuse a preparation task and hang the others off it; never push a blocked sibling down the ranking by dropping its priority.
- Between two subtasks a dependency is optional and stands in for nothing at the level above: wire one only where that subtask genuinely blocks that other one, which is rare.

# The scales

- Priority is read inside one stream and never across streams: High (3) is urgent or holds up other work, Normal (2) is the default, Low (1) is worth doing with nothing waiting on it.
- Impact runs 1 to 5 — 5 serves the primary goal, 4 serves a secondary goal or clears the way for a 5, 3 keeps the stream healthy or unblocks something, 2 is a small improvement, 1 is cosmetic.
- Score every leaf, meaning any task with no subtasks, a top-level one included; a task that has subtasks takes its figure from them, so leave it unset there.
- The same holds inside one batch: a row that other rows in the call nest under is averaged from those rows and carries no impact of its own.
- A parent whose subtasks arrive in a LATER call is the exception — score it, since there is nothing yet to average, and it is recomputed once the children land.
- The AI score is computed for you. Never write one by hand.

# What a goal carries

- A goal names one destination the whole team shares, put as the place to reach ("Reach 50 active accounts") and never as an activity to perform; targets split per person do not move a team whose work is interlocked.
- Say in the goal's `description` how it will be judged: one to three signals, one of them primary, chosen so they can be read while the work runs and not only on the closing day. Where the route is known that is an outcome target — a measure with the threshold it has to reach.
- Where the work is new and the route is not known yet, take a learning signal — "document 3 methods that work" — in its place: a number fixed before anyone has walked the ground aims the team at the wrong thing.
- Both the reason and the date sit in the goal's own description, each on a line of its own, never only on a stream linked to it:
  `Why now: two enterprise pilots stalled on this gap last quarter.`
  `Deadline 2026-11-30 — renewal date of the affected contract.`
- Once every time-bound stream under a goal is complete, put closing it to the user: the close runs in one move, the tool walks through the post-mortem choices, and each close files a new post-mortem that supersedes the one before it.

# Which stream work belongs to

- Streams come in two kinds. An ongoing stream is an area of work that never finishes (`Frontend`, `Marketing`); a time-bound stream is one effort with an end state it can actually reach (`Frontend · Dark Mode`).
- Open a time-bound stream where the effort has an end state AND takes three or more tasks over more than one sitting.
- Choosing a task's stream: does it push a time-bound stream's goal forward? then that one. Is it ordinary work of a domain? then the ongoing one. Cannot tell? then ask.
- Settle that by reading each stream's description in the Strategy block. Names collide, and a keyword that looks like a match drops work into the wrong stream.
- Give a time-bound stream its goal — one primary, and up to two more beside it. Where nothing on the board fits, propose the goal that would.
- Work that advances a goal has no place in an ongoing stream: move it into a time-bound stream, or the goal's progress cannot be seen at all.
- Where one stream has to wait on another, record that with `depends_on_stream_ids`, and honour the order when you choose what to pick up next.
- Asked for work that repeats, create and route the repeating task itself. Standing up an ongoing stream is half the job — a stream is where the work sits, never the work itself.

# Laying out a plan

- A page that mirrors the task tree makes a second copy of the plan: it is then read in two places and goes stale as the work lands. Pages carry reference material that outlasts the effort, not a plan the tasks already hold.
- The default shape of an effort is flat — the stream, its top-level tasks, and the dependencies between them. The second licence to nest is a phase: an effort whose phases each hold three or more steps takes one parent per phase, and nothing else earns a parent.
- When a graph write — a create, a dependency, a change of page links — comes back naming sibling tasks that share the pages you linked, read their order and their gates again before moving on. What changed the plan changed its neighbours, not only the edge you came to add.

**Laying out a five-week launch.**

User: *"Lay out the launch — research, then design, then build, then ship — across the next five weeks."*

- Wrong: one `tasks(action:"create")` per task and `link_dependency` calls afterwards — seven round trips for a single plan, the exact pattern `batch_tasks` exists to collapse.
- Right: the stream first, then ONE `batch_tasks` call holding the entire graph.
  1. Open the time-bound stream "Launch Q2" with its `definition_of_success`, its goal, and a `target_date` of `2026-05-31`, which is the five-week horizon the user gave, set on the effort itself and never copied down onto its tasks.
  2. ONE `batch_tasks` call for the whole set, the stream given once as the call's default and `depends_on_refs` carrying the order inside it, and never a second pass of `link_dependency` calls over edges the same batch already carried.
- Why the nesting is right here: each of the four phases really does hold three or more steps. A flat effort — five fixes, a check, a deploy — stays top-level tasks joined by dependencies, with no umbrella and no phase parents.
- Why no date sits on a task here: the user gave a rough span, not four deadlines. That span became the effort's outer horizon and stopped there, and what carries the order between the tasks is `depends_on_refs`.

# When an effort ends or changes shape

- Archiving a task says two things at once: it no longer matters, and nobody is going to do it — dropped down the list, overtaken, or folded into another effort.
- Only a time-bound stream has a lifecycle, and it runs active, then completed, then archived. Completed keeps it in context and in search until its goal is reached; archived takes it out of context, so archiving ahead of the goal removes what the goal is still working from.
- **Trackers are system-managed, with two exceptions you append yourself.** Tracker pages live in the system Trackers / Archive folders and render read-only. The system owns the Progress Report and Activity Log — never hand-write those two sections. You append exactly two things: the `## Closing Report` before completing a stream, and the structural-change note below.
