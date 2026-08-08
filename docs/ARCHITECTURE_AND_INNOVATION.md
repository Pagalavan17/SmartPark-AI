# SmartPark AI - Technical Architecture, Digital Twin Specification & Patent Novelty Documentation

## 1. Executive Summary & Problem Statement
Traditional urban parking applications operate purely as passive listing tools with static databases. They fail to handle live dynamic pricing, real-time IoT hardware telemetry, dynamic vehicle routing, or occupancy forecasting.

**SmartPark AI** is an intelligent, scalable, edge-assisted urban parking platform. It unifies:
- **Pluggable Multi-Model AI Engine** (Local Edge TFLite/ONNX, Gemini AI, Deterministic Mock).
- **Real-Time IoT & Digital Twin Engine** (Syncing IoT sensors, CCTV, ANPR, RFID, Barrier Gates).
- **Adaptive Reservation Re-Routing** (Auto-transferring users when facilities reach 100% capacity).
- **Explainable AI Reasoning** (Transparent match scores and confidence levels).
- **Enterprise Control Panel** (Live microservice health and telemetry analytics).

---

## 2. Pluggable AI Adapter Architecture
SmartPark AI decouples AI providers behind an abstract `AIAdapter` interface.

```
                    +---------------------------+
                    |        AIAdapter          |
                    |   (Abstract Interface)    |
                    +-------------+-------------+
                                  |
        +-------------------------+-------------------------+
        |                         |                         |
+-------v-------+        +--------v-------+        +--------v-------+
|  DummyAdapter |        | GeminiAdapter  |        | LocalMLAdapter |
|  (Offline M3) |        | (Google Cloud) |        | (Edge On-Device)|
+---------------+        +----------------+        +----------------+
```

### Key AI Components:
1. **ParkingPredictionService**: Forecasts occupancy across 15m, 30m, 1h, and 2h horizons.
2. **RecommendationEngine**: Ranks parking lots using multi-objective optimization (Distance, Price, EV preference, Traffic, Weather).
3. **ExplainableAIService**: Generates natural language reasoning explaining recommendation decisions.
4. **DynamicPricingEngine**: Calculates hourly surge multipliers based on real-time vehicle inflow rates.

---

## 3. Smart Sensor Layer & Digital Twin Specification
The platform ingests live telemetry from 8 hardware sensor types:
- IoT Ultrasonic Parking Sensors
- CCTV Optical Cameras
- ANPR (Automatic Number Plate Recognition) Cameras
- RFID Tag Readers
- Barrier Gate Access Control Sensors
- Magnetic Vehicle Loop Detectors
- LiDAR Range Scanners

### Data Flow Pipeline:
```
[Hardware Sensors / Simulator] -> [SensorGateway] -> [SensorEventDispatcher] 
       -> [ParkingStatusSynchronizer] -> [DigitalTwinModel] -> [Firestore & Streams]
```

---

## 4. Firestore Database Schemas
SmartPark AI organizes data into 10 structured collections:
1. `users`: User profiles, reward points, saved vehicle IDs.
2. `parking_lots`: Base rates, total/available slots, amenities, AI match scores.
3. `reservations`: QR pass tokens, allocated slot numbers, pricing breakdowns.
4. `sensor_events`: Hardware telemetry payloads and confidence scores.
5. `digital_twins`: Real-time inflow/outflow rates and surge multipliers.
6. `vehicles`: Vehicle registration numbers and EV/SUV types.
7. `payments`: Razorpay transaction IDs, status, and invoices.
8. `notifications`: Alert history, push categories, and read status.
9. `analytics`: Environmental CO₂ savings, EV energy delivered, revenue metrics.
10. `parking_predictions`: Multi-horizon occupancy forecasts.

---

## 5. Patent & Innovation Novelty Statement
### Patent Claim 1: Closed-Loop Digital Twin Re-routing
An automated method for updating digital twin representations of physical parking facilities using asynchronous hardware telemetry, triggering dynamic pricing adjustments and real-time adaptive reservation transfers.

### Patent Claim 2: Edge-Assisted Hybrid AI Model Switching
A system executing parking occupancy prediction locally on edge hardware when network connectivity is degraded, seamlessly falling back to cloud-hosted generative AI models upon reconnection.

---

## 6. Developer & Deployment Guide
1. **Clone Repository**: `git clone https://github.com/smartpark-ai/app.git`
2. **Install Dependencies**: `flutter pub get`
3. **Run Code Analysis**: `flutter analyze`
4. **Build APK/Bundle**: `flutter build apk --release`
