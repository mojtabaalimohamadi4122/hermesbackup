# PDF Parsing Patterns for Vocabulary Lists

## Tools
- `pdftotext` - fast, simple text extraction
- `pymupdf` (fitz) - layout-aware extraction, handles complex layouts
- `pdfplumber` - table extraction, detailed layout analysis

## Common Patterns

### 1. Double-newline separation
```python
entries = text.split('\n\n')
```
Works for most vocabulary lists where entries are separated by blank lines.

### 2. Verb pattern detection
```python
if ' to ' in entry:
    # likely a verb entry
    german = entry[:entry.index(' to ')].strip().split('\n')[-1].strip()
    english = entry[entry.index(' to ') + 4:].split('\n')[0].strip()
```

### 3. Example sentence pairing
```python
# After translation, German example comes first, then English
lines = rest.split('\n')
 german_example = lines[0].strip() if lines else ''
 english_example = lines[1].strip() if len(lines) > 1 else ''
```

### 4. Form feed handling
```python
text = text.replace('\f', '\n')  # form feeds to newlines
```

### 5. German verb filtering
```python
# German verbs are lowercase; nouns are capitalized
if german_word and german_word[0].islower():
    # likely a verb
```

## Common Issues
- **Page breaks**: form feeds (`\f`) break words mid-entry
- **Multi-line entries**: some entries span 3+ lines
- **Formatting loss**: bold/italic markers lost in plain text
- **Encoding**: ensure UTF-8 throughout

## Tools Comparison
| Tool | Speed | Layout | Tables | Best For |
|------|-------|--------|--------|----------|
| pdftotext | Fast | Poor | No | Simple text |
| pymupdf | Medium | Good | Basic | Layout-aware |
| pdfplumber | Slow | Excellent | Excellent | Tables/complex |