---
name: language-learning-automation
description: Convert textbook images to Anki cards via local OCR.
triggers:
  - user provides images of vocabulary lists
  - need to generate Anki flashcards from physical media
---
# Language Learning Automation
Use when converting physical textbooks, screenshots, or images into digital flashcards (Anki).

## Trigger
- User provides images of vocabulary lists.
- User needs example sentences and translations for a list of words.
- Goal is to import data into Anki/AnkiDroid.

## Workflow
1. **Extraction (Local OCR):** If Vision APIs (Gemini/GPT-4V) are rate-limited or fail to see fine text, pivot immediately to `tesseract`. 
   - Use `tesseract <file> stdout -l deu+eng --psm 6`.
   - Iterate through PSM modes (3, 6, 11) if the first pass is garbage.
2. **Refinement:** Use the LLM to clean OCR artifacts and group words by theme (e.g., Colors, Jobs, Greetings).
3. **Augmentation:** For each word, generate:
   - Target language example sentence (natural and simple).
   - Translation of the word.
   - Translation of the example sentence.
4. **Export:** Format as a Tab-Separated CSV (`.csv` or `.txt`).
   - Front: `<b>Word</b><br><br><small><i>Example</i></small>`
   - Back: `<b>Translation</b><br><br><small>Example Translation</small>`

## Pitfalls
- **API Limits:** Batch processing 20+ images via Vision APIs often triggers HTTP 429. Local OCR is more resilient.
- **RTL Support:** Ensure Persian/Arabic translations are handled correctly in the CSV (UTF-8 encoding is mandatory).
- **Format:** Anki requires specific delimiters (usually Tab `\t`) to avoid breaking on commas in sentences.

## References
- [references/anki-textbook-ocr.md](references/anki-textbook-ocr.md) — Case study: 21-page German textbook processing.
