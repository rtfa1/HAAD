#!/bin/sh
# .haad/commands/plan.sh
# Implements the Execution Planning Phase of the HAAD workflow

# Load dependencies
. "$HAAD_ROOT/lib/core.sh"
. "$HAAD_ROOT/lib/agents.sh"

# Parse Arguments
for arg in "$@"; do
    case $arg in
        --help|-h)
            echo "Usage: haad plan"
            echo ""
            echo "Phase 4: Execution Planning"
            echo "Breaks down structure into milestones (TBA), refines tasks (TRA), and validates (EPVA)."
            echo "Directly follows Specification phase."
            echo ""
            echo "Options:"
            echo "  --help, -h   Show this help message."
            exit 0
            ;;
    esac
done

haad_init_session

SPEC_DIR="$HAAD_ROOT/data/spec"
RESEARCH_DIR="$HAAD_ROOT/data/research"
PLAN_DIR="$HAAD_ROOT/data/plan"
SPEC_DECISIONS="$SPEC_DIR/DECISIONS.md"

echo "---------------------------------------------------"
echo "HAAD Phase 4: Execution Planning (Session: $SESSION_ID)"
echo "---------------------------------------------------"

# 1. Gate: Check Spec Approvals
if [ ! -f "$SPEC_DECISIONS" ]; then
    echo "Error: SPEC DECISIONS not found."
    echo "Run 'haad spec' first."
    exit 1
fi

if ! grep -q "\[01_HLASA.md\].*\[x\] APPROVED" "$SPEC_DECISIONS"; then
    echo "Error: Architecture (HLASA) is not approved."
    exit 1
fi
if ! grep -q "\[03_TPA.md\].*\[x\] APPROVED" "$SPEC_DECISIONS"; then
    echo "Error: Test Plan (TPA) is not approved."
    exit 1
fi
if ! grep -q "\[04_SPVA.md\].*\[x\] APPROVED" "$SPEC_DECISIONS"; then
    echo "Error: Spec Validation (SPVA) is not approved."
    exit 1
fi
if ! grep -q "\[tasks/TASK_INDEX.md\].*\[x\] APPROVED" "$SPEC_DECISIONS"; then
    echo "Error: Validation Tasks Registry (TASK_INDEX) is not approved."
    exit 1
fi

echo "Specification Phase approved. Proceeding..."
mkdir -p "$PLAN_DIR"

# Load Contexts
PSTRA_FILE="$RESEARCH_DIR/02_PSTRA.md"
HLASA_FILE="$SPEC_DIR/01_HLASA.md"
TPA_FILE="$SPEC_DIR/03_TPA.md"

PSTRA_OUTPUT=$(cat "$PSTRA_FILE")
HLASA_OUTPUT=$(cat "$HLASA_FILE")
TPA_OUTPUT=$(cat "$TPA_FILE")

# 2. Run TBA (Task Breakdown)
# 2. Run TBA (Task Breakdown Agent)
TBA_FILE="$PLAN_DIR/01_TBA.md"
TASKS_DIR="$PLAN_DIR/tasks"
TASK_INDEX_FILE="$TASKS_DIR/TASK_INDEX.md"
TASK_INDEX_TEMPLATE="$PLAN_DIR/templates/TASK_INDEX.md"

if [ -f "$TBA_FILE" ]; then
    echo "[TBA] Report already exists. Skipping."
else
    echo "[1/3] Running Task Breakdown Agent (TBA)..."
    
    mkdir -p "$TASKS_DIR"
    
    # Initialize Task Index
    if [ -f "$TASK_INDEX_TEMPLATE" ]; then
        cp "$TASK_INDEX_TEMPLATE" "$TASK_INDEX_FILE"
    else
        echo "# Implementation Task Index" > "$TASK_INDEX_FILE"
    fi

    # Load Contexts
    TASK_TEMPLATE_CONTENT=$(cat "$PLAN_DIR/templates/TASK.md")
    
    TBA_CONTEXT="Technical Baseline:\n$PSTRA_OUTPUT\n\nArchitecture:\n$HLASA_OUTPUT\n\nValidation Tasks:\n$TPA_OUTPUT\n\nProvided Task Template:\n$TASK_TEMPLATE_CONTENT"
    
    # Run Agent
    TBA_OUTPUT=$(haad_run_agent "TBA" "$TBA_CONTEXT" "Breaking down implementation tasks")
    echo "$TBA_OUTPUT" > "$TBA_FILE"
    echo "[TBA] Report generated at '$TBA_FILE'."
    
    # NOTE: TBA is responsible for creating individual task files in $TASKS_DIR
    echo "[TBA] Check $TASKS_DIR for generated implementation tasks."
fi

# 3. Run TRA (Task Refinement)
TRA_FILE="$PLAN_DIR/02_TRA.md"
if [ -f "$TRA_FILE" ]; then
    echo "[TRA] Report already exists. Skipping."
else
    echo "[2/3] Running Task Refinement Agent (TRA)..."
    
    # Pass Directory Context - Agent will read/write files directly
    TRA_CONTEXT="Technical Baseline:\n$PSTRA_OUTPUT\n\nArchitecture:\n$HLASA_OUTPUT\n\nTask Location:\n$TASKS_DIR\nTask Index:\n$TASK_INDEX_FILE"
    
    TRA_OUTPUT=$(haad_run_agent "TRA" "$TRA_CONTEXT" "Refining and enhancing tasks")
    echo "$TRA_OUTPUT" > "$TRA_FILE"
    echo "[TRA] Report generated at '$TRA_FILE'."
fi

# 4. Run EPVA (Validation)
EPVA_FILE="$PLAN_DIR/03_EPVA.md"
if [ -f "$EPVA_FILE" ]; then
    echo "[EPVA] Report already exists. Skipping."
else
    echo "[3/3] Running Execution Plan Validation Agent (EPVA)..."
    # Re-read index and tasks as they might have changed
    TASKS_INDEX="$TASK_INDEX_FILE"
    EPVA_CONTEXT="Validation Tasks (TPA):\n$TPA_OUTPUT\n\nImplementation Tasks Index:\n$TASKS_INDEX"
    EPVA_OUTPUT=$(haad_run_agent "EPVA" "$EPVA_CONTEXT" "Validating execution plan")
    echo "$EPVA_OUTPUT" > "$EPVA_FILE"
    echo "[EPVA] Report generated at '$EPVA_FILE'."
fi

# 5. Decisions Dashboard
PLAN_DECISIONS="$PLAN_DIR/DECISIONS.md"
PLAN_TEMPLATE="$PLAN_DIR/templates/PLAN_DECISIONS.md"

if [ ! -f "$PLAN_DECISIONS" ] && [ -f "$PLAN_TEMPLATE" ]; then
    echo "Initializing Plan Decisions Dashboard..."
    cp "$PLAN_TEMPLATE" "$PLAN_DECISIONS"
fi

echo "---------------------------------------------------"
echo "Execution Planning Phase Complete."
echo "Please review the dashboard at: $PLAN_DECISIONS"
