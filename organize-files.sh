#!/usr/bin/env bash
# organize-files.sh — Use Claude Code to organize a directory of files/photos
# Usage: ./organize-files.sh [directory]
#
# Examples:
#   ./organize-files.sh ~/photos
#   ./organize-files.sh ~/Downloads

set -euo pipefail

TARGET_DIR="${1:-$HOME/photos}"

if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: directory '$TARGET_DIR' does not exist."
  exit 1
fi

if ! command -v claude &>/dev/null; then
  echo "Error: claude not found. Run setup-claude-vps.sh first."
  exit 1
fi

echo "==> Organizing files in: $TARGET_DIR"
echo ""

# Count files
TOTAL=$(find "$TARGET_DIR" -maxdepth 1 -type f | wc -l)
echo "Found $TOTAL file(s) to organize."
echo ""

if [ "$TOTAL" -eq 0 ]; then
  echo "Nothing to do. Add files to $TARGET_DIR first."
  exit 0
fi

# Build a file listing to pass to Claude
FILE_LIST=$(find "$TARGET_DIR" -maxdepth 1 -type f -printf "%f\n" | sort)

PROMPT="I have these files in a directory called '$TARGET_DIR':

$FILE_LIST

Please help me organize them. Do the following:
1. Group them by file type (images, videos, documents, etc.)
2. For images/videos: create subfolders by year-month based on filename if possible, otherwise by type
3. Give me the exact shell commands (mv commands) to reorganize them
4. Keep it safe — don't delete anything

Only output the shell commands, one per line, ready to copy-paste."

echo "==> Asking Claude for an organization plan..."
echo ""
echo "Claude's suggestion:"
echo "--------------------"
claude -p "$PROMPT"
echo "--------------------"
echo ""
echo "Review the commands above, then run them manually in $TARGET_DIR"
echo "Or pipe directly: ./organize-files.sh $TARGET_DIR | bash  (use with care!)"
