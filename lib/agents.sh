#!/bin/sh
# .haad/lib/agents.sh
# Agent abstractions for HAAD CLI

# Mock Agent Execution Wrapper
# In a real scenario, this might call an LLM API
haad_run_agent() {
    local agent_name="$1"
    local input_context="$2"
    local agent_role="$3"
    
    # Load System Prompt
    local config_file="$HAAD_ROOT/config/agents/${agent_name}.md"
    local system_prompt=""
    if [ -f "$config_file" ]; then
        system_prompt=$(cat "$config_file")
    fi

    # Load Output Template
    local template_content=""
    local template_files=(
        "$HAAD_ROOT/data/brainstorm/templates/${agent_name}.md"
        "$HAAD_ROOT/data/research/templates/${agent_name}.md"
        "$HAAD_ROOT/data/spec/templates/${agent_name}.md"
        "$HAAD_ROOT/data/plan/templates/${agent_name}.md"
    )

    for t_file in "${template_files[@]}"; do
        if [ -f "$t_file" ]; then
            template_content=$(cat "$t_file")
            haad_log "DEBUG" "AGENT" "Loaded template for $agent_name from $t_file"
            break
        fi
    done

    if [ -n "$template_content" ]; then
        system_prompt="$system_prompt\n\n## REQUIRED OUTPUT FORMAT\nYou must fill out this template:\n$template_content"
    fi

    # Load Orchestrator Prompt (Global Top-Level)
    local orchestrator_file="$HAAD_ROOT/config/agents/ORCHESTRATOR.md"
    local orchestrator_prompt=""
    if [ -f "$orchestrator_file" ]; then
        orchestrator_prompt=$(cat "$orchestrator_file")
    fi

    # Combine System Prompt and Content
    local full_prompt=""
    
    # Structure: Orchestrator -> System (Agent Specific) -> User Context
    full_prompt="GLOBAL_DIRECTIVES:\n$orchestrator_prompt\n\nSYSTEM_PROMPT:\n$system_prompt\n\nUSER_CONTEXT:\n$input_context"
    
    haad_log "INFO" "ORCHESTRATOR" "Activating Agent: $agent_name"
    haad_log "DEBUG" "$agent_name" "System Prompt Length: ${#system_prompt} chars"
    haad_log "DEBUG" "$agent_name" "Context provided: $input_context"
    
    # Load Runner Configuration
    local runner_file="$HAAD_ROOT/config/runner.cmd"
    local output=""
    
    if [ -f "$runner_file" ]; then
        # Load the command template
        local runner_cmd=$(cat "$runner_file")
        
        # Export the prompt so it's available to val
        export HAAD_PROMPT="$full_prompt"
        export HAAD_AGENT_NAME="$agent_name"
        
        haad_log "DEBUG" "RUNNER" "Executing command: $runner_cmd"
        
        # Execute the runner command
        # We use eval to allow the shell to expand $HAAD_PROMPT and other vars
        output=$(eval "$runner_cmd")
    else
        # Fallback Mock (if runner.cmd is missing)
        case "$agent_name" in
            "CIA")
                output="[Analyzed 15 files. Main language: Shell/Markdown. Detected existing 'haad' structure.]"
                ;;
            "ISA")
                output="[Identified Goal: $input_context. Constraints: CLI environment.]"
                ;;
            "ICA")
                output="[Consolidated Concept: A CLI command that traces user ideas through agentic steps.]"
                ;;
            *)
                output="[Processed by $agent_name]"
                ;;
        esac
    fi
    
    haad_log "INFO" "$agent_name" "Output generated: $output"
    echo "$output"
}
