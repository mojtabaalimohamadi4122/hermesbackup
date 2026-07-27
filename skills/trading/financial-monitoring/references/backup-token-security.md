# GitHub Backup: Token Security Pitfalls

## Problem: Tokens leak into git history
When using HTTPS with embedded tokens (`https://user:TOKEN@github.com/...`), the token
can get written into binary files (SQLite .db files) that are then committed and pushed.

GitHub's push protection (GH013) scans for secrets and BLOCKS the push if a token is found.

## Symptoms
```
remote: - GITHUB PUSH PROTECTION
remote:   Push cannot contain secrets
remote:   locations:
remote:     - commit: abc123
remote:       path: sessions/state.db:449
```

## Solution
1. **Exclude binary DB files** from backup:
   ```bash
   # Don't backup state.db, kanban.db — they may contain tokens in binary data
   cp "$HERMES_DIR/state/gateway.heartbeat" state/  # only text files
   ```

2. **Use temporary auth URL only for push:**
   ```bash
   # Set auth URL before push
   git remote set-url origin "https://user:${TOKEN}@github.com/..."
   git push origin main
   # Reset to clean URL after push
   git remote set-url origin "https://github.com/user/repo.git"
   ```

3. **Alternative: Use .netrc for auth** (more secure):
   ```
   # ~/.netrc
   machine github.com
   login mojtaba
   password ghp_xxxxx
   ```
   Then clone without token in URL: `git clone https://github.com/user/repo.git`

## What to backup (text-only, safe)
- `memories/*.md` — user and agent memory
- `skills/` — all SKILL.md files and references
- `cron/` — cron job configs
- `config.yaml`, `SOUL.md`, `channel_directory.json`
- `hooks/` — custom hooks

## What to EXCLUDE (binary/sensitive)
- `state.db`, `kanban.db` — SQLite DBs that may contain tokens
- `auth.json` — contains API keys
- `gateway_state.json` — runtime state
- `cache/`, `logs/`, `audio_cache/`, `image_cache/` — temporary files
