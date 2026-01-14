#!/bin/sh
# .haad/commands/brainstorm.sh
# Implements the Brainstorm Phase of the HAAD workflow

# Load dependencies
. "$HAAD_ROOT/lib/core.sh"
. "$HAAD_ROOT/lib/agents.sh"

# Parse Arguments
for arg in "$@"; do
    case $arg in
        --help|-h)
            echo "Usage: haad brainstorm"
            echo ""
            echo "Phase 1: Brainstorming"
            echo "Analyzes codebase (CIA), structures ideas (ISA), and consolidates concept (ICA)."
            echo ""
            echo "Options:"
            echo "  --help, -h   Show this help message."
            exit 0
            ;;
    esac
done

# 1. Initialize Session
haad_init_session

BRAINSTORM_DIR="$HAAD_ROOT/data/brainstorm"
INPUT_FILE="$HAAD_ROOT/data/input/prompt.md"
INPUT_IDEA="$1"

# Check for input file logic
if [ -n "$INPUT_IDEA" ]; then
    haad_log "INFO" "USER" "Input Idea provided via argument."
elif [ -f "$INPUT_FILE" ]; then
    INPUT_IDEA=$(cat "$INPUT_FILE")
    haad_log "INFO" "USER" "Reading input from $INPUT_FILE"
    echo "Reading input from $INPUT_FILE..."
else
    # Prompt and create file
    haad_prompt "Enter your idea" "" INPUT_IDEA
    mkdir -p "$(dirname "$INPUT_FILE")"
    echo "$INPUT_IDEA" > "$INPUT_FILE"
    haad_log "INFO" "USER" "Created input file at $INPUT_FILE"
    echo "Saved your idea to $INPUT_FILE for future runs."
fi

haad_log "INFO" "USER" "Input Idea: $INPUT_IDEA"
echo "---------------------------------------------------"
echo "HAAD Phase 1: Brainstorming (Session: $SESSION_ID)"
echo "---------------------------------------------------"

# --- Step 1: Codebase Inventory Agent (CIA) ---
CIA_FILE="$BRAINSTORM_DIR/01_CIA.md"
if [ -f "$CIA_FILE" ]; then
    echo "[CIA] Loading context from existing report..."
    CIA_OUTPUT=$(cat "$CIA_FILE")
else
    echo "[1/3] Running Codebase Inventory Agent (CIA)..."
    CIA_OUTPUT=$(haad_run_agent "CIA" "$PWD" "Mapping existing project structure")
    echo "$CIA_OUTPUT" > "$CIA_FILE"
    echo "[CIA] Report generated at '$CIA_FILE'."
fi

# --- Step 2: Structuring Agent (ISA) ---
ISA_FILE="$BRAINSTORM_DIR/02_ISA.md"
if [ -f "$ISA_FILE" ]; then
    echo "[ISA] Loading context from existing report..."
    ISA_OUTPUT=$(cat "$ISA_FILE")
else
    echo "[2/3] Running Structuring Agent (ISA)..."
    ISA_CONTEXT="User Idea: '$INPUT_IDEA'. Codebase Context: $CIA_OUTPUT"
    ISA_OUTPUT=$(haad_run_agent "ISA" "$ISA_CONTEXT" "Structuring the raw idea")
    echo "$ISA_OUTPUT" > "$ISA_FILE"
    echo "[ISA] Report generated at '$ISA_FILE'."
fi

# --- Step 3: Consolidation Agent (ICA) ---
ICA_FILE="$BRAINSTORM_DIR/03_ICA.md"
if [ -f "$ICA_FILE" ]; then
    echo "[ICA] Report already exists."
else
    echo "[3/3] Running Consolidation Agent (ICA)..."
    ICA_OUTPUT=$(haad_run_agent "ICA" "$ISA_OUTPUT" "Consolidating into a concept")
    echo "$ICA_OUTPUT" > "$ICA_FILE"
    echo "[ICA] Report generated at '$ICA_FILE'."
fi

# --- Step 4: Decisions Dashboard ---
DECISIONS_FILE="$BRAINSTORM_DIR/DECISIONS.md"
TEMPLATE_FILE="$BRAINSTORM_DIR/templates/DECISIONS.md"

if [ ! -f "$DECISIONS_FILE" ] && [ -f "$TEMPLATE_FILE" ]; then
    echo "Initializing Decisions Dashboard from template..."
    cp "$TEMPLATE_FILE" "$DECISIONS_FILE"
fi

echo "---------------------------------------------------"
echo "Brainstorming Analysis Complete."
echo "Please review the dashboard at: $DECISIONS_FILE"
