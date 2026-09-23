---
name: manage-activity-context
metadata:
  version: "5.0.0"
description: Maintain durable context about why an activity or project exists, whom it benefits, how it creates value and the choices and constraints shaping it. Use when that context is captured or changes, people or organizations join a project, or an Overview becomes stale. Adapts to solo exploration, collectives, associations, agencies, businesses and internal tools; no company or monetization required. Reuses existing onboarding documents.
---

# Purpose and boundaries

Answer: what are we trying to accomplish, for whom, through what activity, and under which durable choices and constraints? Do not turn a profile into a required organization type or maturity ladder.

Own durable activity context and the contextual Overview shell. Product behavior belongs to `manage-product-documentation`; customer/market positioning and commercial messaging to `manage-product-marketing`; external market evidence to `manage-market-intelligence`. Software needs product documentation whether sold, donated, experimental or used internally. Goals, streams and tasks retain execution state. Do not create commercial documentation merely because something is software.

Read [adaptation](references/adaptation.md) before any context, ownership or scope decision. For changes of participants, purpose, organization or use, also read [evolution](references/evolution.md). Whenever an existing Overview is involved, read [onboarding compatibility](references/onboarding-compatibility.md) before deciding whether or how to change it: its continuity and section-ownership rules apply after onboarding too, even when the request does not mention onboarding. Also read that resource when assessing deployment readiness. Reading this entrypoint does not replace reading these resources. They are decision aids, not forms to fill.

# Establish the minimum context

1. Interpret the request: discussion and audit are read-only; capture, refresh or synchronization permits only the requested mutations. State material scope assumptions. If several unrelated ideas fit, ask one routing question before writing.

   Before any write, distinguish these two branches:

   - Approved exact wording: derive the complete resulting content from the current page and the chosen operation before writing, including separators and whitespace; compare it with the approved result without unapproved normalization. If the operation's effect is unclear, resolve it before writing. Exact-wording approval alone does not authorize an added attribution. If necessary attribution is not already authorized and no authorized, supported metadata can carry it, do not write yet; show the minimal attribution and ask permission to include it. Do not invent a metadata field.
   - Authorized free drafting: include faithful, minimal provenance within the authorized scope and audience as part of the requested writing, without asking for another approval merely to include that provenance.

   Later repair never authorizes an earlier out-of-scope write.

2. Read the content of the existing Overview and relevant context owners, plus available onboarding facts, before deciding the change. A listing of page titles is not this read. Even a project-only update needs this check to distinguish an affected projection from an unrelated section; reading the Overview does not authorize changing it. Search before declaring an owner absent. Inaccessible is not absent. Reuse sufficiently clear facts; ask only about a gap that changes the next action.
3. Separate the actor, activity, project, built solution, beneficiaries and contribution to value. Distinguish funding from selling that solution. Identify only the relationships needed for this request; do not create a relationship registry.
4. Locate the authoritative section for each changed question. An existing Overview, charter, README or brief can own context. Preserve that owner's identity; a familiar page type is not a reason to duplicate it. Custom pages may be explicitly adopted for a named question after reading them; adoption is scoped, not automatic maintenance of all custom content.
5. Use the smallest adequate document. Keep directly captured context in the existing Overview if it remains clear and appropriately shared. Create a separate activity/project brief only when an independent durable question, audience, scope or growing detail warrants it. No compulsory Brief, empty skeleton, or new Overview alongside onboarding's page.

Before mutation, distinguish changed facts, affected projections, and unchanged pages. Write only the first two. A statement that another project remains unchanged is a preservation constraint, not a request to restate it in that project's page. Opening another skill to understand an interface does not expand the assignment: updating a solution's purpose alone does not require a product map or specification. Hand off product or commercial work only when an actual unresolved request needs that owner, not automatically when software or a sale is mentioned.

# Source and Overview contract

One durable question has one authoritative owner. Other sections may carry a short sourced projection; never create a competing authority. Roles are per section: an Overview may own directly elicited purpose and project a product description from its source. Do not label the whole page “owns no facts” if that would orphan onboarding facts.

An Overview remains a compact orientation, not a second corpus. Include only relevant identity/purpose, activities or solutions, beneficiaries and useful responsibility summaries. Funding or revenue appears only when known, relevant and safe to share. Do not invent customers, pricing, competition or revenue to complete headings. Follow any installed machine section contract; absent one, use clear stable headings, omit empty sections, and adapt human-facing vocabulary. Do not invent a numeric size limit: honor a supplied limit, otherwise keep summaries short and link detail.

Keep source links and freshness for projections. Before reporting a turn's changes recorded and verified, persist a short attribution for each new or changed fact in its authoritative document or supported source metadata. An omitted attribution may be repaired within the authorized change, then read back after the repair; it must not remain missing or ambiguous at successful closure. A source visible only in this conversation or an execution log is not durable document provenance. For a directly stated fact, wording such as “Source: user clarification in this session” is sufficient; use a date only when known and omit personal or client identifiers. Do not copy the conversation. A clarification made now must not inherit an old label saying it came from onboarding. Preserve the page's identity separately from the fact's provenance; do not invent a source page or verification date. If two purported owners disagree and authority cannot be established, preserve the uncertainty and ask about that point; do not settle it by choosing the newer-looking text. Replace a disputed projection with a short uncertainty statement and its source link, not an empty Overview.

The source owner maintains its authoritative content; the maintainer of a projected section refreshes that projection. For Overview sections without another explicitly established maintainer, activity-context maintains the projection only when the request authorizes that change. A source-owner handoff identifies the verified source and its returned revision, the affected page and section, the maintainer and the permitted audience. A handoff grants neither access nor mutation authority. Do not rewrite the source owner's conclusions or turn market evidence into adopted strategy.

Before refreshing a projection, read its source and destination and check scope, audience and mutation authority. Retain the identity, consumed content and returned revision of each internal source version used to compose it, including a source you have just updated. After composing and before each projection write, reread those sources and finish comparing all three elements with the versions used. The destination revision does not replace any source comparison.

If you perform the comparison yourself, first receive the reread results, then make a brief conclusion about identity, consumed content and revision observable before sending the mutation. No private reasoning or fixed wording is required. If one tool-execution cell both rereads and writes, its code must explicitly compare all three elements with the values used for composition and stop the mutation path on any difference or unusable result. Merely emitting the reread result does not perform the comparison.

If a source changed, recompose and revalidate from its current version before attempting the projection write; this is not a fresh external investigation. If source identity or authority remains uncertain, leave the projection open. Write only the affected section, with the destination revision read or an equivalent conditional guard exposed by the tool. Without an applicable guard, return the proposed change without writing. On conflict, reread and reconcile authorized changes, then retry once with the new revision. Never overwrite unrelated edits.

If authorization, access, a maintainer or a successful update is missing, leave the handoff open and identify the projection as not refreshed in the report. Do not claim its page contains a stale marker unless that separately authorized mutation was actually verified. A verified source and a pending projection are different outcomes; a handoff alone is not synchronization. Applying another skill does not expand the request or require another session or a new tracking task.

Before ending each turn with writes, read every modified page after its final write, including the owner and updated projections; an update response or a later turn's read is not this check. Check the returned content for the changed facts, their persisted attribution and the unaffected context; fix an omission within the authorized change and read back again. Only then report the result recorded and verified. If readback fails, report that the write succeeded but verification remains incomplete. A missing tool or failed write is a handoff or blocker, not a completed update.

# Scope, access and durable change

Context can concern a person, collective, organization, client, mission or project; relationships need not form a single tree. Infer the relevant scope from evidence, explain consequential assumptions, and clarify ambiguity before mutation. Platform scopes and permissions remain authoritative: if the needed separation is unavailable, report it rather than simulate privacy with titles.

Org-wide context must be safe for everyone who can read it. “Useful to everyone” does not authorize broader sharing. Participation, ownership, legal status and access are separate facts. Never infer invitations, permission changes, ownership transfers or publication authority from “we are a team now.” Propose scope changes with their visibility consequences; do not move, widen, narrow or archive material without the required explicit authorization.

Preserve project identity and sibling projects through evolution. A new participant, legal entity, paying customer or use case changes only the affected facts and relationships. It does not require restarting onboarding, rewriting the entire activity, or following a startup progression. Current established context belongs in the body; history belongs in available version records and linked Decisions. Preserve relevant earlier choices without silently overwriting history. Speculative directions remain visibly provisional; evidence of use is not a decision to adopt a strategy. Record consequential chosen direction through the available Decision workflow, or report that recording remains pending.

# Exclusions and preservation rules

- Financial models, budgets, runway, legal text, personnel records, operating procedures, internal policies, supplier details and support answers do not belong in these core context summaries. Link to authorized specialist or ordinary workspace owners; do not generate legal/financial artifacts here. A safe responsibility summary is not a copied member roster.
- A durable context constraint explains a meaningful boundary on choices. Detailed rules for how work is performed stay in their process owner; summarize only their contextual consequence when useful.
- No secrets, credentials, private filesystem paths, personal/customer identifiers or wholesale source copies. Persist the least safe evidence needed. Client material stays within its authorized audience, including during summarization.
- Imports are reviewed one page at a time. Propose destinations; move or archive only under the required approval, after readback confirms an adequate home. No bulk migration. Archived material is not current context.
- Other families' installed contracts are not silently changed by this candidate. See the compatibility reference before integration; it is not a drop-in rename of `manage-company-context`.

# Finish check

Did the change answer the actual question without inventing a business? Is ownership unambiguous by section? Were existing onboarding content, unrelated projects and access boundaries preserved? Are hypotheses distinct from established facts? Are affected projections current or explicitly stale? Report what was actually verified and the next necessary handoff, not a fictional completed workflow.
