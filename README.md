# HAAD (Human-Assisted AI Developer)

HAAD is not a tool, it is a **methodology for agentic software development** so you dont need to say the words "vibe code". 

It challenges the current trend of "autonomous agents" that attempt to plan, execute, and debug in a chaotic, free-form loop. Instead, HAAD imposes a **strict, deterministic constraint system** that guides high-level AI models through a rigorous engineering process.

## 🧘 The Philosophy

**Structure > Autonomy**
AI models are powerful engines of logic and creativity, but they lack long-term coherence. When given "liberty of planning," they often hallucinate, lose context, or deviate from the goal.
The shit goes hard, we all know that.
HAAD is trying to solve this by **removing the burden of process** from the AI.
-   **The Process** is deterministic (Hardcoded State Machine).
-   **The Content** is probabilistic (AI Generation).

**Logic > Code**
Code generation should be done after the **Philosophy**, **Feasibility**, **Architecture**, and **Verification Strategy** are solidified. We validate the *mental model* before we commit to the *implementation details*.

---

## The Methodology

The HAAD method functions as a **Funnel of Abstraction**, moving from infinite possibilities to a single, verified implementation plan.

### Phase 1: The Abstract (Brainstorm)
*Objective: Crystallize the Intent.*
We do not ask "How do I build this?". We ask "What are we building and why?".
-   **Agents**: Analyze the vague user request, structure it into a coherent idea, and consolidate it into a core concept.
-   **Result**: A frozen Strategy and Concept.

### Phase 2: The Concrete (Research)
*Objective: Validate Feasibility.*
Before designing, we must know the constraints.
-   **Agents**: Research libraries, check technical limitations, and establish the "Technical Baseline".
-   **Result**: A proven Tech Stack and Feasibility Report.

### Phase 3: The Contract (Specification)
*Objective: Define the Boundaries.*
This is the heart of the methodology. We define **Contracts**—how parts talk to each other—not how they work internally.
-   **Agents**: Design the High-Level Architecture, define the PRD, and perform **Mental Verification Tasks** to validate the system flows logic *in the abstract*.
-   **Result**: A frozen Architecture and Test Plan.

### Phase 4: The Blueprint (Execution Planning)
*Objective: Atomic Decomposition.*
Only now do we think about code. We break the work into granular, developer-ready tasks.
-   **Agents**: Decomposition (TBA) -> Refinement (TRA) -> Validation (EPVA).
-   **Result**: A set of atomic, implementable Markdown files.

---

## 🛠️ The Tool (Implementation)

The HAAD CLI is the reference implementation of this methodology. It acts as the **Orchestrator**, enforcing the gates between phases and managing the artifacts.

### Installation

```bash
curl -fsSL https://raw.githubusercontent.com/rtfa1/haad/main/scripts/install.sh | sh
```

### Usage

All content used and downloaded will be stored in the `.haad/` in the current directory.

The CLI is junkie but works for generating all the artifacts. 

Read the code and try to understand how it works if you want to use it.

I just built it for me, and my helper was a AI... ¯\_(ツ)_/¯

```bash
# Start or Continue the Workflow
haad run
```

### Artifacts over Context
HAAD does not rely on a massive, fleeting context window. It relies on **Persistent Artifacts**.
-   Every thought process is saved to `data/`.
-   Agents read *files*, not chat history.
-   Human review is mandated via "Decisions Dashboards" (unless overridden).
* Current we are passing a lot of context to the agents, but this is not the final goal. For now its ok.
