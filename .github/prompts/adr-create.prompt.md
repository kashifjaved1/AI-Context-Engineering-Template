# Prompt: Create Architecture Decision Record (ADR)

You are drafting an Architecture Decision Record (ADR) based on a recent design decision, pull request, or technical proposal.

## Instructions
1. Review the ADR template: [`context/decisions/adr.template.md`](../../context/decisions/adr.template.md)
2. Review existing ADRs in [`context/decisions/`](../../context/decisions/) to determine the next sequential number (e.g., `0002`).
3. Analyze the provided context (feature description, design document, or diff).
4. Draft the new ADR adhering strictly to the template sections.

## Guidelines
- **Context & Problem**: Clearly explain what problem was solved and why the status quo was insufficient.
- **Considered Options**: Document at least 2 viable options that were evaluated.
- **Trade-offs**: Honestly state negative consequences and operational trade-offs of the chosen solution.
- **File Output**: Save the completed file to `context/decisions/{NUMBER}-{kebab-case-title}.md`.
