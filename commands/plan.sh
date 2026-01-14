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
if ! grep -q "\[02_HLASA2.md\].*\[x\] APPROVED" "$SPEC_DECISIONS"; then
    echo "Error: Structure Plan (HLASA2) is not approved."
    exit 1
fi
if ! grep -q "\[03_SPVA.md\].*\[x\] APPROVED" "$SPEC_DECISIONS"; then
    echo "Error: Spec Validation (SPVA) is not approved."
    exit 1
fi

echo "Specification Phase approved. Proceeding..."
mkdir -p "$PLAN_DIR"

# Load Contexts
PSTRA_FILE="$RESEARCH_DIR/02_PSTRA.md"
HLASA_FILE="$SPEC_DIR/01_HLASA.md"
HLASA2_FILE="$SPEC_DIR/02_HLASA2.md"

PSTRA_OUTPUT=$(cat "$PSTRA_FILE")
HLASA_OUTPUT=$(cat "$HLASA_FILE")
HLASA2_OUTPUT=$(cat "$HLASA2_FILE")

# 2. Run TBA (Task Breakdown)
TBA_FILE="$PLAN_DIR/01_TBA.md"
if [ -f "$TBA_FILE" ]; then
    echo "[TBA] Report already exists. Skipping."
else
    echo "[1/3] Running Task Breakdown Agent (TBA)..."
    TBA_CONTEXT="Technical Baseline:\n$PSTRA_OUTPUT\n\nArchitecture:\n$HLASA_OUTPUT\n\nStructure Plan:\n$HLASA2_OUTPUT"
    TBA_OUTPUT=$(haad_run_agent "TBA" "$TBA_CONTEXT" "Breaking down project tasks")
    echo "$TBA_OUTPUT" > "$TBA_FILE"
    echo "[TBA] Report generated at '$TBA_FILE'."
fi

# 3. Run TRA (Task Refinement)
TRA_FILE="$PLAN_DIR/02_TRA.md"
if [ -f "$TRA_FILE" ]; then
    echo "[TRA] Report already exists. Skipping."
else
    echo "[2/3] Running Task Refinement Agent (TRA)..."
    TBA_OUTPUT_CONTENT=$(cat "$TBA_FILE")
    TRA_CONTEXT="Task Breakdown Strategies:\n$TBA_OUTPUT_CONTENT"
    TRA_OUTPUT=$(haad_run_agent "TRA" "$TRA_CONTEXT" "Refining tasks into actionable items")
    echo "$TRA_OUTPUT" > "$TRA_FILE"
    echo "[TRA] Report generated at '$TRA_FILE'."
fi

# 4. Run EPVA (Validation)
EPVA_FILE="$PLAN_DIR/03_EPVA.md"
if [ -f "$EPVA_FILE" ]; then
    echo "[EPVA] Report already exists. Skipping."
else
    echo "[3/3] Running Execution Plan Validation Agent (EPVA)..."
    TRA_OUTPUT_CONTENT=$(cat "$TRA_FILE")
    
    EPVA_CONTEXT="Original Spec Structure:\n$HLASA2_OUTPUT\n\nExecution Plan:\n$TRA_OUTPUT_CONTENT"
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
