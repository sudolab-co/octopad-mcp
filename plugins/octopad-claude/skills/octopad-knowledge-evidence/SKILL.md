---
name: octopad-knowledge-evidence
description: Where the workspace's durable knowledge is written, and how a claim about it is proved. Use when decisions, facts, risks, advisories or open questions need recording, when the user hands over a file or a document to keep, when a page or a file is written, linked or tagged, when you need to know whether something is on record already, and to answer anything asked about the corpus.
---

# Where knowledge is written

Version: 1.0.0-public-r1 (local shared-contract candidate, not installed)

- Three branches hold durable workspace context — `knowledge`, `pages` and `files`. Retrieval reaches only the branch a thing went into, so the branch is chosen on purpose and never by habit.
- One fact, one choice and its reason, one open point, one threat: each of those is a single atomic item, written with `knowledge`.
- Reference that outlives the effort — how a system is built, what a piece of research found, what a meeting settled — is a page, written with `pages`.
- A file or a document the user hands over: offer, on the turn it arrives, to put it into `files` and to attach it to the task it belongs to; what stays in chat is gone once the session closes.
- When it is not obvious where a shared file belongs, work out its home first, and never advise the user to leave the original outside Octopad because the destination was unclear.
- An advisory, a security bulletin, a supplier's change of terms, a number you have just measured: each of those is written up on the turn it surfaces, not held back for the close.
- Wire what belongs together: a page or a file onto the task it informs, a page or a file onto the Key Information item it supports, one task onto another with the reason the dependency exists.
- Search the pages before you attach one, so what lands on the task is the best of them and not the first.
- Skip the search-and-link step where it cannot pay: a placeholder, a user who has declined it, input too thin to match anything (ask once), or a batch, where one search covers the whole topic.

# Tagging what you create

- Everything you create is tagged — a task, a page, a file, a Key Information item, a stream, a goal — so that someone who did not create it can still find it.
- Run the facets from broad to narrow and add a tag wherever a facet genuinely applies: first the product area or theme, then the feature or component, then the kind of work, its technology or its integration.
- A narrow tag never replaces the broad one; both stand, `frontend` as well as `date-picker`, because this vocabulary has no hierarchy.
- Stop as soon as the next tag would only echo one already there, repeat a structured field (its status, its assignee, its stream, its category), catch something incidental rather than the subject, or be so narrow that no second item could ever share it. There is no number to reach.
- Reuse a tag that already carries the meaning — list them with `manage_tags` when you are unsure — because a near-duplicate is minted without complaint and only an admin ever reconciles it.
- Mint a new tag only when nothing in the vocabulary fits: a tag forced onto an item is worse than a tag that did not exist yet.
- On a Key Information item, never tag what its `category` already says; tag what the item is about.

# Proving a claim about the corpus

- There is no one right way to read a corpus — all of it, its summaries, a search — so fit the method to what the claim has to hold up.
- **Building a complete set.**
  - Settle each doubtful item with one check aimed at that item alone: three doubtful items are three checks, neither a read of everything nor a shrug.
- **A claim about content** — whether a page still says X, whether Y appears at all — is settled by `search`ing the text and quoting the passages that match, never from the directory.
- **A compound question** — every page about X that mentions Y — takes the directory for X, a `search` for Y inside that set, and a full read reserved for the one item the search leaves undecided.
- **Quoting, rewriting or editing** — pull the whole page with `pages(action:"get")`, and only a page the steps above have already named; reading in full stands in neither for building the set nor for proving the claim.
- **Nothing found is not proof that nothing exists.** Widen the terms and try again, or open the candidates you did identify; only a search that has really been run over the text itself can rule anything out.
- Low confidence means the claim is not yet proven: sharpen the query, or open the one weak hit and settle it. It is not a licence to work through the pages one by one.
- Reuse what `build_context` returned without redundant retrieval, except when a consumed source must be revalidated after composition under its owner's freshness contract, or changed evidence makes that snapshot uncertain. Recheck the relevant internal identity, content and revision before the dependent write; this does not authorize a new external investigation or wider scope.

# When two sources disagree

- Say what the search turned up, and raise any clash with a decision already on record before you put a direction forward.
- When two sources conflict, check first that they are the same workspace, the same page, the same version and the same origin; then suspend only the point in dispute and leave standing everything else that is established.
