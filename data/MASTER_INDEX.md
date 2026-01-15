# HAAD Master Data Index

This index maps the generated artifacts across the workflow, guiding agents to the correct context files.

## 1. Brainstorm Phase
**Directory**: `data/brainstorm/`
| File | Agent | Description |
| :--- | :--- | :--- |
| `01_CIA.md` | **CIA** | Codebase Inventory Analysis (Context) |
| `02_ISA.md` | **ISA** | Idea Structuring Analysis (Strategy) |
| `03_ICA.md` | **ICA** | Idea Consolidation Analysis (Final Concept) |
| `DECISIONS.md` | **N/A** | Phase Approval Dashboard |

## 2. Research Phase
**Directory**: `data/research/`
| File | Agent | Description |
| :--- | :--- | :--- |
| `01_RA.md` | **RA** | Research Analysis (Feasibility) |
| `02_PSTRA.md` | **PSTRA** | Pre-Spec Technical Research (Baseline) |
| `DECISIONS.md` | **N/A** | Phase Approval Dashboard |

## 3. Specification Phase
**Directory**: `data/spec/`
| File | Agent | Description |
| :--- | :--- | :--- |
| [01_HLASA.md](./01_HLASA.md) | **HLASA** | High-Level Architecture Spec |
| [02_PRD.md](./02_PRD.md) | **PRD** | Product Requirements Definition |
| [03_TPA.md](./03_TPA.md) | **TPA** | Test Plan (Raw Output) |
| [tasks/TASK_INDEX.md](./tasks/TASK_INDEX.md) | **TPA** | Generated Validation Tasks |
| [04_SPVA.md](./04_SPVA.md) | **SPVA** | Specification Plan Validation |
| `DECISIONS.md` | **N/A** | Phase Approval Dashboard |

## 4. Execution Planning Phase
**Directory**: `data/plan/`
| File | Agent | Description |
| :--- | :--- | :--- |
| `01_TBA.md` | **TBA** | Task Breakdown (Milestones) |
| `02_TRA.md` | **TRA** | Task Refinement (Detailed Tasks) |
| `03_EPVA.md` | **EPVA** | Execution Plan Validation |
| `DECISIONS.md` | **N/A** | Phase Approval Dashboard |

## Navigation Tips
- **Sequential Flow**: Brainstorm -> Research -> Spec -> Plan.
- **Dependencies**: Each phase consumes the final artifacts of the previous phase.
- **Approvals**: Check `DECISIONS.md` for `[x] APPROVED` status before proceeding.
