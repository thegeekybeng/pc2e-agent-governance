#!/bin/bash
# ============================================================
# PC2E Governance — Sync global_workflows to MacBook Air
# Run this from the MacBook Air after pulling pc2e-agent-governance
# Usage: bash sync-to-mac.sh
# ============================================================

set -e

MAC_WORKFLOWS_DIR="$HOME/.gemini/antigravity/global_workflows"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKFLOWS_SOURCE="/volume2/docker/.gemini/antigravity/global_workflows"

echo "PC2E Governance Sync"
echo "================================"

# On Mac, we pull the global_workflows from a local copy.
# These files should be committed alongside this repo or copied manually.
# This script syncs from a local mac-global-workflows/ subfolder in this repo.

MAC_SOURCE_DIR="$SCRIPT_DIR/mac-global-workflows"

if [ ! -d "$MAC_SOURCE_DIR" ]; then
  echo "ERROR: mac-global-workflows/ folder not found in $SCRIPT_DIR"
  echo "Run this from the MacBook Air after placing the workflow files in mac-global-workflows/"
  exit 1
fi

# Create destination if it doesn't exist
mkdir -p "$MAC_WORKFLOWS_DIR"

echo "Syncing global_workflows to: $MAC_WORKFLOWS_DIR"
echo ""

# Copy all workflow files
for file in "$MAC_SOURCE_DIR"/*.md; do
  filename=$(basename "$file")
  dest="$MAC_WORKFLOWS_DIR/$filename"
  cp "$file" "$dest"
  echo "  ✓ $filename"
done

echo ""
echo "Sync complete."
echo ""
echo "Active global_workflows on this Mac:"
ls -1 "$MAC_WORKFLOWS_DIR"
echo ""
echo "Next: Restart Antigravity for changes to take effect."
