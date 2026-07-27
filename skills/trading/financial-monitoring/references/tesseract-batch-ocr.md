# Batch Image OCR: Tesseract Fallback

## When to Use
When API-based OCR (Gemini Vision, Kimi Vision) hits quota limits (HTTP 429),
Tesseract provides a fast, local, quota-free alternative for batch processing
of screenshots and images.

## Installation
```bash
apt-get install -y tesseract-ocr tesseract-ocr-deu tesseract-ocr-eng
# Add more languages as needed: tesseract-ocr-fra, tesseract-ocr-spa, etc.
```

## Batch Processing Pattern
```python
import subprocess, os

def batch_ocr(image_dir, lang='deu+eng', psm=6):
    """OCR all images in a directory. Returns list of (filename, text)."""
    results = []
    for img in sorted(os.listdir(image_dir)):
        if img.lower().endswith(('.jpg', '.jpeg', '.png')):
            try:
                r = subprocess.run(
                    ['tesseract', os.path.join(image_dir, img), 'stdout',
                     '-l', lang, '--psm', str(psm)],
                    capture_output=True, text=True, timeout=30
                )
                text = r.stdout.strip()
                if text and len(text) > 2:
                    results.append((img, text))
            except Exception as e:
                pass  # Skip failed images
    return results
```

## PSM Modes
- `--psm 3` (default): Fully automatic page segmentation
- `--psm 6`: Single uniform block of text (best for screenshots)
- `--psm 7`: Single text line
- `--psm 8`: Single word
- `--psm 11`: Sparse text without order

## Post-Processing
OCR output often contains UI artifacts. Clean with regex:
```python
import re

def clean_ocr(text):
    """Remove common UI artifacts from AnkiDroid/screenshot OCR."""
    lines = text.split('\n')
    cleaned = []
    for line in lines:
        line = line.strip()
        # Skip timestamps
        if re.match(r'^\d{2}:\d{2}', line): continue
        # Skip Anki buttons
        if 'Again Hard Good Easy' in line: continue
        # Skip interval markers
        if re.match(r'^[\d\s<>-]+$', line): continue
        # Skip short noise
        if len(line) < 2: continue
        cleaned.append(line)
    return '\n'.join(cleaned)
```

## Quality Expectations
- Clean screenshots with high contrast: ~90-95% accuracy
- Low resolution or blurry: ~60-70% accuracy
- Handwritten text: unreliable, use vision model instead
- German special chars (ä, ö, ü, ß): works well with `deu` language pack
