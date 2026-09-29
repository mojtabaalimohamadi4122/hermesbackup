---
name: financial-monitoring
description: Monitor assets (FX/Crypto) and server status via cron.
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux]
metadata:
  hermes:
    tags: [trading, eurusd, monitoring, watchdog, server-status]
---

# Financial & Infrastructure Monitoring

Use this skill to set up watchdogs for trading assets (like EUR/USD) and server infrastructure (tunnels, SSH, ping).

## 1. Asset Monitoring (Python)

Create a monitoring script `asset_monitor.py` that fetches prices and checks conditions.

### EUR/USD Monitoring
```python
import requests

def get_eurusd_price():
    try:
        url = "https://query1.finance.yahoo.com/v8/finance/chart/EURUSD=X"
        headers = {'User-Agent': 'Mozilla/5.0'}
        response = requests.get(url, headers=headers, timeout=10)
        data = response.json()
        return data['chart']['result'][0]['meta']['regularMarketPrice']
    except Exception as e:
        return None
```

## 2. Infrastructure Monitoring (Python)

Check if a remote server or tunnel is up.

```python
import subprocess

def check_server(ip):
    try:
        res = subprocess.run(['ping', '-c', '1', '-W', '2', ip], 
                           stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        return res.returncode == 0
    except:
        return False
```

## 3. Automation (Cron Job)

Schedule the monitor to run periodically (e.g., every 5 minutes).

```bash
# ⚠️ CORRECT: Use cron syntax for recurring no_agent jobs!
cronjob(action='create', schedule='*/5 * * * *', script='asset_monitor.py', deliver='origin', no_agent=True)
```

### CRITICAL: Cron Scheduling Pitfalls

**`schedule='5m'` defaults to ONE-SHOT!** For `no_agent=True` scripts:
- `schedule='5m'` → runs ONCE after 5 minutes, then stops
- `schedule='*/5 * * * *'` → runs EVERY 5 minutes forever ✅

Always use cron syntax (`*/* * * *`) for recurring monitoring jobs.

**Silent-by-default pattern:** For `no_agent=True` scripts, stdout is only delivered
when non-empty. Design scripts to ONLY output when there's an alert:
```python
# ✅ GOOD: Silent when nothing to report
if alerts:
    print("\n".join(alerts))
# else: no output = no message sent to user

# ❌ BAD: Always outputs something = spam every 5 minutes
print(f"Price: {price}")  # This gets sent every run!
```

## 4. Spreadsheet Generation (Trading Journals, Reports)

When creating Excel files (trading journals, performance reports), use `openpyxl`:

```bash
pip install openpyxl  # idempotent
```

### Fallback: execute_code Import Failures
If `execute_code` can't import openpyxl (sandbox environment issue), write the
entire script to a `.py` file and run via `terminal()`:

```python
from hermes_tools import write_file, terminal
write_file("/data/workspace/create_journal.py", "import openpyxl\n...")
terminal("cd /data/workspace && python3 create_journal.py")
```

### RTL Excel for Persian/Arabic/Hebrew Users
```python
ws.sheet_view.rightToLeft = True  # RTL layout
# Use Arial font for Persian — renders correctly
# Headers in user's language, wider columns for non-Latin scripts
```

### Common Trading Journal Columns (Persian)
تاریخ, ساعت, جفت ارز, نوع(SELL/BUY), حجم(Lot), نقطه ورود, حد ضرر(SL),
حد سود(TP1,TP2), نقطه خروج, سود/ضرر($), درصد(%), اسپرد, کارمزد,
نتیجه خالص($), R-Multiple, احساسات, یادداشت

## 5. Best Practices
- **Persistence**: Save alerts to a log file (`monitoring.log`).
- **Notification**: Use `deliver='origin'` in cron jobs to get alerts directly in the chat.
- **Security**: Never hardcode sensitive IPs or credentials in shared scripts.
- **Silent mode**: Only output when there's an alert (see cron pitfalls above).
- **Token safety**: See `references/backup-token-security.md` for GitHub token pitfalls.
- **Multi-model**: See `references/multi-model-delegation.md` for delegating to vision models.
- **Batch OCR**: See `references/tesseract-batch-ocr.md` for local image-to-text fallback.
