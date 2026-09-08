---
name: trading-journal-automation
description: Build formula-driven Excel journals with RTL support.
triggers:
  - user asks for a trading journal or log
  - requirement for SL/TP tracking and account management
---
# Trading Journal Automation
Use to generate professional, formula-driven trading journals in Excel, optimized for Farsi/RTL and account management.

## Trigger
- User asks for a "Trading Journal" or "Trading Log".
- Requirements include SL/TP tracking, R-Multiple, or P/L calculation.

## Core Features
1. **Account Management:**
   - **Initial Balance:** A dedicated cell (e.g., B2) for the starting capital.
   - **Equity Tracking:** Real-time calculation of current balance (`=Initial + SUM(P:P)`).
   - **Drawdown/Growth %:** Formulas that calculate risk and return relative to the initial balance.
2. **RTL Support:**
   - Mandatory for Persian/Arabic: `ws.sheet_view.rightToLeft = True`.
   - Column alignment: `Alignment(horizontal='center', vertical='center')`.
3. **Advanced Formulas:**
   - **P/L ($):** `IF(Type="BUY", (Exit-Entry)*Lot*100000, (Entry-Exit)*Lot*100000)`.
   - **R-Multiple:** `ABS(Exit-Entry)/ABS(Entry-SL)`.
   - **Equity Path:** Running total of the account balance after every trade.

## Implementation (Python + openpyxl)
```python
from openpyxl.utils import get_column_letter
from openpyxl.styles import PatternFill, Font

# RTL and Headers
ws.sheet_view.rightToLeft = True
# Formatting Profit/Loss
ws.conditional_formatting.add('P5:P100', CellIsRule(operator='greaterThan', formula=['0'], fill=green_fill))
```

## Pitfalls
- **Pip Permissions:** In some environments, `pip install` as root is warned; use `--quiet` and handle `NameError` for missing imports like `get_column_letter`.
- **Currency Symbols:** Use `.number_format = '$#,##0.00'` for financial columns.
- **Balance Placement:** Always place the 'Initial Balance' cell (e.g., B2) clearly at the top and link all Equity formulas to it using absolute references (e.g., `$B$2`) so the user can update their capital without breaking the journal.
