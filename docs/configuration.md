# Configuration

HAAD is designed to be highly customizable. You can accept the default "Personas" provided by the tool, or you can tune them to fit your specific engineering culture.

All configuration resides in the `.haad/` directory of your project.

## 🎭 Customizing Agents (Prompts)

You can change *who* the agent is and *how* they think by editing their System Prompt.

**Location**: `.haad/config/agents/*.md`

**Example**:
If you want the **RA** (Research Agent) to be more risk-averse:
1.  Open `.haad/config/agents/RA.md`.
2.  Change the `Role` or `Objective` section:
    ```markdown
    # Role
    You are a Paranoiac Security Researcher.
    Your goal is to find why every library suggestion is a bad idea.
    ```

**Available Agents**:
-   `CIA.md`, `ISA.md`, `ICA.md`
-   `RA.md`, `PSTRA.md`
-   `HLASA.md`, `PRD.md`, `TPA.md`, `SPVA.md`
-   `TBA.md`, `TRA.md`, `EPVA.md`

## 📄 Customizing Outputs (Templates)

You can enforce specific formats for the artifacts by editing the Templates. The agents are instructed to strictly follow these structures.

**Location**: `.haad/data/[phase]/templates/*.md`

**Example**:
If you want the `PRD.md` to include a "Security Compliance" section:
1.  Open `.haad/data/spec/templates/PRD.md`.
2.  Add the section:
    ```markdown
    ## 6. Security Compliance
    - [ ] GDPR
    - [ ] SOC2
    ```

**Note**: Do not change the filenames of the templates, as the orchestrator scripts (`spec.sh`, etc.) look for specific paths.

## ⚙️ Orchestrator Logic

The state machine logic is defined in shell scripts. While you *can* edit them, it is recommended to stick to the Prompts and Templates for most customizations.

**Location**: `.haad/commands/*.sh`

-   `run.sh`: The master loop.
-   `brainstorm.sh`, `research.sh`, `spec.sh`, `plan.sh`: Phase-specific logic.
