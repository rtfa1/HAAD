#!/bin/sh
# .haad/commands/research.sh
# Implements the Research Phase of the HAAD workflow

# Load dependencies
. "$HAAD_ROOT/lib/core.sh"
. "$HAAD_ROOT/lib/agents.sh"

# Parse Arguments
for arg in "$@"; do
    case $arg in
        --help|-h)
            echo "Usage: haad research"
            echo ""
            echo "Phase 2: Research"
            echo "Analyzes feasibility (RA) and defines technical baseline (PSTRA)."
            echo "Directly follows Brainstorming phase."
            echo ""
            echo "Options:"
            echo "  --help, -h   Show this help message."
            exit 0
            ;;
    esac
done

haad_init_session

BRAINSTORM_DIR="$HAAD_ROOT/data/brainstorm"
RESEARCH_DIR="$HAAD_ROOT/data/research"
DECISIONS_FILE="$BRAINSTORM_DIR/DECISIONS.md"

echo "---------------------------------------------------"
echo "HAAD Phase 2: Research (Session: $SESSION_ID)"
echo "---------------------------------------------------"

# 1. Gate: Check Approvals
if [ ! -f "$DECISIONS_FILE" ]; then
    echo "Error: DECISIONS.md not found in $BRAINSTORM_DIR"
    echo "Run 'haad brainstorm' first."
    exit 1
fi

# Check for [x] APPROVED status for all 3 agents
# usage of grep to ensure the specific line format exists
if ! grep -q "\[01_CIA.md\].*\[x\] APPROVED" "$DECISIONS_FILE"; then
    echo "Error: CIA report is not approved."
    exit 1
fi
if ! grep -q "\[02_ISA.md\].*\[x\] APPROVED" "$DECISIONS_FILE"; then
    echo "Error: ISA report is not approved."
    exit 1
fi
if ! grep -q "\[03_ICA.md\].*\[x\] APPROVED" "$DECISIONS_FILE"; then
    echo "Error: ICA report is not approved."
    exit 1
fi

echo "All Brainstorm reports approved. Proceeding..."

# 2. Run Research Agent (RA)
mkdir -p "$RESEARCH_DIR"
RA_FILE="$RESEARCH_DIR/01_RA.md"

if [ -f "$RA_FILE" ]; then
    echo "[RA] Report already exists. Skipping execution."
else
    echo "[1/1] Running Research Agent (RA)..."
    
    # Load Context
    CIA_OUTPUT=$(cat "$BRAINSTORM_DIR/01_CIA.md")
    ISA_OUTPUT=$(cat "$BRAINSTORM_DIR/02_ISA.md")
    ICA_OUTPUT=$(cat "$BRAINSTORM_DIR/03_ICA.md")
    
    RA_CONTEXT="Codebase Context:\n$CIA_OUTPUT\n\nStructuring & Approach:\n$ISA_OUTPUT\n\nConsolidated Concept:\n$ICA_OUTPUT"
    
    RA_OUTPUT=$(haad_run_agent "RA" "$RA_CONTEXT" "Researching technical feasibility")
    
    echo "$RA_OUTPUT" > "$RA_FILE"
    echo "[RA] Report generated at '$RA_FILE'."
fi

# 3. Run Pre-Spec Technical Research Agent (PSTRA)
PSTRA_FILE="$RESEARCH_DIR/02_PSTRA.md"

if [ -f "$PSTRA_FILE" ]; then
    echo "[PSTRA] Report already exists. Skipping execution."
else
    echo "[1/1] Running Pre-Spec Technical Research Agent (PSTRA)..."
    
    # Load Context (RA Output)
    RA_OUTPUT=$(cat "$RA_FILE")
    
    # Combined Context: Codebase + RA Strategy
    PSTRA_CONTEXT="Codebase Context:\n$CIA_OUTPUT\n\nResearch Strategy:\n$RA_OUTPUT"
    
    PSTRA_OUTPUT=$(haad_run_agent "PSTRA" "$PSTRA_CONTEXT" "Defining technical baseline")
    
    echo "$PSTRA_OUTPUT" > "$PSTRA_FILE"
    echo "[PSTRA] Report generated at '$PSTRA_FILE'."
fi

# 4. Decisions Dashboard
RESEARCH_DECISIONS="$RESEARCH_DIR/DECISIONS.md"
RESEARCH_TEMPLATE="$RESEARCH_DIR/templates/RESEARCH_DECISIONS.md"

if [ ! -f "$RESEARCH_DECISIONS" ] && [ -f "$RESEARCH_TEMPLATE" ]; then
    echo "Initializing Research Decisions Dashboard..."
    cp "$RESEARCH_TEMPLATE" "$RESEARCH_DECISIONS"
fi

echo "---------------------------------------------------"
echo "Research Phase Complete."
echo "Please review the dashboard at: $RESEARCH_DECISIONS"
