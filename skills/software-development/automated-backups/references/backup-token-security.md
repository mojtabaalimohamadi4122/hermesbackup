# Token Security for Backup Scripts

## The problem
Tokens embedded in HTTPS URLs (`https://user:TOKEN@github.com/...`) can leak in three ways:

1. **Binary DB files** — SQLite databases (state.db, kanban.db) can contain fragments of tokens in binary data. When committed, GitHub's push protection (error GH013) BLOCKS the push.
2. **Cron job output** — if a cron job echoes the token, it gets saved in the cron output directory and backed up.
3. **Persistent auth URL** — if you set `git remote set-url origin https://user:TOKEN@...` and never reset it, the token stays in `.git/config` on the machine AND is visible to anyone who reads the clone.

## Rules

1. **Never backup SQLite databases** — exclude `state.db`, `kanban.db`, `executions.db` (binary may contain token fragments → push blocked by GH013).
2. **Use temporary auth URL only for push** — set token URL before push, reset to clean URL after:
   ```bash
   git remote set-url origin "https://user:${TOKEN}@github.com/user/repo.git"
   git push origin main
   git remote set-url origin "https://github.com/user/repo.git"
   ```
3. **Never echo the token in script output** — cron saves all stdout to disk and backs it up.
4. **Store token in a file with restrictive permissions** — not inline in the script:
   ```bash
   TOKEN=$(cat ~/.hermes/.github_token)
   chmod 600 ~/.hermes/.github_token
   ```

## What to backup (text-only, safe)
- `memories/*.md` — user and agent memory
- `skills/` — all SKILL.md files and references
- `cron/jobs.json` + `cron/output/` — cron configs (⚠️ check for leaked tokens in output files)
- `config.yaml`, `SOUL.md`, `channel_directory.json`
- `scripts/` — custom scripts (⚠️ may contain tokens — verify before push)
- `hooks/` — custom hooks

## What to EXCLUDE (binary/sensitive)
- `state.db`, `kanban.db` — SQLite DBs, may contain tokens
- `auth.json` — contains API keys
- `gateway_state.json` — runtime state
- `cache/`, `logs/`, `audio_cache/`, `image_cache/` — temporary files
- `sessions/` — may contain full chat history with tokens
- `pairing/`, `runtime/` — transient state

## If GitHub blocks a push (GH013)
1. The blocked commit contains a secret — find it: `git log -p --all -S 'ghp_'`
2. Remove the file from tracking: `git rm --cached <file>`
3. Add to `.gitignore`
4. Amend the commit or create a new one (history rewrite may be needed)
5. If the token was already pushed: **revoke it immediately** at https://github.com/settings/tokens and generate a new one.
