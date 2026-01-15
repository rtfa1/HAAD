# Pre-Spec Technical Baseline

## 1. Dependency Specifications
| Package | Version | Justification |
| :--- | :--- | :--- |
| fabric | 7.0.0 | Core library for simplified Canvas shape creation, manipulation, and SVG export, as recommended in the strategy for handling complex drawing operations efficiently. |
| jspdf | 2.5.1 | Library for PDF export functionality, enabling users to save drawings as PDF files directly from the Canvas. |

## 2. Proposed Directory Structure
```text
/
├── web/
│   ├── drawing-tool/
│   │   ├── index.html
│   │   ├── app.js
│   │   ├── styles.css
│   │   └── package.json
└── commands/
    └── draw.sh
```

## 3. Core Data Models / Signatures
### Shape
- **Input**: {type: string, x: number, y: number, width: number, height: number, color: string}
- **Output**: Shape instance
- **Description**: Represents a drawable shape (rectangle, circle) with position, dimensions, and style properties for rendering on the Canvas.

### DrawingCanvas
- **Input**: HTMLCanvasElement
- **Output**: DrawingCanvas instance
- **Description**: Manages the Canvas element, handles user events (mouse/touch), and coordinates drawing operations like adding shapes, selecting tools, and exporting.

## 4. Configuration Changes
- [ ] web/drawing-tool/package.json: Add npm package definitions for fabric and jspdf dependencies.
- [ ] commands/draw.sh: Implement Bash script to check for Node.js availability and start a local HTTP server to serve the drawing tool web application.
- [ ] scripts/install.sh: Update installation script to verify Node.js runtime presence and install npm dependencies if missing.
