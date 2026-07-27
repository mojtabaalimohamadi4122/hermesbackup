# Multi-Model Delegation for Monitoring

## Problem
The main agent (e.g., memohermes) may not have vision capabilities needed for
chart analysis, but delegation to vision-capable models (Gemini, Kimi) may hit
quota limits.

## Solution: Configure delegation model
```bash
hermes config set delegation.model "gemini/gemini-3.1-pro-preview"
hermes config set delegation.provider "openai-api"
```

This routes `delegate_task` subagents to the specified model while the main
agent stays on its current model.

## Quota Management
If the delegated model hits 429 (quota exceeded):
1. Check error message for reset time ("reset after Xs")
2. Switch delegation to another model temporarily
3. Available models can be listed via the provider's `/v1/models` endpoint

## Yahoo Finance API Notes
- Endpoint: `https://query1.finance.yahoo.com/v8/finance/chart/EURUSD=X`
- Requires `User-Agent` header (any string works)
- Returns `regularMarketPrice` in `meta` object
- Rate limiting: occasional 429 errors; add retry logic for production use
- Alternative pairs: `GBPUSD=X`, `USDJPY=X`, `BTC-USD`
