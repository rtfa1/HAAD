# CLI Reference

The HAAD CLI is the orchestrator for the Agentic Methodology. It manages the state, executes agents, and enforces the gates between phases.

## 📦 Installation

To install HAAD into your current project workspace:

```bash
# From the root of the haad repository (or via curl)
./scripts/install.sh
```

This creates a hidden `.haad` directory in your project root. It **does not** touch your global system paths.

## 🚀 Usage

The CLI follows the format:
`haad [command] [options]`

### Core Commands

#### `run`
**The Master Orchestrator.**
Checks the current state of artifacts in `data/` and launches the appropriate Phase.

```bash
haad run
```

**Options:**
-   `--auto-approve`: Automatically approves all "Decisions Dashboards" (`DECISIONS.md`). Use this for fully autonomous runs (e.g., CI/CD or testing), but use with caution.

#### `reset`
**The Nuclear Option.**
Clears all generated data (`data/brainstorm`, `research`, `spec`, `plan`) to allow a fresh start.
It **preserves** your templates and configuration.

```bash
haad reset
```

### Phase Helper Commands
You can run specific phases individually, though `run` is preferred.

-   `haad brainstorm`: Runs CIA -> ISA -> ICA.
-   `haad research`: Runs RA -> PSTRA.
-   `haad spec`: Runs HLASA -> PRD -> TPA -> SPVA.
-   `haad plan`: Runs TBA -> TRA -> EPVA.

### General Options

-   `--help`, `-h`: Show help text for any command.

## 🔍 Examples

**Standard Day-to-Day Flow:**
```bash
# 1. Start a new idea
haad run
# (Agents run Brainstorm Phase)
# (CLI pauses for approval)

# 2. Review data/brainstorm/DECISIONS.md
# ... Edit if needed ...
# Change [ ] PENDING to [x] APPROVED

# 3. Continue
haad run
# (Agents run Research Phase)
```

**Autonomous Test Run:**
```bash
# Run the entire flow from Idea to Plan without stopping
haad run --auto-approve
```
