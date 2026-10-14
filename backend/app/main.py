from __future__ import annotations

import json
import logging
import os
from typing import Any

from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException
from openai import OpenAI

from .knowledge import knowledge_context
from .schemas import ChatRequest, ChatResponse, SuggestedTrip

load_dotenv()

logger = logging.getLogger(__name__)

app = FastAPI(title="Voyage Jordan AI Backend", version="1.0.0")


def _system_prompt() -> str:
    return (
        "You are Voyage Jordan's in-app AI tourism assistant.\n"
        "You help tourists who may know nothing about Jordan.\n"
        "Stay aligned to supported destinations only: Petra, Wadi Rum, Aqaba, Jerash, Dead Sea.\n"
        "You can answer tourism, planning, budget, transportation, and app-usage questions.\n"
        "Be concise, clear, and practical.\n"
        "Support Arabic and English based on user language.\n"
        "Never claim confirmed booking, payment completion, or live inventory.\n"
        "Always treat this as a demo app context.\n"
        "When useful, provide structured suggested_trip as JSON with: destination_ids, trip_days, budget_tier, transport_mode, summary.\n"
        "budget_tier: 0 economy, 1 moderate, 2 luxury.\n"
        "transport_mode: 0 rental car, 1 private driver, 2 public transport, 3 guided tour.\n"
        "If no trip suggestion is appropriate, set suggested_trip to null.\n"
        "Return strict JSON object only: {\"reply\": string, \"intent\": string|null, \"suggested_trip\": object|null}."
    )


def _build_messages(req: ChatRequest) -> list[dict[str, str]]:
    ctx = {
        "knowledge": knowledge_context(),
        "app_context": req.app_context or {},
    }
    messages: list[dict[str, str]] = [
        {"role": "system", "content": _system_prompt()},
        {"role": "system", "content": f"Knowledge context JSON:\n{json.dumps(ctx, ensure_ascii=False)}"},
    ]
    for item in req.conversation_history or []:
        role = item.get("role", "user")
        content = item.get("content", "")
        if role not in {"user", "assistant"} or not content.strip():
            continue
        messages.append({"role": role, "content": content})
    messages.append(
        {
            "role": "user",
            "content": f"language={req.language}\nmessage={req.message}",
        }
    )
    return messages


def _openai_client() -> OpenAI:
    key = os.getenv("OPENAI_API_KEY")
    if not key:
        raise HTTPException(status_code=500, detail="OPENAI_API_KEY is not set")
    return OpenAI(api_key=key)


def _normalize_trip(raw: Any) -> SuggestedTrip | None:
    if not isinstance(raw, dict):
        return None
    try:
        trip = SuggestedTrip.model_validate(raw)
    except Exception:
        return None
    if not trip.destination_ids:
        return None
    valid = {"petra", "wadi-rum", "aqaba", "jerash", "dead-sea"}
    trip.destination_ids = [d for d in trip.destination_ids if d in valid]
    if not trip.destination_ids:
        return None
    trip.trip_days = max(1, min(14, trip.trip_days))
    trip.budget_tier = max(0, min(2, trip.budget_tier))
    trip.transport_mode = max(0, min(3, trip.transport_mode))
    return trip


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.post("/chat", response_model=ChatResponse)
async def chat(req: ChatRequest) -> ChatResponse:
    logger.warning("BACKEND_CHAT_RECEIVED")
    logger.warning("BACKEND_CHAT_MESSAGE %r", req.message)
    # Guaranteed path for Flutter ↔ backend integration tests (no OpenAI).
    if req.message == "__debug_test__":
        logger.warning("BACKEND_CHAT_REPLY BACKEND_OK_TEST_REPLY")
        return {"reply": "BACKEND_OK_TEST_REPLY"}
    try:
        client = _openai_client()
        completion = client.chat.completions.create(
            model=os.getenv("OPENAI_MODEL", "gpt-4o-mini"),
            temperature=0.2,
            messages=_build_messages(req),
        )
        text = completion.choices[0].message.content or ""
        parsed = json.loads(text)
        if not isinstance(parsed, dict):
            raise ValueError("Model output is not JSON object")
        reply = str(parsed.get("reply", "")).strip()
        if not reply:
            raise ValueError("Missing reply")
        intent = parsed.get("intent")
        suggested = _normalize_trip(parsed.get("suggested_trip"))
        logger.warning("BACKEND_CHAT_REPLY %r", reply[:500] + ("…" if len(reply) > 500 else ""))
        return ChatResponse(reply=reply, intent=intent if isinstance(intent, str) else None, suggested_trip=suggested)
    except HTTPException as exc:
        logger.error("BACKEND_CHAT_ERROR HTTPException status=%s detail=%r", exc.status_code, exc.detail)
        raise
    except Exception as exc:
        logger.exception("BACKEND_CHAT_ERROR %s", exc)
        raise HTTPException(status_code=502, detail=f"AI backend failure: {exc}") from exc
