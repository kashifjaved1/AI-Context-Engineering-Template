# Service & Module Boundaries

> **Agent Instruction**: Refer to this guide before creating new endpoints, adding cross-module calls, or altering communication contracts.

---

## 1. Boundary Invariants

To keep the system modular and maintainable, components must respect clear communication boundaries:

1. **No Direct Database Sharing**:
   - Services do not query each other's tables directly.
   - Cross-domain queries must go through published APIs or asynchronous event synchronization.

2. **Ingress Validation**:
   - All external inputs (query params, request bodies, headers) must be validated at the ingress boundary before passing to domain services.
   - Never pass unvalidated external DTOs into domain entities or persistence layers.

3. **Explicit Data Transfer Objects (DTOs)**:
   - External API contracts $\neq$ Domain models $\neq$ Database persistence models.
   - Example mapping flow:
     ```text
     [External Request DTO]
             │ (Ingress Validator)
             ▼
     [Command / Domain Model]
             │ (Domain Handler / Logic)
             ▼
     [Database Entity / Model]
     ```

---

## 2. Ingress & Egress Guidelines

### Ingress (Receiving Requests)
- **Authentication**: Validated by gateway / middleware before reaching controllers.
- **Payload Limits**: Strictly enforced at gateway (e.g., maximum body size 10MB).
- **Error Responses**: Return standardized `ProblemDetails` (RFC 7807) objects. Never return raw stack traces or internal server error messages.

### Egress (Calling Downstream Dependencies)
- **Timeouts & Deadlines**: Always configure explicit timeouts (default: 5000ms) for external HTTP/gRPC requests.
- **Circuit Breaking & Retries**: Wrap external calls in retry policies with exponential backoff and jitter. Retries should only apply to transient (5xx, timeout) errors, never 4xx client errors.
- **Context Propagation**: Propagate `X-Correlation-ID` and trace context across all downstream calls.

---

## 3. Communication Patterns with Examples

### Synchronous (RPC / HTTP)
Use for interactive requests where the caller immediately awaits the result.
```typescript
// Example: Requesting customer profile from User Service
interface CustomerProfileRequest {
  tenantId: string;
  customerId: string;
}

interface CustomerProfileResponse {
  customerId: string;
  fullName: string;
  email: string;
  tier: "standard" | "premium";
}
```

### Asynchronous (Message Broker / Events)
Use for decoupling long-running processes, notifying other subsystems, or auditing.
```json
// Example: Integration Event Payload Schema
{
  "eventId": "evt_01J9X7Z8ABC",
  "eventType": "order.payment_completed",
  "timestamp": "2026-10-04T12:00:00Z",
  "correlationId": "corr_987654321",
  "tenantId": "tenant_42",
  "payload": {
    "orderId": "ord_1001",
    "amount": 149.99,
    "currency": "USD",
    "paymentMethod": "credit_card"
  }
}
```
