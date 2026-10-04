# System Architecture Overview

> **Agent Instruction**: Read this document first when onboarding to the project or planning changes that span multiple modules or services.

## 1. System Mission & Context

This system is designed as a modular service-oriented application. The high-level objective of the system is to provide reliable, scalable, and observable domain operations.

### High-Level Topology

```mermaid
graph TD
    Client["Client / Web UI / Mobile App"] -->|"HTTPS / JSON"| Gateway["API Gateway / Ingress Router"]
    
    subgraph CorePlatform["Core Application Estate"]
        Gateway -->|"Routed Requests"| CoreService["Core Business Service"]
        Gateway -->|"Auth Verification"| AuthService["Identity & Auth Service"]
        
        CoreService -->|"Publishes Events"| MessageBroker["Message Broker (RabbitMQ / Kafka / Redis)"]
        MessageBroker -->|"Consumes Events"| WorkerService["Async Background Worker"]
    end
    
    subgraph DataStorage["Data Persistence"]
        CoreService -->|"Reads / Writes"| PrimaryDB[("Primary Database (PostgreSQL / MySQL / SQL Server)")]
        CoreService -->|"Cache / Ephemeral"| CacheStore[("Cache Layer (Redis)")]
        WorkerService -->|"Reads / Writes"| PrimaryDB
    end

    subgraph Observability["Telemetry & Diagnostics"]
        CoreService -.->|"Traces & Metrics"| OTelCollector["OpenTelemetry Collector / APM"]
        WorkerService -.->|"Structured Logs"| LogStore["Log Aggregator (Loki / ELK)"]
    end
```

---

## 2. Component Directory & Responsibilities

| Component | Responsibility | Technology Stack / Patterns | Context Link |
| :--- | :--- | :--- | :--- |
| **API Gateway** | Request routing, rate-limiting, SSL termination, and client token inspection. | Reverse Proxy / Gateway | [`context/architecture/boundaries.md`](./boundaries.md) |
| **Identity / Auth** | User authentication, token issuance, permission resolution, and session management. | JWT / OIDC / OAuth2 | [`context/guidelines/security.md`](../guidelines/security.md) |
| **Core Service** | Core business domain logic, workflows, transactional data storage. | REST / gRPC, Domain-Driven Design | [`context/domain/invariants.md`](../domain/invariants.md) |
| **Async Worker** | Background jobs, long-running processes, email dispatch, data synchronization. | Queue Consumer, Idempotent Processing | [`context/guidelines/coding-standards.md`](../guidelines/coding-standards.md) |
| **Database** | Relational source of truth, schema migrations, transactional guarantees. | Relational DB + Migration Engine | [`context/domain/glossary.md`](../domain/glossary.md) |

---

## 3. Core Data Flow Example

### Example: Processing a User Order / Domain Action

```mermaid
sequenceDiagram
    autonumber
    actor User as Client
    participant GW as API Gateway
    participant Auth as Identity Service
    participant API as Core Service
    participant DB as Primary Database
    participant Bus as Message Broker
    participant Worker as Background Worker

    User->>GW: POST /api/v1/orders (Bearer Token)
    GW->>Auth: Validate Token & Claims
    Auth-->>GW: Token Valid (TenantId: T-100, UserId: U-42)
    GW->>API: Forward Request with Scoped Headers
    
    API->>API: Validate Request Payload & Invariants
    API->>DB: Save Order Record (Pending Status)
    API->>Bus: Publish OrderCreatedEvent
    API-->>User: 202 Accepted (Order ID: ord_9876)

    Bus->>Worker: Consume OrderCreatedEvent
    Worker->>Worker: Process Notifications / Async Tasks
    Worker->>DB: Update Order Status (Processed)
```

---

## 4. Key Architectural Patterns

1. **Explicit Scoping**:
   - Every request and event carries tenant, user, and correlation context.
   - Cross-tenant data leakage is strictly forbidden.

2. **Idempotency & Safe Retries**:
   - Background event processing must be idempotent.
   - Use idempotency keys or unique event IDs to prevent duplicate processing.

3. **Separation of Contracts**:
   - API request/response DTOs must remain decoupled from internal database entities.
   - Changes to public API contracts must be versioned and backward-compatible.
