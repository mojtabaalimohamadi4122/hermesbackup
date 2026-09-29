# Anki Model Design Patterns

## Card Model Structure

### Bidirectional Vocabulary Cards
```python
model = genanki.Model(
    model_id,
    'Vocabulary Model',
    fields=[
        {'name': 'German'},
        {'name': 'English'},
        {'name': 'GermanExample'},
        {'name': 'EnglishExample'},
    ],
    templates=[
        {
            'name': 'Forward',
            'qfmt': '{{German}}<br>{{GermanExample}}',
            'afmt': '{{German}}<br>{{GermanExample}}<hr>{{English}}<br>{{EnglishExample}}'
        },
        {
            'name': 'Reverse',
            'qfmt': '{{English}}<br>{{EnglishExample}}',
            'afmt': '{{English}}<br>{{EnglishExample}}<hr>{{German}}<br>{{GermanExample}}'
        },
    ],
    css='''
.card {
    font-family: Arial, sans-serif;
    text-align: center;
    padding: 20px;
    background: #fafafa;
}
'''
)
```

## Card Templates Explained

### Forward Card (German → English)
- **Front:** German word + German example sentence
- **Back:** English translation + English example sentence

### Reverse Card (English → German)
- **Front:** English word + English example sentence
- **Back:** German word + German example sentence

## CSS Styling Best Practices
```css
.card {
    font-family: Arial, sans-serif;
    text-align: center;
    padding: 20px;
    background: #fafafa;
}
hr {
    margin: 15px 0;
    border: 0;
    border-top: 1px solid #ecf0f1;
}
```

## Model ID Generation
```python
import hashlib
model_id = int(hashlib.md5(b'Vocabulary Model').hexdigest()[:8], 16)
```

## Card Types

### 1. Basic (Front/Back)
- Simple Q/A
- Not recommended for vocabulary with examples

### 2. Cloze Deletion
```python
templates=[{
    'name': 'Cloze',
    'qfmt': '{{cloze:Text}}',
    'afmt': '{{cloze:Text}}',
}]
```
Use for fill-in-the-blank exercises.

### 3. Bidirectional (Recommended for Vocabulary)
- Two templates per model
- Each note creates 2 cards
- Best for bidirectional recall

## Field Design

| Field | Purpose | Example |
|-------|---------|---------|
| German | Target word | `abholen` |
| English | Translation | `pick up` |
| GermanExample | Context sentence | `Die Mutter holt die Kinder ab.` |
| EnglishExample | Translation | `The mother picks up the children.` |

## Styling Tips
- Use `<br>` for line breaks in HTML
- Use `<hr>` for visual separation
- Keep fonts readable (Arial, sans-serif)
- Center alignment for vocabulary cards
- Color code: target language (#2c3e50), translation (#27ae60)

## Model ID Stability
```python
import hashlib
MODEL_NAME = 'German Vocabulary Model'
MODEL_ID = int(hashlib.md5(MODEL_NAME.encode()).hexdigest()[:8], 16)
DECK_NAME = 'German Verbs :: 2001 Most Useful Words'
DECK_ID = int(hashlib.md5(DECK_NAME.encode()).hexdigest()[:8], 16)
```

## Common Pitfalls
- **Duplicate model IDs:** Use hash of name for consistency
- **Missing fields:** All fields must be present in note
- **HTML escaping:** genanki auto-escapes, but be careful with `<` `>`
- **CSS conflicts:** Use specific selectors to avoid conflicts
- **Media files:** Reference via `[sound:file.mp3]` or `<img src="file.jpg">`

## Quality Checklist
- [ ] Model ID is stable (hash-based)
- [ ] All 4 fields present in model
- [ ] 2 templates (forward + reverse)
- [ ] CSS is readable and responsive
- [ ] UTF-8 encoding throughout
- [ ] Example sentences on both sides
- [ ] Clear visual separation (hr)
