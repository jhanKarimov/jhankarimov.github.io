#!/usr/bin/env bash
# setup-claude-vps.sh — Bootstrap a VPS with Claude Code
# Usage: bash setup-claude-vps.sh

set -euo pipefail

echo "==> Updating system packages..."
sudo apt-get update -qq && sudo apt-get upgrade -y -qq

echo "==> Installing dependencies..."
sudo apt-get install -y -qq curl git tmux unzip

echo "==> Installing nvm..."
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

# Load nvm
# shellcheck source=/dev/null
source "$NVM_DIR/nvm.sh"

echo "==> Installing Node.js LTS..."
nvm install --lts
nvm use --lts
nvm alias default node

echo "==> Installing Claude Code..."
npm install -g @anthropic-ai/claude-code

echo "==> Setting up shell config..."
SHELL_RC="$HOME/.bashrc"
if [ -f "$HOME/.zshrc" ]; then
  SHELL_RC="$HOME/.zshrc"
fi

# Add nvm to shell rc if not already there
if ! grep -q "NVM_DIR" "$SHELL_RC"; then
  cat >> "$SHELL_RC" <<'EOF'

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
EOF
fi

# Prompt user for API key
if [ -z "${ANTHROPIC_API_KEY:-}" ]; then
  echo ""
  echo "==> Enter your Anthropic API key (get one at https://console.anthropic.com):"
  read -r -s ANTHROPIC_API_KEY
  if [ -n "$ANTHROPIC_API_KEY" ]; then
    if ! grep -q "ANTHROPIC_API_KEY" "$SHELL_RC"; then
      echo "export ANTHROPIC_API_KEY=\"$ANTHROPIC_API_KEY\"" >> "$SHELL_RC"
      echo "==> API key saved to $SHELL_RC"
    fi
  fi
fi

echo "==> Installing tmux config for persistent sessions..."
cat > "$HOME/.tmux.conf" <<'EOF'
# Mouse support
set -g mouse on

# Increase scrollback buffer
set -g history-limit 50000

# Start windows and panes at 1
set -g base-index 1
setw -g pane-base-index 1

# Easier split keys
bind | split-window -h
bind - split-window -v
EOF

echo "==> Creating photos directory..."
mkdir -p "$HOME/photos" "$HOME/uploads"

echo ""
echo "============================================"
echo " Setup complete!"
echo "============================================"
echo ""
echo " Next steps:"
echo "  1. Reload your shell:  source $SHELL_RC"
echo "  2. Start a tmux session: tmux new -s main"
echo "  3. Run Claude:  claude"
echo ""
echo " To upload photos from Termux:"
echo "  scp ~/storage/dcim/Camera/*.jpg $(whoami)@$(hostname -I | awk '{print $1}'):~/photos/"
echo ""
