---
name: vocabulary-to-anki
description: Convert PDF vocab to Anki decks with bidirectional cards.
triggers:
  - user has PDF vocabulary lists
  - user wants Anki decks with example sentences
---
# Vocabulary to Anki
Convert structured vocabulary lists (PDFs, textbooks, word lists) into Anki decks with bidirectional cards and example sentences.

## Trigger
- User has a PDF/textbook with structured vocabulary lists (e.g., '2001 Most Useful German Words').
- User wants to convert structured vocabulary lists into Anki decks.
- User needs bidirectional cards (German↔English) with example sentences.

## Workflow
### 1. Text Extraction from PDF
```bash
pdftotext input.pdf output.txt
# or for layout-aware extraction:
python3 -c "import fitz; doc=fitz.open('input.pdf'); print('\n'.join([p.get_text() for p in doc]))" > output.txt
```

### 2. Parse Structured Vocabulary Entries
- Split text by double-newline (`\n\n`) to separate entries.
- Find entries containing " to " pattern (verb entries).
- For each entry:
  - German word = text before " to " (first line of entry).
  - English translation = text after " to " until newline.
  - German example = next line after translation.
  - English example = line after German example.
- Filter for verbs: translation starts with "to ".
- Clean: strip whitespace, handle parentheses in German word.

### 3. Validation
- Spot-check 5-10 entries against known vocabulary.
- Verify German words are lowercase (verbs are lowercase in German).
- Verify English translations start with "to ".
- Check example sentences are present and non-empty.

### 4. Anki Deck Generation (genanki)
```python
import genanki

model = genanki.Model(
    model_id,
    'Vocabulary Model',
    fields=[{'name': 'German'}, {'name': 'English'}, {'name': 'GermanExample'}, {'name': 'EnglishExample'}],
    templates=[
        {'name': 'Forward', 'qfmt': '{{German}}<br>{{GermanExample}}', 'afmt': '{{German}}<br>{{GermanExample}}<hr>{{English}}<br>{{EnglishExample}}'},
        {'name': 'Reverse', 'qfmt': '{{English}}<br>{{EnglishExample}}', 'afmt': '{{English}}<br>{{EnglishExample}}<hr>{{German}}<br>{{GermanExample}}'},
    ]
)

for card in cards:
    note = genanki.Note(model=model, fields=[german, english, german_ex, english_ex])
    deck.add_note(note)

package = genanki.Package(deck)
package.write_to_file('output.apkg')
```

### 4. Card Model (Bidirectional)
- **Fields:** German, English, GermanExample, EnglishExample
- **Card 1 (Forward):** Front = German + GermanExample; Back = English + EnglishExample
- **Card 2 (Reverse):** Front = English + EnglishExample; Back = German + GermanExample
- Each verb → 2 cards (forward + reverse).

## Pitfalls
- **PDF text extraction quality:** `pdftotext` may lose formatting; use `pymupdf` for layout-aware extraction if needed.
- **Entry parsing edge cases:** Some entries span multiple lines; handle page breaks (form feeds `\f`).
- **Verb filtering:** Only filter "to " prefix for verbs; nouns/adjectives won't have this pattern.
- **German capitalization:** Verbs are lowercase; nouns are capitalized. Use this to filter.
- **Example sentence pairing:** German example always precedes English example in source.
- **Anki model IDs:** Use stable, unique model/deck IDs (hash of name) for reproducibility.
- **Encoding:** Always UTF-8 for CSV/APKG; genanki handles UTF-8 natively.

## Output
- `.apkg` file ready for Anki import (File → Import in Anki).
- Deck name: configurable (e.g., "German Verbs :: 2001 Most Useful Words").
- Each verb → 2 cards (forward + reverse).

## References
- `references/pdf-parsing.md` — PDF text extraction patterns.
- `references/anki-model-design.md` — Anki model design patterns.
