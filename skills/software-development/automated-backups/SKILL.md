---
name: automated-backups
description: "Scheduled backup to GitHub — token safety and cron."
version: 1.1.0
author: Hermes Agent
license: MIT
tags: [backup, github, cron, automation, secret-scanning]
---

# Automated Data Backups

Patterns for backing up sensitive data (Hermes memory, configs, skills) to remote Git repositories on a schedule. Covers token safety, secret scanning, and cron integration.

## When to Use

- User asks to back up Hermes data, memories, skills, or configs to GitHub/GitLab
- User wants automated scheduled backups
- User needs to push binary files that may contain secrets

## Key Pitfalls

### 1. GitHub Secret Scanning Blocks Token-Leaked Pushes

GitHub's Push Protection scans for PATs in commits — including inside binary files like SQLite databases. If `state.db` records a git operation with an embedded token, the push will be rejected with `GH013`.

**Fix:** Exclude `.db` files and other binaries that may contain tokens. See `references/secret-scanning.md` for details.

### 2. Token in Remote URL Leaks to Git Config

When cloning with `https://TOKEN@github.com/...`, the token persists in `.git/config`. Always reset the remote URL after push:
```bash
git remote set-url origin https://github.com/user/repo.git
```

### 3. Port 22 Closed → HTTPS-Only with Token Auth

Many cloud environments block outbound SSH (port 22). Use HTTPS with an embedded token:
```bash
git clone "https://USER:${TOKEN}@github.com/user/repo.git"
```
**Critical:** Set the auth URL only for clone/push, then reset to the clean URL immediately after:
```bash
# Before push
git remote set-url origin "https://USER:${TOKEN}@github.com/user/repo.git"
git push origin main
# After push — always clean up
git remote set-url origin https://github.com/user/repo.git
```

### 4. `cd` into a Directory You Just Deleted

After `rm -rf "$BACKUP_DIR"`, if the shell's CWD was inside that directory, subsequent commands fail with "No such file or directory". Always `cd` to a safe path before removing:
```bash
cd /data  # or any known-good path
rm -rf "$BACKUP_DIR"
mkdir -p "$BACKUP_DIR"
cd "$BACKUP_DIR"
```

### 5. What to Backup vs. Exclude

| Include | Exclude |
|---------|---------|
| `memories/*.md` | `state.db`, `kanban.db` (may contain tokens) |
| `skills/` (rsync, skip `__pycache__`) | `auth.json`, `gateway_state.json` |
| `cron/` | `cache/`, `audio_cache/`, `image_cache/` |
| `config.yaml`, `SOUL.md` | `logs/`, `bin/`, `*.lock` |
| `hooks/` | `models_dev_cache.json`, `provider_models_cache.json` |

### 6. Git Author Identity Required Before First Commit

Fresh containers or root-owned environments have no git identity configured. The first `git commit` fails with `Author identity unknown` / `fatal: unable to auto-detect email address`. Set this **before** the first backup run:
```bash
git config --global user.email "bot@users.noreply.github.com"
git config --global user.name "Backup Bot"
```
Include this check at the top of backup scripts for robustness.

## Backup Script Template

See `templates/hermes_backup.sh` for a complete, production-ready backup script that:
- Clones/updates the remote repo via HTTPS (port 22 safe)
- Backs up memories, skills, cron, config, hooks
- Excludes binary DBs and sensitive files
- Commits and pushes with token auth
- Cleans up temp directory after each run
- Resets remote URL to avoid token leaking in `.git/config`

## Hermes Cron Integration

For simple script-only backups (no LLM needed):
```
cronjob create --schedule "every 12h" --script backup.sh --no_agent
```
- `no_agent=True` skips the LLM — script runs directly
- Empty stdout = silent (no notification sent)
- Non-zero exit = error alert sent

## References

- `references/secret-scanning.md` — GitHub secret scanning details and unblock workflow
