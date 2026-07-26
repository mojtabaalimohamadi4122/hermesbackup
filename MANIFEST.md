# Hermes Backup Manifest

**Last Backup:** 2026-07-26 23:26
**Host:** eb4c641a6052
**Backup Size:** 8.6M

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
