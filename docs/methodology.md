# The HAAD Methodology

## 🧠 Philosophy

The fundamental insight of HAAD is that large language models (LLMs) are **probabilistic engines**. They excel at generating content, solving local logic puzzles, and synthesizing information. However, they struggle with **long-horizon planning** and **maintaining context** over days of work.

Traditional "autonomous agents" attempt to solve this by creating a loop where the LLM decides what to do next. This often leads to:
1.  **Rabbit Holes**: The agent gets stuck debugging a non-issue.
2.  **Context Drift**: The agent forgets the high-level goal while implementing a low-level function.
3.  **Infinite Loops**: The agent "thinks" it needs more information forever.

**HAAD flips this model.**
We do not ask the AI "What should we do next?". The **Human** dictates the process. The **AI** merely fills in the content.

---

## 🔻 The Funnel of Abstraction

HAAD treats software development as a funnel, moving from high-level abstraction to low-level implementation. You cannot skip a step.

### 1. Abstract Phase (Brainstorm)
*Input: Vague Idea | Output: Concrete Concept*

Most projects fail because they start coding too soon.
-   **Structure**: We force the AI to first inventory the existing code (CIA), then break down the user's vague request (ISA), and finally consolidate it into a single "Concept" (ICA).
-   **Artifact**: `DECISIONS.md`. We don't move forward until the *Idea* is approved.

### 2. Concrete Phase (Research)
*Input: Concept | Output: Feasibility & Stack*

Before designing, we must know what is possible.
-   **Structure**: The Research Agent (RA) investigates libraries and risks. The Pre-Spec Agent (PSTRA) selects the exact versions and patterns to use.
-   **Artifact**: A "Technical Baseline". We know *what* we can use, so we don't invent invalid solutions later.

### 3. Contract Phase (Specification)
*Input: Tech Stack | Output: System Architecture*

This is the most critical phase. We define **Contracts**.
-   **Structure**:
    -   **HLASA** defines the modules.
    -   **PRD** defines the requirements.
    -   **TPA** (Test Plan Agent) acts as the Architect. It does not write code; it writes **Mental Verification Tasks**. "If module A sends X, does module B crash?".
-   **Goal**: To validate the logic *before* a single line of code is written.

### 4. Blueprint Phase (Execution Planning)
*Input: Architecture | Output: Atomic Tasks*

Finally, we prepare the work.
-   **Structure**:
    -   **TBA** (Task Breakdown Agent) creates individual Markdown files for every granular task.
    -   **TRA** (Task Refinement Agent) reads these drafts and injects guidelines, best practices, and links to the Spec.
    -   **EPVA** checks that these tasks actually cover the Spec.
-   **Result**: A "lego kit" for the developer (or another agent) to simply assemble.

---

## 📄 Artifact-Driven Development

HAAD is **stateless**. The "state" of the project is entirely contained in the `data/` directory.

-   **Persistence**: If the tool crashes, nothing is lost. You just run `haad run` again.
-   **Transparency**: Every thought, decision, and plan is a file you can read and diff.
-   **Traceability**: Implementation tasks reference Spec files, which reference Research findings, which reference the original Brainstorm idea.

## 🤝 Human-in-the-Loop

The "Decisions Dashboard" is the firewall.
An AI agent can generate 100 pages of text in seconds. A human cannot verify that speed.
HAAD forces a **Pause** at the end of every phase. The AI says "I am done. Here is what I decided. Do you approve?".
This constraint ensures that errors are caught at the *Decision* level, not the *Bug* level.
