# SmartPark AI - AI-Driven Smart Parking Platform 🚗⚡

[![Flutter](https://img.shields.io/badge/Flutter-3.12.2-blue.svg)](https://flutter.dev)
[![Riverpod](https://img.shields.io/badge/State_Management-Riverpod-purple.svg)](https://riverpod.dev)
[![Firebase](https://img.shields.io/badge/Backend-Firebase-orange.svg)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

SmartPark AI is an intelligent, edge-assisted smart parking optimization platform built with **Flutter**, **Clean Architecture**, **Riverpod**, **Firebase**, **Google Maps**, **Razorpay**, and an **Explainable AI Engine**.

---

## 🌟 Key Features

- **🤖 Pluggable AI Adapter Architecture**: Decoupled interface supporting Local Edge ML (TFLite/ONNX), Google Gemini AI, and offline Mock adapters.
- **📡 Smart Sensor Layer & Digital Twin**: Ingests live telemetry from IoT sensors, CCTV, ANPR, RFID, and Barrier Gates.
- **🗺️ Live Google Maps Navigation**: Color-coded live occupancy markers, AI Smart Pick highlights, and route polyline overlays.
- **📱 Smart 5-Step Reservation Wizard**: Time selection, vehicle filter, dynamic surge price breakdown, and digital QR pass generation (`qr_flutter`).
- **🔔 FCM & Local Push Notification Engine**: Automated 15-min reservation reminders, 10-min slot expiry warnings, and adaptive re-routing alerts.
- **💳 Razorpay Payment Platform**: Secure UPI (GPay, PhonePe, Paytm), Credit Cards, Net Banking, and digital invoice generator.
- **💬 Floating AI Assistant**: Conversational FAB modal providing context-aware answers, voice input simulation, and action execution.
- **📊 Enterprise Admin Dashboard**: Executive platform summary, microservice operational status, incident log resolution, and report export (PDF, CSV, Excel).

---

## 🏗️ Architecture Overview

SmartPark AI strictly follows **Clean Architecture**:

```
lib/
├── core/                   # Design system, constants, errors, routes, and services
├── models/                 # Immutable data models with serialization
├── repositories/           # Abstract interfaces & Firestore implementations
├── providers/              # Central Riverpod Dependency Injection
├── services/
│   ├── ai/                 # Pluggable AI Adapters & Decision Engine
│   ├── sensor/             # Gateway, Telemetry Dispatcher, Simulation & Digital Twin
│   ├── notification/       # FCM & Local Notification Scheduler
│   └── payment/            # Razorpay & Invoice Engine
└── features/               # Modular Clean Architecture Feature Modules
    ├── home/               # Dashboard & Category Filters
    ├── search/             # Live Google Parking Map & Search
    ├── parking/            # Parking Details & 5-Step Wizard
    ├── booking/            # Active Bookings
    ├── payment/            # Checkout & Payment History
    ├── qr_pass/            # Digital QR Pass
    ├── notifications/      # Notification Center
    ├── admin/              # Enterprise Admin Dashboard
    └── assistant/          # Floating AI Assistant
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `^3.12.2`
- Dart SDK `^3.12.2`
- Android Studio / VS Code

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/smartpark-ai/app.git
   cd smartpark_ai
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run static code analyzer:
   ```bash
   flutter analyze
   ```
4. Launch application:
   ```bash
   flutter run
   ```

---

## 📜 Documentation & Specifications
Detailed architectural diagrams, Digital Twin pipelines, and Patent novelty claims are available in [docs/ARCHITECTURE_AND_INNOVATION.md](file:///c:/Pagalavan/Projects/smartpark_ai/docs/ARCHITECTURE_AND_INNOVATION.md).

---

## 📄 License
This project is licensed under the MIT License - see the LICENSE file for details.
