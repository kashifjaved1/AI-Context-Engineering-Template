# Domain Glossary (Ubiquitous Language)

> **Agent Instruction**: Use these terms consistently in code, variable naming, API schemas, documentation, and database fields. Do not invent synonyms for established domain concepts.

---

## 1. Core Domain Concepts

| Term | Definition | Code Representation Example | Synonyms to AVOID |
| :--- | :--- | :--- | :--- |
| **Tenant** | An isolated organizational account or customer workspace in a multi-tenant system. | `tenantId: string` (e.g., `"ten_acme"`) | Organization, Company, Account (when referring to the tenant container) |
| **Principal / User** | An authenticated individual or service account acting within a Tenant. | `principalId: string` / `userId: string` | Operator, Member, Actor |
| **Workspace** | A project or collaborative space owned by a Tenant. | `workspaceId: string` | Folder, Project, Team Space |
| **Artifact** | A persistent document, generated asset, or deliverable created during a workflow. | `artifactId: string`, `artifactType: string` | Output, Attachment, Document |
| **Workflow Run** | A single execution of an automated pipeline, job, or agent task. | `runId: string`, `status: RunStatus` | Job, Task Execution, Batch |
| **Policy** | A rule or permission boundary evaluated before an operation is permitted. | `policyId: string`, `evaluatePolicy()` | Guard, Constraint, Rule Check |

---

## 2. Status & State Transitions

### Lifecycle of a Workflow Run
```text
[Created] ──► [Queued] ──► [In_Progress] ──┬──► [Completed]
                                           ├──► [Failed]
                                           └──► [Cancelled]
```

- **`Created`**: The run definition exists in the database but is not yet eligible for worker pick-up.
- **`Queued`**: The run is published to the message broker and waiting for an available worker.
- **`In_Progress`**: A worker has acquired the lease and is actively processing the run.
- **`Completed`**: Terminal state. Successfully finished and outputs are persisted.
- **`Failed`**: Terminal state. Ended due to an error, retry limits exhausted.
- **`Cancelled`**: Terminal state. Aborted by user request or timeout.

---

## 3. Identifiers & Prefix Conventions

All primary identifiers must be prefixed with a distinct 3-to-4 letter namespace and use URL-safe unique IDs (e.g., UUIDv7, Nanoid, or CUID2).

| Entity | ID Prefix | Example ID |
| :--- | :--- | :--- |
| **Tenant** | `ten_` | `ten_01J9X987654` |
| **User** | `usr_` | `usr_01J9X987655` |
| **Workspace** | `wsp_` | `wsp_01J9X987656` |
| **Workflow Run** | `run_` | `run_01J9X987657` |
| **Artifact** | `art_` | `art_01J9X987658` |
