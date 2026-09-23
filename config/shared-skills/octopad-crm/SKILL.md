---
name: octopad-crm
description: How a workspace's CRM is read, written and kept true: customer contacts, companies and deals, their cards, briefs, entries and signals, who owns a value, what a connected AI may do for its member, outreach drafts and background agent runs, and how another system's records come in. Use in a workspace where the CRM is on, whenever a customer's record is looked up, written, searched or linked to work, when something that happened with a customer is recorded, when drafts, proposals or quarantined identities wait for a decision, and when records are imported or synced. Not for tracking competitors or market-wide customer voice.
---

Version: 1.0.0

# Before anything

- The CRM exists only in a workspace where it is switched on and the user is a member; `crm_status` says whether it is. Elsewhere the CRM tools refuse, and that refusal is the answer, not a fault to work around.
- Customer records live in the CRM, not in the workspace corpus: the workspace `search` does not index them. Find a record with `crm_search` or the record tools.
- Show people and companies by name. A UUID is for the next call, not for the user.
- **Two sets of tools.** Records, search, segments, pipeline stages, custom fields, company memberships and each record's working space (`crm_record`) are there in every CRM workspace. The tools for background agents (octobots) and what they feed are available only to some organizations: `crm_signals`, `crm_actions`, `crm_interventions`, `crm_source_sync`, `crm_outreach` and `crm_runs`. When one is missing, use the fallback this skill names, say once that the rest is not available to this organization, and never report the absence as an error.

# Reading a customer

- A contact has a card, its current summary: read it first, then the brief and recent entries. A company or a deal has no card: read its brief and latest hand-off. `build_context` in contact, company or opportunity mode returns these for one record or a batch.
- A campaign or a list is read in one batch call, never one record at a time.
- Say how fresh a contact's card is; a stale or missing card is reported as such, never passed off as current understanding.
- An empty result, a record you cannot reach and a partial batch failure are each stated plainly; none of them means the customer does not exist.

# Writing about a customer

Each kind of fact has one home; pick it on purpose.

- **Something that happened** (a reply, a meeting, an event in another system) is a signal, written in one batch with `crm_signals`. Without that tool, append an entry of type `activity` instead.
- **A note, a finding or a hand-off** is an entry, written with `crm_record` `append_entry`. Entries are never edited; a correction is a new entry. On a hand-off set `handoff_to` and name the person in the body.
- **What the team now understands about the customer, its strategy or the next action** is the brief, written with `crm_record` `upsert_brief`. Read it first and pass its revision so a colleague's edit is never overwritten; show a conflict to the user, never retry blindly. Change the brief only when that understanding really changed: routine events go to fields and signals.
- **A field on the record** is written with the record tools. An update replaces the whole `custom_fields` object and the whole tag list: resend every existing value with the change, or use `batch_update` with `custom_fields_mode: "merge"` where the tool offers it. A custom field must exist in the catalogue before a value lands in it. Removing a field from the catalogue erases its values by default: treat it as a deletion.
- A conclusion reached in this conversation that the team will need is written to the record before the conversation ends.

# Who owns a value

- A value a person entered or approved is theirs. Replace it only on your member's explicit instruction, and say whose value it replaces.
- When your evidence disagrees with such a value, say so and let a person decide; do not write over it.
- Your own confidence never authorizes a write. A placeholder, a guess or a vendor's filler value never becomes a record value.
- Fill an empty field or create a record when the user asks for it; do not enrich records on your own initiative.

# Acting for the user

- You act with your member's permissions and in their name. On their instruction you may approve or reject proposals and resolve quarantined identities with `crm_actions`. A rejection always carries its reason, so the same value is not proposed again. List what is pending before a bulk decision, and say what an approval does when it is not obvious: an approved scout batch adds every candidate in it.
- Archive a record only on explicit instruction. Permanent deletion needs the same confirmation a person would give in the app.
- Launch a background agent run with `crm_runs` only on the user's instruction. Runs can spend paid credits: rehearse with `dry_run`, and state the record cap before the real run.
- An outreach draft is approved, edited or rejected with a reason in `crm_outreach`. Sending stays a rehearsal until a workspace admin has made the workspace live; never change the sending configuration yourself, and before a send say whether it will really go out.
- A message sent through a separately authorized tool is recorded afterwards with `crm_interventions`, one phase at a time, for a contact, on the email, in-app or assistant channel, and never with the message body. A reply to a recorded intervention is its `responded` phase, which already writes the signal. A call or a message on another channel is a signal or an entry.
- When a create is refused because the organization reached its record allowance, tell the user where the allowance is raised. Never delete or archive records to make room.

# Linking customers to work

- An issue a customer raised becomes a task in the workspace that owns that work. Name the record in the task, and append an entry on the record that names the task, so each side leads to the other.
- Move the specific item across, never access: people on the task do not need the CRM, and customer data goes into the task only as far as the work needs it.
- A reply to the customer that comes out of that work stays for a person to approve before it goes out.

# Bringing records in from another system

- **A handful of records:** create or update them with the record tools; `batch_update` covers many at once. This route is always available.
- **A larger import or a system kept in step over time:** an organization owner or admin registers the source once with `crm_source_sync`, declaring the fields it owns. Create any custom fields it writes first: registering does not create them. Then send the full current state as a snapshot in parts; if a part is refused as too large, split it smaller. Sync with `dry_run` first and show the user the plan. A record left out of a snapshot counts as missing, and a missing record is reported, never archived or deleted. Pass `allow_large_drop` only after checking that the source really shrank.
- **A customer's own software pushing on its own schedule:** an organization owner or admin sets the connection up in the app, and its token is shown to them once. Never ask for a token in chat and never paste one anywhere.
- Each field has one owning source. When a source's value differs from a value a person set, the difference waits for a person's decision; tell the user where to decide it.
