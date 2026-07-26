---
name: multilingual-interaction
description: Handle non-English users and language preferences.
---

# Multilingual Interaction

Handle sessions where the user speaks a non-English language.

## Language Preference

1. When a user requests a specific language, save the preference immediately via memory.
2. Confirm in the user's language that you have registered the preference.
3. All subsequent responses must be in that language unless the user switches.

## Memory Tool Unicode Pitfall

The memory tool rejects content containing U+200C (zero-width non-joiner), which is pervasive in Persian, Arabic, Urdu, and other Perso-Arabic scripts.

### Workaround

When writing memory entries for non-Latin-script users, write entries in English or transliterated ASCII-safe text. Example: use "Name: Mojtaba" instead of the Persian script equivalent.

### Verification

After a memory call targeting a non-Latin-script user, check the response for success false. If blocked, retry with English content.

## Response Formatting for RTL Languages

Persian, Arabic, and Hebrew responses render correctly on Telegram. Mixed code blocks or inline code with Latin text inside RTL paragraphs is fine.

## First-Time User Onboarding (Non-English)

Follow the same system-prompt onboarding flow but in the user language. Keep it light and conversational.
