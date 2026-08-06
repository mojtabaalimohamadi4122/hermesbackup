---
name: german-language-learning
description: "German vocab, grammar, and pronunciation with gTTS audio."
version: 1.0.0
author: Hermes Agent
license: MIT
tags: [german, language-learning, tts, vocabulary, grammar, anki, pronunciation]
---

# German Language Learning Assistance

Patterns for helping users learn German: vocabulary lookups, grammar breakdowns, sentence construction, and audio pronunciation generation.

## When to Use

- User asks for meaning/translation of a German word or phrase
- User wants German audio pronunciation of words, phrases, or sentences
- User asks about German grammar (cases, verb conjugation, word order)
- User wants to build AnkiDroid flashcards for German
- User constructs a German sentence and wants review/correction

## TTS for German Pronunciation

### Preferred: gTTS (Google Text-to-Speech Python library)

The built-in `text_to_speech` tool with `edge` provider produces **robotic-sounding German** that users reject. Always use the `gTTS` Python library for German audio:

```python
from gtts import gTTS
tts = gTTS('Die Frau steht in der Küche.', lang='de')
tts.save('/data/.hermes/cache/audio/example.mp3')
```

Then deliver with `MEDIA:/data/.hermes/cache/audio/example.mp3`.

**Install if needed:** `pip install gtts` (usually pre-installed).

### Fallback: OpenAI or Gemini TTS

If gTTS fails, try `text_to_speech` with `provider='openai'` (requires valid API key). Edge TTS is the last resort — warn the user it may sound robotic.

### Pitfall: Raw Google Translate curl TTS Returns HTML

Attempting to download audio directly from Google Translate via curl:
```bash
curl -G --data-urlencode "text=Hallo" "https://translate.google.com/translate_tts?..."
```
**This returns an HTML page, NOT audio.** Always use the gTTS Python library instead.

## Vocabulary Lookup Pattern

When the user asks about a German word or phrase, follow this structure:

### 1. Title with pronunciation guide
```
**die/der/das [Wort]**
🔊 تلفظ: [phonetic in Persian]
```

### 2. Meaning
- Primary meaning in Persian
- Secondary meanings if the word has multiple uses (provide a table)

### 3. Grammar breakdown
- Gender (der/die/das)
- Plural form
- Case usage (Nominativ, Akkusativ, Dativ)
- Separable vs. inseparable verb prefix (if applicable)

### 4. Example sentences (3+ examples)
- Each with Persian translation
- Progressive complexity (simple → complex)

### 5. Audio pronunciation via gTTS
- Generate audio with gTTS, lang='de'
- Include 2-3 sentences for natural intonation

### 6. AnkiDroid tip
- Practical note for flashcard creation
- Common usage context (medical, daily life, etc.)

## Grammar Concepts to Explain

When discussing German grammar, always provide:
- **Table format** for declensions/conjugations
- **Concrete examples** (not just rules)
- **Comparison with Persian** where helpful (e.g., no gender in Persian)
- **Audio** for each example sentence

### Key Grammar Topics (by frequency of user questions):
1. **Cases** (Nominativ, Akkusativ, Dativ, Genitiv)
2. **Separable vs. inseparable verbs** (trennbar/untrennbar)
3. **Reflexive verbs** (sich + verb)
4. **Word order** (V2 rule, Nebensätze with verb at end)
5. **Modal verbs** (können, müssen, sollen, etc.)
6. **Plural forms** (no single rule — must be memorized)

## Sentence Review Pattern

When user submits a German sentence for review:
1. Confirm if correct (✅/❌)
2. If incorrect, show the error clearly with a table
3. Explain the grammar rule
4. Provide 2-3 similar example sentences
5. Generate audio of the corrected sentence

## Language Context

This user:
- Is learning German at **A2 level** (started recently)
- Uses **AnkiDroid** for vocabulary flashcards
- Is a **nurse** (medical context is relevant)
- Prefers explanations in **Persian (Farsi) only**
- Wants **audio pronunciation** for every word/phrase
- Prefers gTTS audio over edge TTS (robotic-sounding)

## Verb Conjugation Deep-Dive Pattern

When user asks for a verb's full conjugation (e.g., "صرف passen رو بیار"), provide:

### Structure:
1. **Bedeutung (Meanings)** — table of all meanings with short examples
2. **Präsens (Present)** — full conjugation table with example per person
3. **Perfekt (Past)** — full conjugation (watch for ge- prefix rules!)
4. **Befehlsform (Imperative)** — du/ihr/Sie forms
5. **Verneinung (Negation)** — negative examples
6. **Beispiele (Examples)** — grouped by meaning/use case
7. **gTTS audio** — generate audio of 4-5 key phrases

### Key Grammar Points to Include:
- Whether verb is trennbar (separable) or untrennbar (inseparable)
- Whether verb is reflexiv (sich + verb) and which case (Akk/Dat)
- Whether verb takes Dativ or Akkusativ
- -ieren verbs: NO ge- in Partizip II (studiert, not gestudiert)

## Common Errors & Corrections

Watch for these frequent mistakes from A2 learners:

| Error | Correction | Rule |
|-------|-----------|------|
| "mann" (double n, lowercase) | **man** (single n) | "man" = indefinite pronoun; "Mann" = man (noun, capital M) |
| "lieblingsland" | **Lieblingsland** | Compound nouns always capitalized |
| "gestudiert" | **studiert** | -ieren verbs: no ge- prefix in Partizip II |
| "Der Frau" (wrong article) | **die Frau** | die = feminine; der = masculine |
| "ich habe gelernt" (for university) | **ich habe studiert** | lernen = learn/school; studieren = university |

## Comparative & Superlative (Komparativ & Superlativ)

### Formation:
| Level | Pattern | Example |
|-------|---------|---------|
| Positiv | adjektiv | groß |
| Komparativ | adjektiv + **-er** | gr**oß**er |
| Superlativ | am + adjektiv + **-sten** | am gr**oß**ten |

### Irregular Forms (must memorize!):
| Positiv | Komparativ | Superlativ |
|---------|-----------|------------|
| gut | besser | am besten |
| viel | mehr | am meisten |
| gern | lieber | am liebsten |

### Usage in Sentences:
- **als** (than): Berlin ist größer **als** München.
- **so ... wie** (as ... as): Er ist so groß **wie** ich.
- **am ...sten** (the most): Das ist **am** schön**sten**.

## "aussehen" + Adjektiv Pattern (Looking Like / Appearance)

**aussehen** (to look / to appear) is a separable verb frequently used with adjectives to describe appearance. Always takes **Dativ** for the person.

### Structure: Subject + sieht + Adjektiv + aus

| Person | Example | Translation |
|--------|---------|-------------|
| ich | Ich sehe müde **aus**. | I look tired. |
| du | Du siehst nett **aus**. | You look nice. |
| er/sie | Sie sieht freundlich **aus**. | She/You look friendly. |
| wir | Wir sehen gut **aus**. | We look good. |

### Common adjective combos:
- **gut aussehen** = to look good
- **schlecht aussehen** = to look bad/ill
- **müde aussehen** = to look tired
- **freundlich aussehen** = to look friendly
- **lecker aussehen** = to look delicious (for food)
- **blass aussehen** = to look pale (medical!)

## Preposition Nuances: "auf der Straße" vs "in der Straße"

A subtle but important distinction for A2 learners:

| Phrase | Meaning | Usage |
|--------|---------|-------|
| **auf der Straße** | ON the street (surface) | Physical location on asphalt/road surface |
| **in der Straße** | IN the street (address/area) | Address, neighborhood, buildings in that street |

### Examples:
- *Die Kinder spielen **auf der Straße**.* (Kids play ON the street — on the road surface)
- *Ich wohne **in der Goethestraße**.* (I live IN Goethe Street — at that address)

### General rule:
- **auf** + Dativ = on a surface (auf dem Tisch, auf der Straße)
- **in** + Dativ = inside a location/area (in der Küche, in der Straße)

## Translations for "Suitable" (Multiple German Equivalents)

When user asks about "suitable" or similar English words, provide ALL common German equivalents with nuance differences:

| German | Focus | Example |
|--------|-------|---------|
| **geeignet** | Right for a specific purpose/role | *Ist er für diesen Job geeignet?* |
| **passend** | Fits/matches (size, style, timing) | *Das Kleid ist passend.* |
| **angemessen** | Appropriate/proper (formal) | *Ein angemessenes Gehalt.* |

Always present as a comparison table so the learner understands when to use which.

## Umlaut Pronunciation Guide

| Letter | Sound | Example |
|--------|-------|---------|
| **ä** | like "e" in "bed" | Männer = men-er |
| **ö** | round lips, say "e" | schön = shön (rounded) |
| **ü** | round lips, say "ee" | grün = groon (rounded) |
| **ß** (Eszett) | always "ss" sound | groß = gross |
| **st** (beginning) | "sht" | Straße = shtrah-se |
| **st** (middle/end) | "st" | Fenster = fen-ster |
| **sch** | "sh" | Schule = shoo-le |
| **ch** (after a/o/u) | soft "kh" | Buch = bookh |
| **ch** (after e/i) | soft "sh/h" | ich = ish |
| **ei** | "eye" | mein = mine |
| **ie** | "ee" | die = dee |
| **eu/äu** | "oy" | heute = hoy-te |

## References

- `references/german-grammar-basics.md` — Quick reference for case system and verb conjugation
- `references/medical-german.md` — Medical/pflege terminology in German
- `references/common-errors.md` — Frequent A2-level mistakes and corrections
