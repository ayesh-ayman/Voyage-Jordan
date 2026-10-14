# Voyage Jordan

**Smart Tourism & Trip Planning Mobile Application for Exploring Jordan**

Voyage Jordan is a Flutter-based tourism application designed to help travelers explore Jordan and build personalized travel plans based on their preferences.

The application combines destination discovery, trip planning, itinerary generation, recommendation logic, and travel assistance in one mobile experience focused on Jordan's major tourist destinations.

## Key Features

- Explore major tourist destinations across Jordan
- Personalized trip planning based on traveler preferences
- Rule-based destination recommendations and scoring
- Automatic itinerary generation
- Trip cost and planning information
- Destination details with images and travel information
- Interactive travel assistant
- Saved trip and itinerary management
- Emergency information for travelers
- Arabic and English localization
- Light and dark theme support

## Smart Trip Recommendation

Voyage Jordan includes a recommendation engine designed to generate suitable travel suggestions based on user preferences.

The system evaluates available destinations using predefined rules and scoring logic, allowing the application to recommend destinations and construct a trip plan that better matches the traveler's requirements.

This approach provides personalized planning without relying solely on fixed travel packages or predefined itineraries.

## Destinations

The application includes travel experiences and information for some of Jordan's most recognized destinations, including:

- Petra
- Wadi Rum
- Dead Sea
- Aqaba
- Jerash

Each destination can include dedicated information and visual content to help travelers understand and compare available experiences.

## Trip Planning

Users can build a personalized trip by providing travel preferences and requirements.

The application processes these preferences through its recommendation and trip-planning logic to generate a structured itinerary containing suitable destinations and activities.

## Travel Assistant

Voyage Jordan includes an assistant component that supports travel-related interactions and trip-building flows.

The project contains both local assistant logic and a backend structure for handling travel knowledge and assistant-related functionality.

## Technology Stack

- **Flutter** — Cross-platform mobile application development
- **Dart** — Core application language
- **Provider** — Application state management
- **Python** — Backend and supporting services
- **Rule-Based Recommendation Engine** — Destination filtering and scoring
- **REST-based Architecture** — Communication with remote services
- **JSON** — Structured data exchange
- **Git & GitHub** — Version control and source-code management

## Project Architecture

The application follows a modular feature-based structure that separates application logic, providers, repositories, models, shared components, and individual features.

```text
lib/
├── app/
├── constants/
├── core/
│   ├── providers/
│   └── trip_plan/
├── features/
│   ├── ai_assistant/
│   ├── destinations/
│   ├── emergency/
│   ├── home/
│   ├── itinerary/
│   ├── my_trip/
│   ├── settings/
│   ├── splash/
│   └── trip_planner/
├── l10n/
├── models/
├── repositories/
├── shared/
└── main.dart

backend/
├── app/
├── requirements.txt
└── README.md
```

## Localization

Voyage Jordan supports:

- 🇯🇴 Arabic
- 🇬🇧 English

The localization structure allows destination information and application interfaces to adapt to the selected language.

## Project Objective

Voyage Jordan aims to improve the tourism experience in Jordan by providing travelers with a single application for discovering destinations, planning personalized trips, generating itineraries, and accessing useful travel information.

The project demonstrates how mobile development, recommendation algorithms, structured travel data, and backend services can be combined to create a smarter digital tourism experience.

## Recognition

**Semifinalist — Crown Prince Award for Best Government Application**

Voyage Jordan advanced to the semifinal stage of the competition, demonstrating its concept as a digital solution for supporting tourism and improving the travel-planning experience in Jordan.

## Project Status

Voyage Jordan is developed as a functional application prototype demonstrating personalized tourism recommendations, itinerary generation, destination discovery, and travel assistance.

## Developer

**Ayesh Zayed**

Flutter & Mobile Application Developer

GitHub: [ayesh-ayman](https://github.com/ayesh-ayman)
