# Prompt: Generate Feature Specification

You are generating a formal Feature Specification from user requirements or product requests.

## Inputs
- User request, problem description, or issue ticket.
- System overview: [`context/architecture/overview.md`](../../context/architecture/overview.md)
- Domain glossary: [`context/domain/glossary.md`](../../context/domain/glossary.md)
- Domain invariants: [`context/domain/invariants.md`](../../context/domain/invariants.md)

## Instructions
1. Review [`context/specs/spec.template.md`](../../context/specs/spec.template.md).
2. Deconstruct the user request into clear problem statements, user stories, and acceptance criteria.
3. Explicitly define what is **In Scope** and what is **Out of Scope** to prevent scope creep.
4. Define testable Given/When/Then acceptance scenarios.
5. Identify API endpoints, payload schemas, and database schema impacts.
6. Verify against domain invariants.
7. Output the specification in Markdown format ready to be placed in `context/specs/{feature-id}/spec.md`.
