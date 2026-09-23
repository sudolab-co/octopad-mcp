# Onboarding continuity and future deployment

## Current behavior: preserve, do not redesign

Creator onboarding already seeds or adopts Company Overview, adapts its wording to the creator, gathers useful profile facts, and stops profiling when enough is known to act. Reuse that page and its identity. Do not rename it proactively, duplicate it, require a Brief, repeat answered questions, or mark onboarding completed from a context update. Preserve its existing confirmation-before-write workflow when operating inside onboarding.

Directly elicited durable facts may remain authoritative in the Overview. Sourced sections remain projections. If existing content mixes current status and durable purpose, do not silently discard it or rewrite onboarding: propose the appropriate destination for transient status under existing platform rules. Onboarding facts and available records are input, not authority to broaden access.

The current questions, tutorial, kernel and production behavior are unchanged by this candidate.

## Alignment required when the documentation system and new kernel ship

Before deployment, compare the actual question text, answer storage, seeded document and consuming instructions. A document-only update is insufficient if the questionnaire still forces a company or if consumers treat direct Overview facts as disposable projections.

The future question design should elicit enough of the following to start useful work, only when missing:

| Needed understanding | Illustrative wording, not approved production copy | Intended destination |
|---|---|---|
| Scope and purpose | “Sur quoi veux-tu avancer ici, et à quoi cela doit servir ?” | Existing context owner; Overview if suitable. |
| Relevant relationships | “C'est pour toi, une équipe, ton activité ou un client ?” | Scoped context; platform handles access separately. |
| Role of a built solution | “Qui utilisera cet outil, et qu'est-ce qu'il permettra de faire ?” | Purpose here; functional detail in product documentation. |
| Economics, only if consequential | “Cet outil est-il vendu, utilisé en interne, ou les deux ?” | Relevant summary; commercial detail in its owner. |
| Known sources and constraints | “Qu'est-ce qui existe déjà et qu'il faut respecter ?” | Read authorized sources, retain durable constraints. |
| Uncertainty | “Qu'est-ce qui est décidé, et qu'est-ce que tu explores encore ?” | Distinct provisional context and explicit Decisions. |

Do not ask all of these routinely. The kernel should reuse known answers, explain consequential scope inferences, ask one blocking gap, and stop once the next useful action is supported. No exhaustive initial classification and no re-onboarding trigger for ordinary evolution.

## Integration gate: unresolved until package assembly

- Reconcile the new section-level authority model with all consumers of the former global “Overview owns no facts” rule. Preserve unique onboarding facts before any extraction.
- Resolve callers and catalogs using `manage-company-context`, including product documentation, marketing, market intelligence and shared-family rules. Choose one canonical owner; no concurrent competing old/new contract. Do not install this directory as a compatibility alias.
- Assign shared invariants explicitly in the new kernel/package: source ownership, evidence/Decision distinction, organic page creation, archival treatment, scope/privacy, source minimization and verified writes. Preserve these protections when relocating them; avoid relying on this local candidate to override installed skills.
- Verify actual section identifiers, projection provenance/freshness and size constraints with the assembler. Human headings may adapt without breaking its machine contract.
- Align Key Facts, Overview and execution records so each fact has an owner and changes do not leave contradictory context. Define any migration explicitly; no bulk absorption or silent overwrite.
- Check existing partially onboarded workspaces as well as new ones. Preserve page IDs, prior answers, permissions and task progress.
- Run package-level onboarding/evolution integration tests after the question and kernel changes are approved. Local fixture tests do not prove production permissions, onboarding lifecycle or automated assembly.

Deployment acceptance includes: solo with several ideas; noncommercial collective; association; agency with separated clients; business with an internal ERP; internal-plus-external use; and evolution without onboarding restart. These are counterexamples to expose assumptions, not selectable persona templates.
