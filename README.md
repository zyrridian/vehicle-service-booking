# Vehicle Service Booking

A Flutter application for vehicle service booking, workshop discovery, and mechanic tracking.

## Tech Stack
- **Framework:** Flutter
- **State Management:** BLoC (`flutter_bloc`)
- **Architecture:** Clean Architecture (Domain, Data, Presentation)
- **Networking:** Dio
- **Environment:** FVM (Flutter Version Management)

## Prerequisites

This project enforces specific Flutter SDK versions to maintain build stability. We use [FVM](https://fvm.app/).

If you don't have FVM installed, install it globally via Dart:
```bash
dart pub global activate fvm
```

## Setup & Installation

1. **Clone the repository:**
   ```bash
   git clone <repository_url>
   cd vehicle_service_booking
   ```

2. **Install the required Flutter SDK version:**
   ```bash
   fvm install
   ```
   *This reads the `.fvmrc` file and provisions the correct SDK version locally.*

3. **Fetch dependencies:**
   ```bash
   fvm flutter pub get
   ```

## Running the Application

Always prefix standard Flutter commands with `fvm` to ensure you are using the project-specific SDK:

```bash
fvm flutter run
```

### IDE Configuration (VS Code)
To ensure VS Code uses the FVM SDK for intellisense and debugging, add the following to your workspace settings (`.vscode/settings.json`):

```json
{
  "dart.flutterSdkPath": ".fvm/flutter_sdk",
  "search.exclude": {
    "**/.fvm": true
  }
}
```

## Project Structure

The codebase is organized using a feature-based Clean Architecture approach inside the `lib` directory:

```text
lib/
├── core/          # Global configurations, theme, network clients, utilities
├── data/          # Models, API clients, and Repository implementations
├── domain/        # Entities, Use Cases, and Repository interfaces
├── presentation/  # Feature modules (UI, Pages, Widgets, BLoC)
│   ├── account/
│   ├── auth/
│   ├── garage/
│   ├── history/
│   ├── tracking/
│   └── workshop/
├── injection.dart # Dependency injection configuration
└── main.dart      # Application entry point
```

## Development Guidelines

- **State Management:** Complex UI states and business logic must be handled in BLoC. Keep widgets declarative and minimal.
- **Styling:** Use `AppColors` and `AppTheme` located in `lib/core/theme` for styling. Avoid hardcoding HEX values or absolute dimensions where relative scaling is preferred.
- **Formatting:** Format your code before committing (`fvm flutter format .`).
