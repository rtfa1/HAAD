# High-Level Architecture Specification

## 1. System Overview
The HAAD system is a CLI-based workflow orchestrator built with Bash scripts, now extended with a modular web-based drawing tool component. The architecture maintains the existing agent-based CLI structure for orchestration while introducing a browser-accessible drawing interface using HTML5 Canvas API and supporting libraries for shape manipulation and export capabilities. The drawing tool integrates as a standalone web application served locally, allowing users to create and export visual artifacts that can feed into HAAD workflows.

## 2. Component Diagram
```mermaid
graph TD
    A[User CLI Interface] --> B[HAAD Orchestrator (bin/haad)]
    B --> C[Command Handler (commands/draw.sh)]
    C --> D[Local HTTP Server]
    D --> E[Drawing Tool Web App (web/drawing-tool/)]
    E --> F[HTML5 Canvas Renderer]
    E --> G[Fabric.js Shape Manager]
    E --> H[jsPDF Export Handler]
    F --> I[Browser Display]
    G --> I
    H --> I
    B --> J[Other Commands (commands/*.sh)]
    B --> K[Config System (config/)]
    B --> L[Utility Library (lib/)]
    B --> M[Installation Scripts (scripts/)]
```

## 3. Data Flow Strategy
- **Command Initiation Flow**: User executes `haad draw` command through CLI, which invokes `commands/draw.sh` to check Node.js availability, install dependencies if needed, and start a local HTTP server serving the drawing tool web application.
- **Drawing Interaction Flow**: User interacts with the web app via mouse/touch events, which are captured by JavaScript event handlers, processed through Fabric.js for shape creation/manipulation, and rendered on the HTML5 Canvas for real-time visual feedback.
- **Export Flow**: User triggers export actions (PNG/PDF/SVG), which serialize the Canvas content through respective libraries (toDataURL for PNG, jsPDF for PDF, Fabric.js for SVG) and download the generated files to the user's local system.
- **Workflow Integration Flow**: Exported drawing artifacts can be referenced in HAAD workflow documents, with the web component maintaining separation from the core CLI orchestration logic.

## 4. Design Decisions
- **Web Component Isolation**: Implement the drawing tool as a separate web directory structure to maintain clean separation between the existing Bash-based CLI architecture and the new JavaScript web components, allowing independent development and deployment.
- **Library Selection**: Use Fabric.js for simplified Canvas operations and shape handling, and jsPDF for PDF export, as they provide proven APIs for the required functionality while keeping the implementation modular and extensible.
- **Local Server Approach**: Serve the drawing tool via a local HTTP server initiated by the draw.sh command, ensuring browser-based access without requiring external hosting while leveraging existing Node.js ecosystem tools for dependency management.
- **Canvas API Core**: Rely on HTML5 Canvas API as the rendering foundation with Fabric.js abstraction layer, balancing performance optimization needs (integer coordinates, selective redraws) with development simplicity for future feature additions like collaboration or advanced tools.
