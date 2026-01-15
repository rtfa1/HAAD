# Codebase Context

## 1. Project Identity
| Property | Value |
| :--- | :--- |
| **Type** | CLI |
| **Main Language** | Shell |
| **Core Stack** | Bash |
| **Entry Points** | bin/haad, commands/*.sh |

## 2. Architecture Map
| Directory/File | Purpose |
| :--- | :--- |
| bin/ | Executable scripts |
| config/ | Configuration files and agent definitions |
| lib/ | Core utility scripts |
| commands/ | Individual command implementations |
| scripts/ | Installation and setup scripts |
| docs/ | Project documentation |
| .git/ | Git repository metadata |

## 3. Critical Findings
- [x] **Technical Constraints:** Requires Bash shell and Unix-like operating system
- [ ] **Anti-Patterns:** None identified
- [x] **Key Components:** Agent-based architecture with specialized agents, modular command system

## 4. Summary
This is an established CLI tool project for HAAD workflow orchestration using shell scripts.
