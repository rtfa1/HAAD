# The Agent Roster

HAAD orchestrates a team of specialized AI agents. Each agent has a specific **Persona**, **Role**, and distinct **Inputs/Outputs**.

## 🧠 Phase 1: Brainstorm Team

### CIA (Codebase Inventory Analysis)
-   **Persona**: Senior Systems Analyst.
-   **Role**: Analyze the existing codebase to understand the context.
-   **Input**: File tree listing and content of critical files.
-   **Output**: `01_CIA.md` - A summary of the current system state.

### ISA (Idea Structuring Analysis)
-   **Persona**: Product Strategist.
-   **Role**: Deconstruct the user's vague request into concrete goals.
-   **Input**: User's raw input + CIA Context.
-   **Output**: `02_ISA.md` - Structured goals and potential approaches.

### ICA (Idea Consolidation Analysis)
-   **Persona**: Visionary Product Owner.
-   **Role**: Synthesize the structured ideas into a single, cohesive concept.
-   **Input**: ISA Report.
-   **Output**: `03_ICA.md` - The "Concept" to be built.

---

## 📚 Phase 2: Research Team

### RA (Research Agent)
-   **Persona**: Principal Researcher.
-   **Role**: Investigate technical feasibility, libraries, and potential risks.
-   **Input**: The Concept (ICA).
-   **Output**: `01_RA.md` - Feasibility report and library options.

### PSTRA (Pre-Spec Technical Research Agent)
-   **Persona**: Technical Lead.
-   **Role**: Select the specific technology stack and patterns to be used.
-   **Input**: Feasibility Report (RA).
-   **Output**: `02_PSTRA.md` - The "Technical Baseline" (frozen stack).

---

## 📐 Phase 3: Specification Team

### HLASA (High-Level Architecture Spec Agent)
-   **Persona**: Chief Software Architect.
-   **Role**: Define the system modules, data flow, and contracts.
-   **Input**: Technical Baseline + Concept.
-   **Output**: `01_HLASA.md` - System architecture diagram and description.

### PRD (Product Requirements Definition Agent)
-   **Persona**: Product Manager.
-   **Role**: Define functional and non-functional requirements.
-   **Input**: Architecture (HLASA).
-   **Output**: `02_PRD.md` - Detailed requirements list.

### TPA (Test Plan Agent)
-   **Persona**: System Validation Architect.
-   **Role**: Define "Mental Verification Tasks" to validate contracts and flows (Contract-First Design).
-   **Input**: Architecture + PRD.
-   **Output**: 
    -   `03_TPA.md` (Raw Plan)
    -   `tasks/*.md` (Individual Validation Tasks)
    -   `tasks/TASK_INDEX.md` (Registry)

### SPVA (Spec Plan Validation Agent)
-   **Persona**: Lead QA Engineer (The "Skeptic").
-   **Role**: Validate that the Test Plan actually covers the Specs.
-   **Input**: PRD + TPA Tasks.
-   **Output**: `04_SPVA.md` - Pass/Fail report.

---

## 📝 Phase 4: Planning Team

### TBA (Task Breakdown Agent)
-   **Persona**: Technical Project Manager.
-   **Role**: Decompose the Spec into granular "Implementation Tasks".
-   **Input**: Spec Artifacts.
-   **Output**: 
    -   `01_TBA.md` (Breakdown Strategy)
    -   `plan/tasks/*.md` (Draft Implementation Tasks)
    -   `plan/tasks/TASK_INDEX.md` (Task Registry)

### TRA (Task Refinement Agent)
-   **Persona**: Documentation Specialist & Senior Engineer.
-   **Role**: Refine the draft tasks with guidelines, references, and best practices.
-   **Input**: Draft Tasks + Full Context.
-   **Output**: `02_TRA.md` (Report) + **Direct updates to task files**.

### EPVA (Execution Plan Validation Agent)
-   **Persona**: Engineering Manager.
-   **Role**: Final check to ensure the tasks implement the spec correctly.
-   **Input**: Refined Tasks + Spec.
-   **Output**: `03_EPVA.md` - Final "Green Light" for coding.
