# Testing Guidelines & Verification Rules

> **Agent Instruction**: Every functional code change must be accompanied or verified by automated tests. Do not remove or weaken existing assertions to make a build pass.

---

## 1. The Testing Pyramid

```text
       /\
      /  \      E2E / Smoke Tests (Few, critical user paths)
     /----\
    /      \    Integration Tests (Service boundaries, DB queries, API contracts)
   /--------\
  /          \  Unit Tests (Fast, isolated business logic & domain invariants)
 /------------\
```

- **Unit Tests**: Test pure domain logic, calculations, validators, and state machines in complete memory isolation.
- **Integration Tests**: Verify interactions with databases, cache layers, external services, or middleware pipelines.
- **E2E / Smoke Tests**: High-value sanity checks for critical user journeys (e.g., authentication $\rightarrow$ creation $\rightarrow$ checkout).

---

## 2. Test Structure & Naming Conventions

Follow the **Given / When / Then** or **Arrange / Act / Assert** convention.

### Method Naming Pattern
`should [expected result] when [condition or state]`

### Concrete Example (Unit Test)
```typescript
describe("OrderCalculator", () => {
  it("should apply 10 percent discount when order total exceeds 100 dollars", () => {
    // Arrange (Given)
    const items = [
      { id: "item_1", unitPrice: 60, quantity: 2 } // Total: 120
    ];
    const discountPolicy = new TierDiscountPolicy();

    // Act (When)
    const calculation = OrderCalculator.calculate({ items, discountPolicy });

    // Assert (Then)
    expect(calculation.subtotal).toBe(120);
    expect(calculation.discountAmount).toBe(12);
    expect(calculation.finalTotal).toBe(108);
  });

  it("should throw InvalidDiscountException when discount percentage is negative", () => {
    // Arrange
    const invalidPercentage = -5;

    // Act & Assert
    expect(() => new TierDiscountPolicy(invalidPercentage)).toThrow(InvalidDiscountException);
  });
});
```

---

## 3. Mocking & Test Double Policies

1. **Mock at Architectural Boundaries, Not Internal Classes**:
   - Mock external HTTP services, payment gateways, and third-party SaaS APIs.
   - Prefer in-memory database instances or isolated test containers over deeply nested repository mocks.
2. **Never Test Mock Behavior**:
   - Tests should assert the behavior of the unit under test, not whether a mock method was called 3 times unless verifying side effects (e.g., email notification dispatch).
3. **Deterministic Test Data**:
   - Never use random generators that can cause flaky test failures (`Math.random()`, unseeded UUIDs in deterministic comparisons, unpinned system clocks).
   - Freeze time or use clock abstractions when testing date-sensitive logic.
