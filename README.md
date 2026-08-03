# SmartPark AI 🚗🤖

**SmartPark AI** is an AI-powered multilingual smart parking and navigation Android mobile application built with Flutter, Riverpod, GoRouter, Firebase, Google Maps, and Razorpay.

---

## 🏛️ Clean Architecture Blueprint

The project is structured according to **Feature-First Clean Architecture**, ensuring strict separation of concerns, scalability, testability, and maintainability.

```
smart_park_ai/
├── android/                     # Android Native Configuration & Permissions
├── ios/                         # iOS Native Configuration & Permissions
├── assets/                      # App Assets (Images, Icons, Lottie, Fonts)
├── lib/
│   ├── main.dart                # App Entry Point & ProviderScope Binding
│   ├── app.dart                 # MaterialApp.router, Theme, and Locale Setup
│   ├── core/                    # App Infrastructure & Shared Design System
│   │   ├── constants/           # Colors (#1565C0, #42A5F5, #F5F7FA), Typography, Endpoints
│   │   ├── theme/               # Material Design 3 Light & Dark Themes (20px Radius)
│   │   ├── routes/              # GoRouter Configuration with 18 Routes & Transitions
│   │   ├── services/            # Firebase, Maps, Razorpay, AI Engine & Storage Interfaces
│   │   ├── utils/               # Formatters, Validators, Location Helpers
│   │   └── widgets/             # 12 Reusable MD3 Component Widgets
│   ├── features/                # 12 Feature Modules (data/domain/presentation)
│   │   ├── authentication/
│   │   ├── home/
│   │   ├── search/
│   │   ├── booking/
│   │   ├── payment/
│   │   ├── parking/
│   │   ├── history/
│   │   ├── notifications/
│   │   ├── profile/
│   │   ├── settings/
│   │   ├── language/
│   │   └── support/
│   ├── models/                  # Shared Domain Data Models (Equatable)
│   ├── providers/               # Global Riverpod DI & State Providers
│   ├── repositories/            # Base Repository Pattern
│   └── l10n/                    # Multilingual Translations (EN, TA, HI, ML, KN)
└── test/                        # Unit, Widget, and Integration Tests
```

---

## 🎨 Design System & Theme Specifications

- **UI Framework**: Material Design 3 (MD3) with Google Fonts Poppins.
- **Primary Color**: `#1565C0`
- **Secondary Color**: `#42A5F5`
- **Background Color**: `#F5F7FA`
- **Card Fill**: `#FFFFFF`
- **Border Radius**: `20px`

---

## 🧩 Included Reusable Widgets (`lib/core/widgets/`)

1. **`PrimaryButton`**: High-emphasis action button with loading state support.
2. **`SecondaryButton`**: Outlined secondary action button.
3. **`CustomTextField`**: MD3 rounded text input field with validation support.
4. **`CustomSearchBar`**: Clean search bar with filter trigger icon.
5. **`ParkingCard`**: Parking spot preview card with live occupancy indicator & AI match score.
6. **`AiRecommendationCard`**: Gradient card highlighting top AI recommendation & time savings.
7. **`TrafficCard`**: Real-time traffic alert card with congestion indicator.
8. **`BookingCard`**: Active & historical reservation card with QR Pass button.
9. **`NotificationCard`**: Feed item card for real-time alerts.
10. **`CustomBottomNavBar`**: Floating rounded bottom navigation bar.
11. **`LoadingIndicator`**: Centralized progress indicator with text status.
12. **`CustomAppBar`**: Clean custom top app bar with back navigation.

---

## 🌐 Localization Support

Configured for **5 Indian Languages**:
- 🇬🇧 **English** (`en`)
- 🇮🇳 **Tamil** (`ta`)
- 🇮🇳 **Hindi** (`hi`)
- 🇮🇳 **Malayalam** (`ml`)
- 🇮🇳 **Kannada** (`kn`)

Translations are stored in `lib/l10n/app_*.arb` files.

---

## 🤖 AI Module Interfaces (`IAIEngineService`)

The AI module service interface defines standard signatures for:
1. **AI Parking Recommendation**: `getRecommendedParkingSpots()`
2. **Traffic Prediction**: `predictTrafficConditions()`
3. **Smart Route Recommendation**: `calculateOptimalRoute()`
4. **Parking Occupancy Prediction**: `predictSlotOccupancyRate()`

---

## ⚙️ How to Setup & Run

1. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

2. **Generate Localizations & Code**:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Firebase Setup**:
   - Download `google-services.json` from Firebase Console.
   - Place it inside `android/app/`.

4. **Google Maps API Key**:
   - Update `GOOGLE_MAPS_API_KEY` in `android/app/src/main/AndroidManifest.xml`.

5. **Run Application**:
   ```bash
   flutter run
   ```

---

## 🧪 Verification & Code Health

- Clean Architecture & Feature-First modularization strictly enforced.
- Fully typed Dart null-safety compliance.
- Test suites bootstrapped under `test/`.
