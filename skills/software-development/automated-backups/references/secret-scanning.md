# GitHub Secret Scanning & Backup Pitfalls

## Secret Scanning Blocks Pushes

GitHub's **Push Protection** scans commits for tokens (PATs, API keys, etc.) and rejects pushes that contain them — even inside binary files.

### Symptoms

```
remote: error: GH013: Repository rule violations found for refs/heads/main.
remote: - Push cannot contain secrets
remote:     - GitHub Personal Access Token
remote:       locations:
remote:         - path: sessions/state.db:449
```

### Root Cause

When a git token is embedded in a URL (`https://TOKEN@github.com/...`), it can leak into:
- **SQLite databases** (state.db, kanban.db) that record git operations or credentials
- **Log files** that echo commands with the token
- **Config files** that store the remote URL

### Fix

1. **Exclude binary/DB files** that may contain tokens:
   ```bash
   find . -name "*.db" -delete
   ```
2. **Reset the remote URL after push** (remove token from URL):
   ```bash
   git remote set-url origin https://github.com/user/repo.git
   ```
3. **Use environment variables** instead of embedding tokens in URLs when possible
4. **If blocked**, the user can unblock via:
   `https://github.com/<owner>/<repo>/security/secret-scanning/unblock-secret/<id>`

## Hermes Backup to GitHub Pattern

### What to Backup
- `memories/MEMORY.md` + `USER.md` (agent & user memory)
- `skills/` (all loaded skills — largest component, ~8MB)
- `cron/` (scheduled jobs)
- `config.yaml`, `SOUL.md`, `channel_directory.json`

### What to EXCLUDE (security)
- `state.db`, `kanban.db` — binary SQLite files that may contain tokens
- `auth.json` — contains credentials
- `gateway_state.json` — runtime state
- `cache/`, `audio_cache/`, `image_cache/` — temporary data
- `logs/` — runtime logs

### Script Pattern
```bash
#!/bin/bash
set -e
HERMES_DIR="$HOME/.hermes"
BACKUP_DIR="$HERMES_DIR/backup_tmp"
TOKEN="ghp_..."
REPO_URL="https://github.com/user/repo.git"

rm -rf "$BACKUP_DIR" && mkdir -p "$BACKUP_DIR"
cd "$BACKUP_DIR"

git clone "https://user:${TOKEN}@github.com/user/repo.git" . 2>/dev/null || git init
git remote set-url origin "$REPO_URL"  # Remove token from URL

# Copy critical files (exclude .db, .lock, __pycache__)
rsync -a --exclude='*.db' --exclude='*.lock' --exclude='__pycache__' \
    "$HERMES_DIR/skills/" skills/
cp "$HERMES_DIR/memories/"*.md memories/
cp "$HERMES_DIR/config.yaml" "$HERMES_DIR/SOUL.md" ./

# Commit and push
git add -A
git diff --cached --quiet || {
    git commit -m "Backup: $(date '+%Y-%m-%d %H:%M')"
    git remote set-url origin "https://user:${TOKEN}@github.com/user/repo.git"
    git push origin main
    git remote set-url origin "$REPO_URL"  # Reset after push
}
cd "$HERMES_DIR" && rm -rf "$BACKUP_DIR"
```

### Hermes Cron Setup
```
cronjob create --schedule "every 12h" --script backup.sh --no_agent
```
