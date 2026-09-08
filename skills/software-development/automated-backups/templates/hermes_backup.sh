#!/bin/bash
# Hermes Memory Backup Script
# Backs up critical Hermes data to GitHub on a schedule
# Uses HTTPS (port 22 safe) with token auth
#
# Setup:
#   1. Copy this template to ~/.hermes/scripts/hermes_backup.sh
#   2. Replace USER, TOKEN, and REPO_URL with your values
#   3. chmod +x ~/.hermes/scripts/hermes_backup.sh
#   4. Test: bash ~/.hermes/scripts/hermes_backup.sh
#   5. Schedule: cronjob create --schedule "every 12h" --script hermes_backup.sh --no_agent

set -e

HERMES_DIR="$HOME/.hermes"
BACKUP_DIR="$HERMES_DIR/backup_tmp"
USER="YOUR_GITHUB_USERNAME"
TOKEN="YOUR_GITHUB_TOKEN"
REPO_URL="https://github.com/$USER/REPO_NAME.git"
DATE=$(date '+%Y-%m-%d %H:%M')

echo "=== Hermes Backup Started: $DATE ==="

# Ensure git identity is set (pitfall #6)
if ! git config --global user.email >/dev/null 2>&1; then
    git config --global user.email "bot@users.noreply.github.com"
    git config --global user.name "Backup Bot"
fi

# Always start from a safe directory (pitfall #4)
cd /data

# Clean previous temp backup
rm -rf "$BACKUP_DIR"
mkdir -p "$BACKUP_DIR"
cd "$BACKUP_DIR"

# Clone or update repo
if [ -d ".git" ]; then
    git remote set-url origin "https://${USER}:${TOKEN}@github.com/${USER}/REPO_NAME.git"
    git pull --rebase origin main 2>/dev/null || git pull --rebase origin master 2>/dev/null || true
else
    git clone "https://${USER}:${TOKEN}@github.com/${USER}/REPO_NAME.git" . 2>/dev/null || {
        echo "Creating new repo..."
        git init
        git remote add origin "https://${USER}:${TOKEN}@github.com/${USER}/REPO_NAME.git"
        git checkout -b main
    }
fi

git checkout main 2>/dev/null || git checkout master 2>/dev/null || git checkout -b main 2>/dev/null

# CRITICAL: Reset remote URL before commit (pitfall #2 — token leaking)
git remote set-url origin "$REPO_URL"

# Clean old files (except .git)
find . -maxdepth 1 -not -name '.git' -not -name '.' -exec rm -rf {} +

# === Backup Critical Files ===

# Memory (user profile + agent memory)
mkdir -p memories
cp "$HERMES_DIR/memories/MEMORY.md" memories/ 2>/dev/null || true
cp "$HERMES_DIR/memories/USER.md" memories/ 2>/dev/null || true

# Skills (skip binary caches and __pycache__)
mkdir -p skills
rsync -a --exclude='*.db' --exclude='*.lock' --exclude='__pycache__' --exclude='*.pyc' \
    "$HERMES_DIR/skills/" skills/ 2>/dev/null || cp -r "$HERMES_DIR/skills/"* skills/ 2>/dev/null || true

# Cron jobs
mkdir -p cron
cp -r "$HERMES_DIR/cron/"* cron/ 2>/dev/null || true

# State (skip binary DBs — may contain tokens, pitfall #1)
mkdir -p state
cp "$HERMES_DIR/state/gateway.heartbeat" state/ 2>/dev/null || true

# Config and personality
cp "$HERMES_DIR/config.yaml" config.yaml 2>/dev/null || true
cp "$HERMES_DIR/SOUL.md" SOUL.md 2>/dev/null || true
cp "$HERMES_DIR/channel_directory.json" channel_directory.json 2>/dev/null || true

# Hooks
mkdir -p hooks
cp -r "$HERMES_DIR/hooks/"* hooks/ 2>/dev/null || true

# Manifest
cat > MANIFEST.md << EOF
# Hermes Backup Manifest
**Last Backup:** $DATE
**Host:** $(hostname)
EOF

# Commit and push
git add -A
if git diff --cached --quiet; then
    echo "No changes to backup."
else
    git commit -m "Backup: $DATE"
    # Temporarily set auth URL for push only
    git remote set-url origin "https://${USER}:${TOKEN}@github.com/${USER}/REPO_NAME.git"
    git push origin main 2>/dev/null || git push origin master 2>/dev/null
    # Immediately reset URL after push
    git remote set-url origin "$REPO_URL"
    echo "Backup pushed successfully!"
fi

# Cleanup — cd out first (pitfall #4)
cd /data
rm -rf "$BACKUP_DIR"

echo "=== Hermes Backup Completed: $DATE ==="
