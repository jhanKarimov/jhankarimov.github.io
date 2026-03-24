# Using Claude Code from Your Phone

A practical guide for running Claude Code on a VPS and accessing it from your phone (Termux or SSH client).

---

## Option A: Termux (Android) — No VPS Needed

If you're already on Termux, you can run Claude Code directly:

```bash
# Install Node.js
pkg install nodejs

# Install Claude Code
npm install -g @anthropic-ai/claude-code

# Set your API key
export ANTHROPIC_API_KEY=your_key_here

# Run
claude
```

Add the export to `~/.bashrc` or `~/.zshrc` to persist it.

---

## Option B: VPS + SSH (iOS, Android, or any device)

### Step 1 — Get a VPS

| Provider | Cheapest Plan | Notes |
|----------|--------------|-------|
| [Hetzner](https://hetzner.com) | ~€4/mo | Best value in Europe |
| [DigitalOcean](https://digitalocean.com) | $6/mo | Easy UI |
| [Vultr](https://vultr.com) | $2.50/mo | Cheapest option |

Pick Ubuntu 22.04 or Debian 12.

### Step 2 — Bootstrap your VPS

Copy `setup-claude-vps.sh` to your server and run it:

```bash
scp setup-claude-vps.sh user@your-vps-ip:~
ssh user@your-vps-ip
chmod +x setup-claude-vps.sh
./setup-claude-vps.sh
```

Or run it in one command:
```bash
bash <(curl -s https://raw.githubusercontent.com/jhanKarimov/jhankarimov.github.io/main/setup-claude-vps.sh)
```

### Step 3 — SSH from your phone

**Android:** Use Termux (you already have this!)
```bash
ssh user@your-vps-ip
```

**iOS:** [Termius](https://termius.com) (free tier works fine) or [SSH Files](https://apps.apple.com/app/ssh-files/id402015990)

### Step 4 — Run Claude Code on the VPS

```bash
claude
```

---

## Managing Files & Photos

Once you're in a Claude Code session on your server, you can organize files with natural language:

```
> organize the files in ~/uploads by date and file type
> find all jpg files larger than 5MB and move them to ~/large-photos
> rename all files in this folder to lowercase with dashes instead of spaces
```

To get photos from your phone to your VPS, use one of:

- **Termux:** `scp ~/storage/dcim/Camera/*.jpg user@vps:~/photos/`
- **iOS:** [a-Shell](https://apps.apple.com/app/a-shell/id1473805438) supports `scp`
- **Any device:** Sync via [rclone](https://rclone.org) with Google Drive/Dropbox as a bridge

---

## Keeping Claude Running (Persistent Sessions)

Use `tmux` so your session survives disconnects:

```bash
# Start a named session
tmux new -s claude

# Inside: run claude
claude

# Detach with Ctrl+B, then D
# Reattach later:
tmux attach -t claude
```

---

## Quick Reference

```bash
# Check Claude Code version
claude --version

# Run with a specific model
claude --model claude-opus-4-6

# Non-interactive one-off task
claude -p "list all .js files in ~/project and summarize what they do"

# Organize photos helper (see organize-files.sh)
./organize-files.sh ~/photos
```
