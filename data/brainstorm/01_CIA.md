# Codebase Context

## 1. Project Identity
| Property | Value |
| :--- | :--- |
| **Type** | CLI |
| **Main Language** | Shell |
| **Core Stack** | Bash |
| **Entry Points** | bin/haad |

## 2. Architecture Map
| Directory/File | Purpose |
| :--- | :--- |
| `bin/` | Executables |
| `commands/` | Shell scripts for various commands |
| `config/` | Configuration files |
| `config/agents/` | Agent definitions and configurations |
| `data/` | Data storage for workflow phases |
| `data/brainstorm/` | Brainstorm phase artifacts and templates |
| `data/input/` | Input data for the workflow |
| `data/logs/` | Log files from sessions |
| `data/plan/` | Planning phase artifacts and templates |
| `data/research/` | Research phase artifacts and templates |
| `data/spec/` | Specification phase artifacts and templates |
| `docs/` | Documentation |
| `lib/` | Library files |
| `scripts/` | Additional scripts |

## 3. Critical Findings
- [ ] **Technical Constraints:** Requires Bash/shell environment
- [ ] **Anti-Patterns:** None observed
- [ ] **Key Components:** Agent configurations, command scripts, phase data structures

## 4. Summary
HAAD is a shell-based CLI tool for orchestrating AI-assisted software development workflows with structured phases.
