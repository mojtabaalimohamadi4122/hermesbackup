---
name: automated-backups
description: "Set up and restore Hermes Agent backups to GitHub."
version: 0.1.0
author: Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [backup, github, restore, cron]
    related_skills: [financial-monitoring, github-auth]
---

# Hermes Backup & Restore

Automate daily backups of Hermes configuration, skills, memories, and cron jobs to a private GitHub repository, and restore them when needed.

## When to Use

- User asks to set up automated backups for Hermes Agent
- User needs to restore Hermes from a previous backup
- User wants to verify backup integrity or test backup scripts

## Prerequisites

- GitHub personal access token with `repo` scope
- `git` installed and configured
- Access to `~/.hermes` directory

## Procedure

### 1. Create Backup Script

Create `~/.hermes/scripts/hermes_backup.sh` from the template in `templates/hermes_backup.sh`.

Fill in:
- `USER` = GitHub username
- `TOKEN` = personal access token (classic)
- `REPO_URL` = `https://github.com/<USER>/<repo>.git`

Make executable: `chmod +x ~/.hermes/scripts/hermes_backup.sh`

### 2. Schedule Backup Job

```bash
cronjob(action='create', schedule='every 720m', script='hermes_backup.sh', deliver='origin', no_agent=True)
```

This runs every 12 hours and pushes changes to the repo.

### 3. Test Backup

Run the script manually to verify it works:
```bash
bash ~/.hermes/scripts/hermes_backup.sh
```

Check that the commit appears on GitHub.

### 4. Restore from Backup

To restore a backup from GitHub:

```bash
cd /data
git clone https://<TOKEN>@github.com/<USER>/<repo>.git hermesbackup
cd hermesbackup

# Restore memories
cp memories/*.md ~/.hermes/memories/

# Restore skills (recursively!)
for d in skills/*/; do
  cp -r "$d" ~/.hermes/skills/
done

# Restore cron jobs
cp -r cron/* ~/.hermes/cron/

# Restore config (merge, don't overwrite if you want to keep current model)
cp SOUL.md ~/.hermes/
cp channel_directory.json ~/.hermes/

# Restore backup script
cp scripts/hermes_backup.sh ~/.hermes/scripts/
chmod +x ~/.hermes/scripts/hermes_backup.sh

# Clean up
rm -rf /data/hermesbackup
```

**⚠️ CRITICAL: Always restore skills RECURSIVELY.**
The backup stores skills in a tree (e.g., `skills/software-development/automated-backups/`).
Copying only top-level directories will miss nested skills.

### 5. Verify Restore

After restore:
- Check that `~/.hermes/memories/USER.md` and `MEMORY.md` exist
- Verify `~/.hermes/skills/` contains all expected categories and skills
- Run `bash ~/.hermes/scripts/hermes_backup.sh` to confirm backup script works
- Check cron jobs: `cronjob(action='list')`

## Pitfalls

1. **Never backup SQLite databases (state.db, kanban.db)** — they may contain tokens in binary data that trigger GitHub push protection (GH013).

2. **Use temporary auth URL only for push** — set token URL before push, reset to clean URL after:
   ```bash
   git remote set-url origin "https://user:${TOKEN}@github.com/..."
   git push origin main
   git remote set-url origin "https://github.com/user/repo.git"
   ```

3. **Skills must be restored recursively** — the backup tree mirrors `~/.hermes/skills/` structure. A shallow copy misses nested skills like `software-development/automated-backups/`.

4. **When restoring config.yaml, decide on model** — the backup may have a different default model. Either merge carefully or keep the current config and only add missing sections (aliases, delegation).

5. **Cron jobs store execution history** — restoring `cron/jobs.json` will overwrite current job states. If you only want the jobs without history, edit the file to clear `last_run_at`, `last_status`, etc.

6. **Token security** — see `references/backup-token-security.md` for detailed token leak prevention.

## Verification

- Backup script runs without error
- Commit appears on GitHub with updated timestamp
- Restore process copies all files without missing nested skills
- Cron job appears in `cronjob(action='list')` and runs on schedule

## References

- `trading/financial-monitoring/references/backup-token-security.md` — Token leak prevention
- `templates/hermes_backup.sh` — Backup script template
