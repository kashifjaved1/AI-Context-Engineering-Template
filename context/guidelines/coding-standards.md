# Coding Standards & Best Practices

> **Agent Instruction**: Apply these patterns when creating, refactoring, or reviewing code.

---

## 1. Core Principles

1. **Explicit over Implicit**: Explicit dependencies, configurations, and type definitions prevent hidden runtime bugs.
2. **Fail Fast with Clear Diagnostics**: Validate arguments and preconditions at function and service entry boundaries.
3. **Immutability by Default**: Use `readonly`, `const`, and immutable data structures whenever possible.

---

## 2. Naming Conventions

| Element | Convention | Example |
| :--- | :--- | :--- |
| **Classes / Interfaces / Types** | PascalCase | `OrderProcessor`, `IUserRepository` |
| **Methods / Functions** | camelCase | `calculateTaxTotal()`, `validateSession()` |
| **Variables / Properties** | camelCase | `tenantId`, `retryCount` |
| **Constants / Enums** | UPPER_SNAKE_CASE | `MAX_RETRY_ATTEMPTS`, `DEFAULT_PAGE_SIZE` |
| **Files & Directories** | kebab-case | `order-processor.ts`, `auth-middleware.go` |

---

## 3. Error Handling Patterns

### Standard HTTP / API Errors (Problem Details RFC 7807)
All user-facing errors must follow the standard RFC 7807 format.

```json
{
  "type": "https://errors.example.com/not-found",
  "title": "Resource Not Found",
  "status": 404,
  "detail": "Workspace with ID 'wsp_9876' does not exist in tenant 'ten_acme'.",
  "instance": "/api/v1/workspaces/wsp_9876",
  "code": "WORKSPACE_NOT_FOUND"
}
```

### Try/Catch & Error Wrapping
Never silently swallow errors. Always wrap or log with contextual metadata.

#### ❌ Bad (Swallowed or Non-Descriptive Error):
```typescript
try {
  await db.save(order);
} catch (e) {
  // Silent fail or unhelpful log
  console.log("Error saving order");
  return null;
}
```

#### ✅ Good (Explicit Handling with Correlation & Domain Context):
```typescript
try {
  await db.save(order);
} catch (error) {
  logger.error("Failed to persist order", {
    orderId: order.id,
    tenantId: order.tenantId,
    error: error instanceof Error ? error.message : String(error)
  });
  throw new OrderPersistenceException(`Order ${order.id} could not be persisted`, { cause: error });
}
```

---

## 4. Asynchronous & Concurrency Discipline

- Always pass cancellation tokens or context timeouts to network, database, and background operations.
- Avoid unhandled promise rejections or thread-pool starvation.
- In distributed environments, ensure lock release in `finally` blocks.
