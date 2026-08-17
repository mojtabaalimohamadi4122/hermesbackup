# Hermes Backup Manifest

**Last Backup:** 2026-08-17 03:57
**Host:** 6ee18a0fc136

## Included:
- memories/MEMORY.md + USER.md (Agent & user memory)
- skills/ (All loaded skills)
- cron/ (Scheduled jobs)
- state/ (Runtime state - no binary DBs)
- config.yaml + SOUL.md
- hooks/
- channel_directory.json

## Excluded:
- cache/, audio_cache/, image_cache/ (temporary)
- logs/ (runtime logs)
- bin/ (binaries)
- state.db, kanban.db (binary - may contain tokens)
- auth.json, gateway_state.json (sensitive/runtime)
