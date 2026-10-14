from __future__ import annotations

from typing import Any

from pydantic import BaseModel, ConfigDict, Field


class SuggestedTrip(BaseModel):
    model_config = ConfigDict(extra="ignore")

    destination_ids: list[str] = Field(default_factory=list)
    trip_days: int = 5
    budget_tier: int = 1
    transport_mode: int = 1
    summary: str | None = None


class ChatRequest(BaseModel):
    model_config = ConfigDict(extra="ignore")

    message: str
    language: str = "en"
    conversation_history: list[dict[str, str]] | None = None
    app_context: dict[str, Any] | None = None


class ChatResponse(BaseModel):
    model_config = ConfigDict(extra="ignore")

    reply: str
    suggested_trip: SuggestedTrip | None = None
    intent: str | None = None
