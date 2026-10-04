# Domain Invariants & Business Rules

> **Agent Instruction**: These rules represent system-wide invariants. Any proposed code change that violates these invariants must be rejected or revised.

---

## 1. Multi-Tenancy Invariant

**Invariant Statement**:
Every read and write operation targeting customer data **MUST** include an explicit tenant scope constraint. Cross-tenant leakage is a critical security violation.

### Example in Data Queries

#### ❌ Incorrect (Implicit or Missing Tenant Filter):
```sql
-- DANGEROUS: If workspaceId is guessed or manipulated, another tenant's data leaks
SELECT * FROM workspaces WHERE id = 'wsp_1234';
```

#### ✅ Correct (Explicit Tenant Filtering):
```sql
-- SAFE: Enforces tenant isolation even if workspaceId is corrupted
SELECT * FROM workspaces WHERE id = 'wsp_1234' AND tenant_id = 'ten_acme';
```

---

## 2. Immutability of Terminal States

**Invariant Statement**:
Once an entity reaches a terminal state (`Completed`, `Failed`, `Cancelled`), its state, outputs, and financial/audit records become **immutable**.

- Any attempt to update fields of a terminal entity must throw a `DomainConflictException` (HTTP 409).
- Subsequent actions require creating a **new** version or a compensating transaction.

### Example Domain Check:
```typescript
class WorkflowRun {
  public complete(result: RunResult): void {
    if (this.isTerminal()) {
      throw new DomainConflictException(
        `Cannot complete run ${this.id}: current state is already ${this.status}`
      );
    }
    this.status = RunStatus.Completed;
    this.completedAt = new Date();
    this.result = result;
  }

  private isTerminal(): boolean {
    return [RunStatus.Completed, RunStatus.Failed, RunStatus.Cancelled].includes(this.status);
  }
}
```

---

## 3. Financial & Audit Ledger Invariants

**Invariant Statement**:
Financial totals, balances, and audit events must be **append-only**. Records are never updated in place or hard-deleted.

- Adjustments or corrections are recorded as compensating ledger entries.
- The system must be able to reconstruct the historical state at any point in time by replaying entries.
