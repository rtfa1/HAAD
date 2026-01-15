# Product Requirements Definition (PRD)

## 1. Executive Summary
HAAD is a CLI-based orchestrator for workflow management, enhanced with a web-based drawing tool for creating diagrams. The product enables users to launch an interactive drawing application via command line, supporting shape creation, manipulation, and export to PNG format. Target audience includes developers and users requiring lightweight, browser-based diagramming integrated with CLI workflows, without external dependencies.

## 2. User Flows
### User Login Flow
1. User opens terminal and navigates to HAAD project directory.
2. User runs `draw` command.
3. System checks for Node.js availability; if missing, displays error and exits.
4. System launches local HTTP server on a specified port (e.g., 3000).
5. Browser opens automatically to `http://localhost:3000` displaying the drawing tool.

### Create Project Flow (Drawing Session)
1. User interacts with Canvas to draw shapes (rectangles, circles) using mouse/touch.
2. User selects shapes, resizes, moves, or deletes them.
3. User selects export option (PNG).
4. System generates PNG file and prompts download.
5. User closes browser; server remains running until manually stopped.

### Export and Close Flow
1. User clicks export button in web app.
2. System converts Canvas content to PNG using `toDataURL`.
3. Browser downloads the PNG file.
4. User closes browser tab or window, terminating session.

## 3. Functional Requirements
### 3.1 CLI Orchestrator
- **FR-01**: Provide a `draw` command that validates Node.js installation and launches a local HTTP server serving the drawing tool at `http://localhost:3000`.
- **FR-02**: Display clear error messages if Node.js is not installed, with instructions to install it.
- **FR-03**: Automatically open the default browser to the drawing tool URL upon server start.

### 3.2 Web Drawing Tool
- **FR-04**: Render an HTML5 Canvas element in the browser, initialized with Fabric.js for shape handling.
- **FR-05**: Support creation of basic shapes (rectangles, circles) via toolbar buttons or keyboard shortcuts.
- **FR-06**: Enable shape selection, dragging, resizing, and deletion using mouse/touch events.
- **FR-07**: Maintain drawing state in a DrawingCanvas model, persisting shapes across interactions.
- **FR-08**: Provide undo/redo functionality for shape operations.

### 3.3 Export Handlers
- **FR-09**: Implement PNG export using Canvas `toDataURL`, triggering a browser download of the drawing as a PNG file.
- **FR-10**: Ensure export preserves Canvas dimensions and shape properties accurately.

## 4. Non-Functional Requirements
- **NFR-01**: System must load the web app in under 3 seconds on standard hardware with Node.js installed.
- **NFR-02**: Drawing operations (shape creation, manipulation) must respond within 100ms to maintain smooth interactivity.
- **NFR-03**: Local server must handle a single concurrent session without performance degradation.
- **NFR-04**: No external internet access required; all functionality runs offline.
- **NFR-05**: User interface must be responsive and usable on desktop browsers (Chrome, Firefox, Safari) with basic touch support.
- **NFR-06**: Security: All operations confined to local machine; no data transmission to external servers.
- **NFR-07**: Scalability: Support Canvas sizes up to 1920x1080 pixels without memory issues.
- **NFR-08**: Usability: Provide intuitive toolbar with tooltips; keyboard shortcuts for power users.

## 5. User Stories
| ID | As a... | I want to... | So that... | Acceptance Criteria |
| :--- | :--- | :--- | :--- | :--- |
| US-1 | Developer | run a CLI command to launch a drawing tool | I can create diagrams without leaving the terminal | - Command `draw` exists and launches server<br>- Browser opens to drawing interface<br>- Error shown if Node.js missing |
| US-2 | User | draw basic shapes on a Canvas | I can create simple diagrams interactively | - Rectangle and circle tools available<br>- Shapes render on Canvas after selection<br>- Shapes are selectable and movable |
| US-3 | User | export my drawing as PNG | I can save and share my work | - Export button triggers download<br>- PNG file contains accurate Canvas content<br>- File downloads to default browser location |
| US-4 | User | manipulate shapes (resize, delete) | I can refine my diagrams | - Click to select shape shows handles<br>- Drag handles resizes shape<br>- Delete key removes selected shape |
| US-5 | User | undo/redo actions | I can correct mistakes easily | - Undo button reverts last action<br>- Redo restores undone action<br>- State persists during session |

## 6. MVP Scope
- **In Scope**:
  - CLI `draw` command with Node.js check and server launch
  - Basic web app with HTML5 Canvas and Fabric.js integration
  - Shape creation (rectangles, circles) and manipulation (select, drag, resize, delete)
  - PNG export functionality
  - Local HTTP server serving static files
- **Out of Scope**:
  - PDF and SVG export formats
  - Advanced shapes (lines, polygons, text)
  - Multi-user collaboration
  - Drawing file save/load (beyond export)
  - Cross-platform mobile optimization
  - Integration with external APIs or cloud storage
  - Customizable themes or advanced styling options
