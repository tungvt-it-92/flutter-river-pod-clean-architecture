# Flutter Riverpod Clean Architecture – ToDo App

A Flutter To-Do application demonstrating the principles of Clean Architecture, utilizing [Riverpod](https://riverpod.dev/) for state management and [ObjectBox](https://objectbox.io/) for local data persistence.

---

## 🧱 Architecture Overview

This project adheres to the Clean Architecture paradigm, promoting a clear separation of concerns and scalability. The structure is organized into distinct layers:

- **Presentation Layer**: Handles UI components and user interactions.
- **Domain Layer**: Contains business logic, including entities and use cases.
- **Data Layer**: Manages data sources, repositories, and models.

This modular approach facilitates maintainability and testability across the application.

---

## ✨ Features

- Add, edit, and delete to-do items.
- Persist data locally using ObjectBox.
- State management with Riverpod.
- Unit and integration testing support.

---

## 🧰 Technologies Used

- [Flutter](https://flutter.dev/)
- [Riverpod](https://riverpod.dev/)
- [ObjectBox](https://objectbox.io/)
- [Mockito](https://pub.dev/packages/mockito)
- [Build Runner](https://pub.dev/packages/build_runner)

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK installed
- Dart SDK installed

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/tungvt-it-92/flutter-river-pod-clean-architecture.git
   cd flutter-river-pod-clean-architecture
   ```
2. Install dependencies:
    
    ```
    flutter pub get
    ```
3. Generate necessary files:
  * This step generates the ObjectBox database schema and Mockito mock files.
    
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

4. Run application
    
    ```bash
    flutter run
    ```

## 🧪 Testing

### Unit tests

     flutter test


### Integration tests

     flutter test integration_test/

## 📁 Project Structure
* This structure promotes a clear separation between UI, business logic, and data management.
```
lib/
├── core/                    # Shared utilities, error handling
├── data/                    # Local data sources, implemented repositories
│   ├── repositories/
│   └── local/
├── domain/                  # Models and business logic (use cases)
│   ├── models/
│   ├── repositories/
│   └── usecases/
├── presentation/           # Widgets and screens
│   ├── pages/
│   └── widgets/
└── main.dart
```

## 🚀 DEMO
![App demo](demo.gif)

## 🙌 Acknowledgements
- Inspired by the principles of [Clean Architecture](https://8thlight.com/blog/uncle-bob/2012/08/13/the-clean-architecture.html) by Uncle Bob. <br>
- Based on community patterns from `riverpod` and Flutter clean architecture enthusiasts.