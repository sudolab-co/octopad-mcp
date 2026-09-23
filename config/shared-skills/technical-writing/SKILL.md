---
name: technical-writing
description: Use when writing, editing, or reviewing a technical work product in English or French. Covers README, technical or user documentation, PR descriptions, release notes, changelogs, in-app help, error messages, and API docs. Removes AI-flavored prose and applies the Google developer documentation style. Not for chat with the user, emails, social posts, or in-voice drafts, and not for blog or marketing content, which belongs to its own content skill.
---
Version: 2.0.0
Candidate status: local and unreleased

# Technical writing

Work products are read by people who were not in the conversation: users, reviewers, maintainers, and future contributors. They get professional documentation style, not chat style or a personal assistant's voice.

Base standard: the Google developer documentation style guide (https://developers.google.com/style). The distillation below is the working set; consult the guide when a case is not covered.

Apply these principles in English and French. The target language's grammar and established product terms win.

## Voice and grammar

- Second person ("you"), active voice, present tense. "The command creates a file", not "a file will be created".
- One term per concept, everywhere. Pick "workspace" or "project" and never alternate for variety.
- Define a term on first use if the reader may not know it. Write for the reader with the least context who still needs the document.
- Plain words for a global audience: no idioms, no Latin ("for example", not "e.g."; "that is", not "i.e.").
- Sentence case for headings. Task headings say the task: "Install the CLI", not "Installation".
- No em-dash, ever: recast with a comma, full stop, colon, or parentheses.

## Kill the AI flavor

- No filler: "please", "simply", "just", "easily", "note that", "in order to", "it's important to note".
- No hedging when you know: state the fact. Hedge only genuine uncertainty, and say why.
- No inflated vocabulary: "use" not "leverage" or "utilize", "check" not "delve into". Ban "seamless", "robust", "powerful", "comprehensive" unless measured.
- Prose explains; bullets list. Use bullets only for genuinely parallel items, never as a substitute for writing a paragraph. No bold-label-colon bullet walls.
- Do not praise the product or the reader. State what it does.

## Structure

- Before drafting, list the facts and literal identifiers the output must retain; check the finished text against that list.
- Lead with what the reader can do or must know. Context after, never before.
- Numbered steps: one action per step, in execution order. State the goal before step 1 and the expected result after the last step.
- A concrete example beats a paragraph of abstraction: show the command, the input, the output.
- Document the why, the constraints, and the failure modes. Skip what the interface already makes obvious.
- Timeless writing: no "currently", "new", "coming soon". Date what must be dated.
- Link text says where it goes ("the style guide"), never "click here".
- Images get alt text; never rely on color alone to carry meaning.

## Scope boundary

This skill governs work products only. Conversation follows the active user instructions. Emails, personal messages, social posts, blogs, and marketing content follow their owning skills. Where a repository's conventions or a delivery skill's format conflict (a changelog format or PR handoff template), those win; this skill governs only the sentences inside. It never chooses facts, document ownership, evidence state, or publication authority.

Preserve facts, audience, and evidence state. Retain required literal identifiers, user-facing error codes, counts, and units. When sources conflict, do not choose one, edit the disputed fact, or mark the conflict resolved. Preserve the conflict and return it to the fact owner or the user.
