from __future__ import annotations

from typing import Any

DESTINATIONS: dict[str, dict[str, Any]] = {
    "petra": {
        "name": "Petra",
        "summary": "Rock-carved Nabataean city; Jordan’s flagship archaeological site.",
        "best_for": ["history", "culture", "photography", "walking"],
        "activities": ["Siq walk", "Treasury viewpoint", "Monastery trail"],
        "season_notes": "Spring/autumn are usually easiest for walking comfort.",
        "family_fit": 3,
        "relaxation_fit": 2,
        "adventure_fit": 3,
        "history_fit": 5,
        "photography_fit": 5,
    },
    "wadi-rum": {
        "name": "Wadi Rum",
        "summary": "Red desert landscapes with jeep routes, camps, and stargazing.",
        "best_for": ["adventure", "desert", "nature", "photography"],
        "activities": ["Jeep tour", "Bedouin camp", "Stargazing"],
        "season_notes": "Shoulder seasons are easier; summer daytime can be very hot.",
        "family_fit": 3,
        "relaxation_fit": 2,
        "adventure_fit": 5,
        "history_fit": 2,
        "photography_fit": 5,
    },
    "aqaba": {
        "name": "Aqaba",
        "summary": "Jordan’s Red Sea hub with beaches, diving, and resort stays.",
        "best_for": ["sea", "family", "relaxation", "adventure"],
        "activities": ["Snorkeling", "Diving", "Marina walk"],
        "season_notes": "Good year-round; summers are hot but sea activities remain popular.",
        "family_fit": 4,
        "relaxation_fit": 4,
        "adventure_fit": 4,
        "history_fit": 1,
        "photography_fit": 4,
    },
    "jerash": {
        "name": "Jerash",
        "summary": "Well-preserved Roman ruins with theaters, plazas, and colonnades.",
        "best_for": ["history", "culture", "short-trip"],
        "activities": ["Oval plaza", "Theater circuit", "Roman street walk"],
        "season_notes": "Mild months are comfortable and easy to pair with Amman.",
        "family_fit": 3,
        "relaxation_fit": 2,
        "adventure_fit": 1,
        "history_fit": 5,
        "photography_fit": 4,
    },
    "dead-sea": {
        "name": "Dead Sea",
        "summary": "Lowest point on Earth; floating, mud treatments, and spa resorts.",
        "best_for": ["relaxation", "wellness", "romantic", "family"],
        "activities": ["Floating experience", "Mud/spa", "Resort downtime"],
        "season_notes": "Comfortable outside peak summer heat.",
        "family_fit": 4,
        "relaxation_fit": 5,
        "adventure_fit": 1,
        "history_fit": 1,
        "photography_fit": 3,
    },
}

APP_HELP = {
    "how_to_plan": "Home → Start Planning Your Trip → choose destinations, days, budget, and transport.",
    "how_to_generate": "Tap Generate Trip Plan after selecting options.",
    "how_to_save": "Open itinerary and tap Save Plan; it appears in My Trip.",
    "what_my_trip_does": "My Trip shows the latest saved trip summary and opens full itinerary details.",
    "what_destination_pages_show": "Destination pages provide highlights, activities, stay ideas, and dining context.",
    "what_ai_assistant_can_do": "Compares destinations, suggests routes by style and days, explains app usage.",
}

TRIP_STYLE_ROUTES = {
    "history": ["petra", "jerash", "dead-sea"],
    "adventure": ["wadi-rum", "aqaba", "petra"],
    "relaxation": ["dead-sea", "aqaba", "petra"],
    "family": ["aqaba", "dead-sea", "petra"],
    "romantic": ["dead-sea", "aqaba", "petra"],
    "luxury": ["petra", "dead-sea", "aqaba"],
    "mixed": ["petra", "wadi-rum", "dead-sea", "aqaba", "jerash"],
}


def knowledge_context() -> dict[str, Any]:
    return {
        "destinations": DESTINATIONS,
        "app_help": APP_HELP,
        "trip_style_routes": TRIP_STYLE_ROUTES,
        "supported_destination_ids": list(DESTINATIONS.keys()),
        "budget_tiers": {"0": "economy", "1": "moderate", "2": "luxury"},
        "transport_modes": {"0": "rental_car", "1": "private_driver", "2": "public_transport", "3": "guided_tour"},
        "demo_note": "Voyage Jordan is a demo travel planner. Never claim booking confirmation or live prices.",
    }
