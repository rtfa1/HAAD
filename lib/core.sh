#!/bin/sh
# .haad/lib/core.sh
# Core functions for HAAD CLI

# Initialize variables
HAAD_DATA_DIR="$HAAD_ROOT/data"
LOG_DIR="$HAAD_DATA_DIR/logs"


# Logging function
# Usage: haad_log "LEVEL" "COMPONENT" "Message"
haad_log() {
    local level="$1"
    local component="$2"
    local message="$3"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    local log_file="$LOG_DIR/session_${SESSION_ID}.log"

    # Ensure log directory exists (if session started)
    if [ -n "$SESSION_ID" ]; then
        echo "[$timestamp] [$level] [$component] $message" >> "$log_file"
    fi

    # Output to stdout (stderr) based on level or verbosity
    if [ "$level" = "INFO" ] || [ "$level" = "ERROR" ] || [ "$level" = "WARN" ]; then
        echo "[$component] $message" >&2
    fi
}

# Initialize session
haad_init_session() {
    SESSION_ID=$(date "+%Y%m%d_%H%M%S")_$$
    export SESSION_ID
    
    # Create session log file
    touch "$LOG_DIR/session_${SESSION_ID}.log"
    
    haad_log "INFO" "CORE" "Session initialized: $SESSION_ID"
}

# User prompt
haad_prompt() {
    local prompt_msg="$1"
    local default_val="$2"
    local result_var="$3"
    
    printf "%s" "$prompt_msg"
    if [ -n "$default_val" ]; then
        printf " [%s]" "$default_val"
    fi
    printf ": "
    
    read input
    
    if [ -z "$input" ] && [ -n "$default_val" ]; then
        input="$default_val"
    fi
    
    eval $result_var="'$input'"
    haad_log "DEBUG" "PROMPT" "User input for '$prompt_msg': $input"
}
