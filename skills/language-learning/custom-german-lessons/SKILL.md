---
name: custom-german-lessons
category: language-learning
description: "Pflege lessons: Persian output, tables, audio if asked."
metadata:
  hermes:
    requires_tools: ["execute_code"]
    requires_toolsets: []
    requires_plugins: []
---

# Custom German Lessons (Pflege Context)

## Trigger
User asks for a German word, phrase, or grammar explanation (e.g., "besonderes", "sollen", "Feiertagszuschlag").

## Procedure
1. **Identify the target item** (word, verb, noun, adjective, idiom).
2. **Prepare the lesson data**:
   - German headword + phonetic transcription (IPA).
   - Persian meaning (single line).
   - Full conjugation / declension tables (Präsens, Präteritum, Perfekt for verbs; Positiv/Komparativ/Superlativ for adjectives; article + plural for nouns).
   - **All example sentences must come from Pflegealltag** (Patient, Schicht, Wunddokumentation, Pflegebericht, Aufnahme, Visite, Medikamentengabe, etc.).
   - If the user explicitly asks "به المانی تعریفش رو بگو", give a short **Definition auf Deutsch** first.
3. **Format the response** exactly as:
   ```
   ### کلمه: **<headword>**
   * **تلفظ صوتی (Phonetisch):** [<IPA>]
   * **معنی:** <Persian meaning>

   #### 📊 جدول ...
   | ... |

   #### 🩺 مثال‌ها در محیط پرستاری (Pflegealltag)
   1. **<Context>**
      > **<German sentence>**
      > *(<Persian translation>)*
   ```
4. **Audio**: **Do NOT generate or send any audio (gTTS) unless the user explicitly requests it** (e.g., "ویس بده", "audio", "فایل صوتی"). When requested, generate a single combined MP3 with the headword, tables read aloud, and all example sentences, then embed with `[[audio_as_voice]]
MEDIA:/path/to/file.mp3`.
5. **Language of response**: **Persian only** – no English, no German explanations unless the user asks for a German definition.
6. **No filler** – no greetings, no "Great question", no restating the request.

## Pitfalls & Rules
- **Audio gate** – Generating audio for every word was the old rule; the user explicitly disabled it ("ویس نده تا موقعی که ازت نخواستم"). Violating this causes frustration.
- **Example domain** – Generic sentences (e.g., "Der Hund läuft") are unacceptable. Every sentence must reflect a nursing shift situation.
- **Table completeness** – Verbs need Präsens, Präteritum, Perfekt with haben/sein and separable prefix note. Adjectives need all three degrees. Nouns need article + plural + phonetic.
- **Persian-only output** – The user only reads Persian translations; any English or German prose outside the required definition is noise.
- **Single response** – All tables, examples, and optional audio must be in the same message.

## References
- `references/pflege-context-sentences.md` – reusable pool of Pflege‑specific sentence templates for verbs, nouns, adjectives.
- `references/german-phonetics.md` – quick IPA cheat‑sheet for the agent.
