#!/bin/sh
# scripts/install.sh
# HAAD Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/rtfa1/haad/main/scripts/install.sh | sh

set -e

# Configuration
REPO_URL="https://github.com/rtfa1/haad.git"
INSTALL_DIR="$(pwd)/.haad"
BRANCH="main"

echo "---------------------------------------------------"
echo "Installing HAAD CLI..."
echo "---------------------------------------------------"

# 1. Clone or Update
if [ -d "$INSTALL_DIR" ]; then
    echo "[*] Updating existing installation in $INSTALL_DIR..."
    cd "$INSTALL_DIR"
    git pull origin "$BRANCH" || echo "Warning: git pull failed"
else
    echo "[*] Cloning repository to $INSTALL_DIR..."
    git clone -b "$BRANCH" "$REPO_URL" "$INSTALL_DIR"
fi

# 2. Set Permissions (The fix for your question)
echo "[*] Setting executable permissions..."
chmod +x "$INSTALL_DIR/bin/haad"
chmod +x "$INSTALL_DIR/commands/"*.sh

# 3. Completion
echo ""
echo "---------------------------------------------------"
echo "Installation Complete!"
echo "---------------------------------------------------"
echo "You can now run HAAD within this workspace:"
echo ""
echo "  ./.haad/bin/haad help"
echo ""
