#!/bin/sh
# .haad/commands/run.sh
# Master Orchestrator for HAAD Flow

# Load dependencies
. "$HAAD_ROOT/lib/core.sh"

echo "---------------------------------------------------"
echo "HAAD Orchestrator"
echo "---------------------------------------------------"

# Define Paths
BRAINSTORM_DECISIONS="$HAAD_ROOT/data/brainstorm/DECISIONS.md"
RESEARCH_DECISIONS="$HAAD_ROOT/data/research/DECISIONS.md"
SPEC_DECISIONS="$HAAD_ROOT/data/spec/DECISIONS.md"
PLAN_DECISIONS="$HAAD_ROOT/data/plan/DECISIONS.md"

# Parse Arguments
AUTO_APPROVE=false
for arg in "$@"; do
    case $arg in
        --help|-h)
            echo "Usage: haad run [options]"
            echo ""
            echo "Orchestrates the full HAAD workflow (Brainstorm -> Plan)."
            echo ""
            echo "Options:"
            echo "  --auto-approve   Automatically approve all decisions without manual review."
            echo "  --help, -h       Show this help message."
            exit 0
            ;;
        --auto-approve)
            AUTO_APPROVE=true
            echo "[Orchestrator] Auto-Approve Mode: ENABLED"
            ;;
    esac
done

# Function to handle auto-approval
check_and_approve() {
    local decisions_file="$1"
    local phase_name="$2"

    if [ "$AUTO_APPROVE" = "true" ] && [ -f "$decisions_file" ]; then
        if grep -q "\[ \] PENDING" "$decisions_file"; then
            echo "[Orchestrator] Auto-approving $phase_name phase..."
            # Portable sed for macOS/Linux compatibility
            if [[ "$OSTYPE" == "darwin"* ]]; then
                sed -i '' 's/\[ \] PENDING/\[x\] APPROVED/g' "$decisions_file"
            else
                sed -i 's/\[ \] PENDING/\[x\] APPROVED/g' "$decisions_file"
            fi
        fi
    fi
}

# 1. BRAINSTORM PHASE
# Checks: CIA, ISA, ICA
if [ ! -f "$BRAINSTORM_DECISIONS" ] || \
   [ ! -f "$HAAD_ROOT/data/brainstorm/01_CIA.md" ] || \
   [ ! -f "$HAAD_ROOT/data/brainstorm/02_ISA.md" ] || \
   [ ! -f "$HAAD_ROOT/data/brainstorm/03_ICA.md" ]; then
    echo "[Orchestrator] Starting Brainstorm Phase..."
    "$HAAD_ROOT/bin/haad" brainstorm
fi

check_and_approve "$BRAINSTORM_DECISIONS" "Brainstorm"

if ! grep -q "\[01_CIA.md\].*\[x\] APPROVED" "$BRAINSTORM_DECISIONS" || \
   ! grep -q "\[02_ISA.md\].*\[x\] APPROVED" "$BRAINSTORM_DECISIONS" || \
   ! grep -q "\[03_ICA.md\].*\[x\] APPROVED" "$BRAINSTORM_DECISIONS"; then
    echo "[Orchestrator] Brainstorm Phase pending approval."
    echo "Please review: $BRAINSTORM_DECISIONS"
    exit 0
fi

echo "[Orchestrator] Brainstorm Phase: APPROVED [✓]"

# 2. RESEARCH PHASE
# Checks: RA, PSTRA
if [ ! -f "$RESEARCH_DECISIONS" ] || \
   [ ! -f "$HAAD_ROOT/data/research/01_RA.md" ] || \
   [ ! -f "$HAAD_ROOT/data/research/02_PSTRA.md" ]; then
    echo "[Orchestrator] Starting Research Phase..."
    "$HAAD_ROOT/bin/haad" research
fi

check_and_approve "$RESEARCH_DECISIONS" "Research"

if ! grep -q "\[01_RA.md\].*\[x\] APPROVED" "$RESEARCH_DECISIONS" || \
   ! grep -q "\[02_PSTRA.md\].*\[x\] APPROVED" "$RESEARCH_DECISIONS"; then
    echo "[Orchestrator] Research Phase pending approval."
    echo "Please review: $RESEARCH_DECISIONS"
    exit 0
fi

echo "[Orchestrator] Research Phase: APPROVED [✓]"

# 3. SPECIFICATION PHASE
# Checks: HLASA, PRD, TPA, SPVA
if [ ! -f "$SPEC_DECISIONS" ] || \
   [ ! -f "$HAAD_ROOT/data/spec/01_HLASA.md" ] || \
   [ ! -f "$HAAD_ROOT/data/spec/02_PRD.md" ] || \
   [ ! -f "$HAAD_ROOT/data/spec/03_TPA.md" ] || \
   [ ! -f "$HAAD_ROOT/data/spec/04_SPVA.md" ]; then
    echo "[Orchestrator] Starting Specification Phase..."
    "$HAAD_ROOT/bin/haad" spec
fi

check_and_approve "$SPEC_DECISIONS" "Specification"

if ! grep -q "\[01_HLASA.md\].*\[x\] APPROVED" "$SPEC_DECISIONS" || \
   ! grep -q "\[02_PRD.md\].*\[x\] APPROVED" "$SPEC_DECISIONS" || \
   ! grep -q "\[03_TPA.md\].*\[x\] APPROVED" "$SPEC_DECISIONS" || \
   ! grep -q "\[04_SPVA.md\].*\[x\] APPROVED" "$SPEC_DECISIONS"; then
    echo "[Orchestrator] Specification Phase pending approval."
    echo "Please review: $SPEC_DECISIONS"
    exit 0
fi

echo "[Orchestrator] Specification Phase: APPROVED [✓]"

# 4. IMPLEMENTATION PLANNING PHASE
# Checks: TBA, TRA, EPVA
if [ ! -f "$PLAN_DECISIONS" ] || \
   [ ! -f "$HAAD_ROOT/data/plan/01_TBA.md" ] || \
   [ ! -f "$HAAD_ROOT/data/plan/02_TRA.md" ] || \
   [ ! -f "$HAAD_ROOT/data/plan/03_EPVA.md" ]; then
    echo "[Orchestrator] Starting Execution Planning Phase..."
    "$HAAD_ROOT/bin/haad" plan
fi

check_and_approve "$PLAN_DECISIONS" "Execution Planning"

if ! grep -q "\[01_TBA.md\].*\[x\] APPROVED" "$PLAN_DECISIONS" || \
   ! grep -q "\[02_TRA.md\].*\[x\] APPROVED" "$PLAN_DECISIONS" || \
   ! grep -q "\[03_EPVA.md\].*\[x\] APPROVED" "$PLAN_DECISIONS"; then
    echo "[Orchestrator] Execution Planning Phase pending approval."
    echo "Please review: $PLAN_DECISIONS"
    exit 0
fi

echo "[Orchestrator] Execution Planning Phase: APPROVED [✓]"
echo "---------------------------------------------------"
echo "All Phases Complete. Ready for Implementation."
echo "---------------------------------------------------"
