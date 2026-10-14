# Voyage Jordan AI Backend (FastAPI)

## Endpoints

- `GET /health`
- `POST /chat`

### `/chat` request

```json
{
  "message": "I want a 5-day adventure trip",
  "language": "en",
  "conversation_history": [{"role": "user", "content": "..."}, {"role": "assistant", "content": "..."}],
  "app_context": {"demo_mode": true}
}
```

### `/chat` response

```json
{
  "reply": "Suggested route: ...",
  "intent": "recommendation",
  "suggested_trip": {
    "destination_ids": ["petra", "wadi-rum", "aqaba"],
    "trip_days": 5,
    "budget_tier": 1,
    "transport_mode": 1,
    "summary": "Balanced adventure route"
  }
}
```

## Environment variables

- `OPENAI_API_KEY` (required)
- `OPENAI_MODEL` (optional, default `gpt-4o-mini`)

## Local run

```bash
cd backend
python -m venv .venv
# Windows
.venv\Scripts\activate
# macOS/Linux
# source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```
