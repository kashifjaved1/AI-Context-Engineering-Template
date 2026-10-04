# Prompt: Generate Comprehensive Tests

You are generating automated tests for a target module, class, or endpoint.

## Guidelines
1. Testing standard: [`context/guidelines/testing.md`](../../context/guidelines/testing.md)
2. Invariants: [`context/domain/invariants.md`](../../context/domain/invariants.md)

## Requirements
- Structure all tests using **Arrange / Act / Assert** (or Given / When / Then).
- Use the standard test naming convention: `should [expected result] when [condition]`.
- Cover both the happy path and critical edge cases (null inputs, boundary values, invalid states, rate limits).
- Verify invariant defenses (e.g. asserting tenant isolation errors or terminal immutability errors).
- Do not mock the unit under test. Mock only external system boundaries (network calls, third-party APIs).
- Ensure generated test code is deterministic (no unpinned clocks or random seeds).
