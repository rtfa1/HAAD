#!/bin/sh
# .haad/commands/reset.sh
# Clears generated data from ALL phases

# Load dependencies
. "$HAAD_ROOT/lib/core.sh"

# Parse Arguments
for arg in "$@"; do
    case $arg in
        --help|-h)
            echo "Usage: haad reset"
            echo ""
            echo "Clears all generated reports and decisions from all phases."
            echo "WARNING: This assumes you want a fresh start. Templates are preserved."
            echo ""
            echo "Options:"
            echo "  --help, -h   Show this help message."
            exit 0
            ;;
    esac
done

haad_init_session

echo "---------------------------------------------------"
echo "Resetting HAAD Session Data..."
echo "---------------------------------------------------"

# Function to clean a directory
clean_phase() {
    local phase_name="$1"
    local dir_path="$HAAD_ROOT/data/$phase_name"
    
    if [ -d "$dir_path" ]; then
        echo "Cleaning $phase_name phase..."
        # Remove known generated patterns
        # 1. Numbered reports (e.g., 01_CIA.md)
        rm -f "$dir_path"/[0-9][0-9]_*.md
        # 2. Decisions dashboard
        rm -f "$dir_path"/DECISIONS.md
        rm -f "$dir_path"/BRAINSTORM_DECISIONS.md # For Brainstorm phase
        
        # 3. Tasks directory (for Spec Phase)
        [ -d "$dir_path/tasks" ] && rm -rf "$dir_path/tasks"
        
        echo "  [✓] Cleared reports and dashboard in $phase_name"
        haad_log "INFO" "RESET" "Cleared $phase_name data"
    else
        echo "Skipping $phase_name (not found)"
    fi
}

# Clean all phases
clean_phase "brainstorm"
clean_phase "research"
clean_phase "spec"
clean_phase "plan"

echo "---------------------------------------------------"
echo "Reset Complete. Ready for a fresh start."
echo "Run 'haad run' to start over."
