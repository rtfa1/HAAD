#!/bin/sh
# .haad/commands/spec.sh
# Implements the Specification Phase of the HAAD workflow

# Load dependencies
. "$HAAD_ROOT/lib/core.sh"
. "$HAAD_ROOT/lib/agents.sh"

# Parse Arguments
for arg in "$@"; do
    case $arg in
        --help|-h)
            echo "Usage: haad spec"
            echo ""
            echo "Phase 3: Specification"
            echo "Designs architecture (HLASA), defines requirements (PRD), plans structure (HLASA2), and validates (SPVA)."
            echo "Directly follows Research phase."
            echo ""
            echo "Options:"
            echo "  --help, -h   Show this help message."
            exit 0
            ;;
    esac
done

haad_init_session

RESEARCH_DIR="$HAAD_ROOT/data/research"
SPEC_DIR="$HAAD_ROOT/data/spec"
RESEARCH_DECISIONS="$RESEARCH_DIR/DECISIONS.md"
CIA_FILE="$HAAD_ROOT/data/brainstorm/01_CIA.md"

echo "---------------------------------------------------"
echo "HAAD Phase 3: Specification (Session: $SESSION_ID)"
echo "---------------------------------------------------"

# 1. Gate: Check Research Approvals
if [ ! -f "$RESEARCH_DECISIONS" ]; then
    echo "Error: RESEARCH DECISIONS not found."
    echo "Run 'haad research' first."
    exit 1
fi

if ! grep -q "\[01_RA.md\].*\[x\] APPROVED" "$RESEARCH_DECISIONS"; then
    echo "Error: Research Strategy (RA) is not approved."
    exit 1
fi
if ! grep -q "\[02_PSTRA.md\].*\[x\] APPROVED" "$RESEARCH_DECISIONS"; then
    echo "Error: Technical Baseline (PSTRA) is not approved."
    exit 1
fi

echo "Research Phase approved. Proceeding..."
mkdir -p "$SPEC_DIR"

# Load Contexts
RA_FILE="$RESEARCH_DIR/01_RA.md"
PSTRA_FILE="$RESEARCH_DIR/02_PSTRA.md"

CIA_OUTPUT=$(cat "$CIA_FILE")
RA_OUTPUT=$(cat "$RA_FILE")
PSTRA_OUTPUT=$(cat "$PSTRA_FILE")

# 2. Run HLASA (High Level Arch)
HLASA_FILE="$SPEC_DIR/01_HLASA.md"
if [ -f "$HLASA_FILE" ]; then
    echo "[HLASA] Report already exists. Skipping."
else
    echo "[1/4] Running High Level Architecture Spec Agent (HLASA)..."
    HLASA_CONTEXT="Codebase Context:\n$CIA_OUTPUT\n\nFeasibility Strategy:\n$RA_OUTPUT\n\nTechnical Baseline:\n$PSTRA_OUTPUT"
    HLASA_OUTPUT=$(haad_run_agent "HLASA" "$HLASA_CONTEXT" "Designing high-level architecture")
    echo "$HLASA_OUTPUT" > "$HLASA_FILE"
    echo "[HLASA] Report generated at '$HLASA_FILE'."
fi

# 3. Run PRD (Product Requirements)
PRD_FILE="$SPEC_DIR/02_PRD.md"
if [ -f "$PRD_FILE" ]; then
    echo "[PRD] Report already exists. Skipping."
else
    echo "[2/4] Running Product Requirements Definition Agent (PRD)..."
    HLASA_OUTPUT_CONTENT=$(cat "$HLASA_FILE")
    PRD_CONTEXT="High-Level Architecture:\n$HLASA_OUTPUT_CONTENT\n\nTechnical Baseline:\n$PSTRA_OUTPUT"
    PRD_OUTPUT=$(haad_run_agent "PRD" "$PRD_CONTEXT" "Defining product requirements")
    echo "$PRD_OUTPUT" > "$PRD_FILE"
    echo "[PRD] Report generated at '$PRD_FILE'."
fi

# 3. Run TPA (Test Plan Agent)
TPA_FILE="$SPEC_DIR/03_TPA.md"
TASKS_DIR="$SPEC_DIR/tasks"
TASK_INDEX_FILE="$TASKS_DIR/TASK_INDEX.md"
TASK_INDEX_TEMPLATE="$SPEC_DIR/templates/TASK_INDEX.md"

if [ -f "$TPA_FILE" ]; then
    echo "[TPA] Report already exists. Skipping."
else
    echo "[3/4] Running Test Plan Agent (TPA)..."
    
    mkdir -p "$TASKS_DIR"
    
    # Initialize Task Index
    if [ -f "$TASK_INDEX_TEMPLATE" ]; then
        cp "$TASK_INDEX_TEMPLATE" "$TASK_INDEX_FILE"
    else
        echo "# Task Index" > "$TASK_INDEX_FILE"
    fi

    # Context for TPA
    HLASA_OUTPUT_CONTENT=$(cat "$HLASA_FILE")
    PRD_OUTPUT_CONTENT=$(cat "$PRD_FILE")
    
    # Load Task Template for reference
    TASK_TEMPLATE_CONTENT=$(cat "$SPEC_DIR/templates/TASK.md")
    
    TPA_CONTEXT="High-Level Architecture:\n$HLASA_OUTPUT_CONTENT\n\nProduct Requirements:\n$PRD_OUTPUT_CONTENT\n\nProvided Task Template:\n$TASK_TEMPLATE_CONTENT"
    
    # Run Agent
    TPA_OUTPUT=$(haad_run_agent "TPA" "$TPA_CONTEXT" "Defining validation tasks")
    echo "$TPA_OUTPUT" > "$TPA_FILE"
    echo "[TPA] Raw report generated at '$TPA_FILE'."
fi

# 4. Run SPVA (Validation)
SPVA_FILE="$SPEC_DIR/04_SPVA.md"
if [ -f "$SPVA_FILE" ]; then
    echo "[SPVA] Report already exists. Skipping."
else
    echo "[4/4] Running Spec Plan Validation Agent (SPVA)..."
    HLASA_OUTPUT_CONTENT=$(cat "$HLASA_FILE")
    PRD_OUTPUT_CONTENT=$(cat "$PRD_FILE")
    
    # Pass TASK INDEX LOCATION to SPVA
    TASKS_INDEX="$TASK_INDEX_FILE"
    
    SPVA_CONTEXT="Product Requirements:\n$PRD_OUTPUT_CONTENT\n\nValidation Tasks Index:\n$TASKS_INDEX"
    SPVA_OUTPUT=$(haad_run_agent "SPVA" "$SPVA_CONTEXT" "Validating specification plan")
    echo "$SPVA_OUTPUT" > "$SPVA_FILE"
    echo "[SPVA] Report generated at '$SPVA_FILE'."
fi

# 5. Decisions Dashboard
SPEC_DECISIONS="$SPEC_DIR/DECISIONS.md"
SPEC_TEMPLATE="$SPEC_DIR/templates/SPEC_DECISIONS.md"

if [ ! -f "$SPEC_DECISIONS" ] && [ -f "$SPEC_TEMPLATE" ]; then
    echo "Initializing Spec Decisions Dashboard..."
    cp "$SPEC_TEMPLATE" "$SPEC_DECISIONS"
fi

echo "---------------------------------------------------"
echo "Specification Phase Complete."
echo "Please review the dashboard at: $SPEC_DECISIONS"
