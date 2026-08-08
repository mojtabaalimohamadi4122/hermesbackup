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
- Has a **diploma in Emergency Medical Services** (not BSN nursing) — medical context is relevant
- Planning to migrate to Germany via **Ausbildung in nursing** (Pflegeausbildung)
- Prefers explanations in **Persian (Farsi) only**
- Wants **audio pronunciation** for every word/phrase
- Prefers gTTS audio over edge TTS (robotic-sounding)
- Always wants **past tense for verbs** and **plural for nouns** in every word lookup

## MANDATORY Response Format for Every German Word

User explicitly requested these for EVERY word lookup:

### For VERBS — ALWAYS include past tense:
1. **Präsens** (present) — full conjugation table
2. **Perfekt** (compound past) — full conjugation + Partizip II form
3. **Präteritum** (simple past) — full conjugation
4. Note whether verb uses **haben** or **sein** in Perfekt
5. Note whether separable (trennbar) or inseparable (untrennbar)
6. Note -ieren verbs that skip ge- prefix

### For NOUNS — ALWAYS include plural form:
1. **Singular** with article (der/die/das)
2. **Plural** form with article
3. Plural pattern if applicable (-er, -en, -e, Umlaut, etc.)
4. Genitive form if useful

### For ALL words — ALWAYS include:
1. Word breakdown (etymology if helpful)
2. Multiple meanings if applicable (table format)
3. 3+ example sentences with Persian translation
4. gTTS audio pronunciation
5. AnkiDroid tip (medical context when possible)

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
| "Ergenzung" | **Ergänzung** | ä → ae if ä not available |
| "Unterschift" | **Unterschrift** | remember final -t |
| "Sache" (meaning object) | **Gegenstand** | Sache = thing/matter (abstract); Gegenstand = physical object |

## Key Verb Distinctions

### aufstehen vs. stehen
| Verb | Partizip II | Meaning |
|------|-------------|---------|
| **aufstehen** | aufgestanden (sein!) | To get up / wake up |
| **stehen** | gestanden (sein!) | To stand / be standing |

Both use **sein** in Perfekt (not haben) because they describe change of state.
- *Ich bin um 6 Uhr **aufgestanden**.* (I got up at 6)
- *Ich bin lange **gestanden**.* (I stood for a long time)

### kaufen vs. einkaufen
| Verb | Meaning | Usage |
|------|---------|-------|
| **kaufen** | to buy (specific item) | *Ich habe ein Handy gekauft.* |
| **einkaufen** | to go shopping | *Ich habe im Mall eingekauft.* |

### tauchen vs. tauchen (spelling trap!)
| Word | Spelling | Meaning | Pronunciation |
|------|----------|---------|---------------|
| **tauchen** | t-a-u-**ch**-en | to dive | tao-khen (خ) |
| **tauschen** | t-a-u-**sch**-en | to exchange | tao-shen (ش) |

### Passen + Dativ (always!)
- *Das passt **dir**.* (correct) ✅
- *Das passt **dich**.* (wrong!) ❌

### auf der Straße vs. in der Straße
| Phrase | Meaning |
|--------|---------|
| **auf der Straße** | ON the street (surface/asphalt) |
| **in der Straße** | IN the street (address/area) |

## Compound Noun Patterns

German loves compound nouns. Key patterns for A2:

| Pattern | Example | Breakdown |
|---------|---------|-----------|
| Liebling + Noun | **Lieblingsland** | favorite country |
| Arbeit + Noun | **Arbeitsstelle** | workplace |
| Vorstellung + Noun | **Vorstellungsgespräch** | job interview |
| Einkauf + Noun | **Einkaufszentrum** | shopping center |
| Nachtschicht | Nacht + Schicht | night shift |

Rule: Compound nouns always get the gender of the LAST word and are always capitalized.

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

## Reflexive Verbs Deep-Dive (sich + verb)

When user asks about a reflexive verb like `sich vorstellen`, provide:

### Conjugation Table:
| Person | Reflexive Pronoun | Example |
|--------|------------------|---------|
| ich | mich | Ich stelle **mich** vor. |
| du | dich | Du stellst **dich** vor. |
| er/sie/es | sich | Er stellt **sich** vor. |
| wir | uns | Wir stellen **uns** vor. |
| ihr | euch | Ihr stellt **euch** vor. |
| sie/Sie | sich | Sie stellen **sich** vor. |

### Key distinction:
- **Reflexive with Akkusativ** (no preposition): *sich vorstellen* (introduce oneself)
- **Reflexive with Dativ** (with preposition like "etwas"): *sich etwas vorstellen* (imagine something) — note the pronoun changes to **mir/dir**!

## The Dual Form of "hängen" (Transitive vs Intransitive)

**hängen** has TWO different conjugation patterns depending on whether it's transitive or intransitive. This is a major trap for A2 learners!

| Type | Meaning | Partizip II | Perfekt helper | Präteritum |
|------|---------|-------------|----------------|------------|
| **intransitive** (no object) | to hang (be suspended) | gehangen | **sein** | hing |
| **transitive** (with object) | to hang (something) | gehangen | **haben** | hängte |

### Examples:
- **Das Bild hängt an der Wand.** (The picture hangs on the wall.) — intransitive
- **Ich hänge das Bild auf.** (I hang the picture up.) — transitive
- **Das Bild hat gehangen.** (The picture has been hanging.) — sein!
- **Ich habe das Bild gehangen.** (I have hung the picture.) — haben!
- **Das Bild hing an der Wand.** (The picture was hanging.) — Präteritum: hing
- **Ich hängte das Bild auf.** (I hung the picture up.) — Präteritum: hängte

### Pitfall:
The Partizip II is the SAME for both (gehangen), but the Perfekt helper verb and Präteritum form are DIFFERENT. Always check if there's a direct object to determine which pattern to use.

### Medical context:
- **Die Infusion hängt am Tropf.** (The IV drip is hanging.) — intransitive, sein
- **Bitte hängen Sie den Tropf auf.** (Please hang up the drip.) — transitive, haben

## "In Kontakt bleiben" Pattern (Staying in Contact)

This is a very common phrase using **bleiben** (to stay/remain) + prepositional phrase.

### Key forms:
| Time | Form | Example |
|------|------|---------|
| Präsens | ich bleibe | Ich **bleibe** in Kontakt. |
| Perfekt | ich bin geblieben | Ich **bin** in Kontakt **geblieben**. |
| Präteritum | ich blieb | Ich **blieb** in Kontakt. |

**Note:** bleiben uses **sein** in Perfekt (change of state/location).

### Common phrase patterns with bleiben:
- **in Kontakt bleiben** — to stay in touch
- **in Berührung bleiben** — to stay in contact
- **am Ball bleiben** — to stay on track (idiom)
- **sitzen bleiben** — to fail a class (school)

## Inversion Pattern (Sentence Starts with Prepositional Phrase)

When a sentence begins with a prepositional phrase (adverb of place/time), the verb and subject swap positions:

**Normal:** Das Bild **hängt** an der Wand. (Subject + Verb)
**Inversion:** An der Wand **hängt** das Bild. (Prepositional phrase + Verb + Subject)

### Common patterns:
- **An der Wand hängt das Bild.** (On the wall hangs the picture.)
- **Auf dem Tisch steht die Vase.** (On the table stands the vase.)
- **Im Zimmer liegt der Hund.** (In the room lies the dog.)
- **Am Fenster sitzt die Katze.** (At the window sits the cat.)

### Why this matters:
This pattern is EXTREMELY common in German and appears in A2/B1 exams. The rule is simple: if a prepositional phrase starts the sentence, the verb takes position #2 and the subject moves after it.

## Verbs with "umher-" Prefix

The prefix **umher-** means "around" and creates separable verbs:
- **umhergehen** = to walk around, to stroll
- **umherlaufen** = to run around
- **umhersitzen** = to sit around

These follow standard trennbar rules: *Ich gehe umher.* (not *Ich umhergehe.*)

## Medical Context Vocabulary

Since the user is a nurse, always include medical examples when available:
- **Stelle** → *Die betroffene Stelle* (the affected area)
- **Verteilen** → *Die Medikamente verteilen* (distribute medications)
- **aufstehen** → *Können Sie aufstehen?* (Can you stand up?)
- **Durchatmen** → *Lass uns durchatmen.* (Let's take a deep breath)
- **freundlich aussehen** → *Der Patient sieht blass aus.* (The patient looks pale)

## References

- `references/german-grammar-basics.md` — Quick reference for case system and verb conjugation
- `references/medical-german.md` — Medical/pflege terminology in German
- `references/common-errors.md` — Frequent A2-level mistakes and corrections
