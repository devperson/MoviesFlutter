## About Me

I am a **Senior Mobile Application Developer** with **15+ years of professional experience** building high-quality, scalable native and cross-platform iOS and Android applications.
This repository reflects my approach to designing **robust, testable, and scalable** mobile solutions using modern architectural patterns.

**Contact:**  
📧 Email: khasanrah@gmail.com  
💼 Upwork: https://www.upwork.com/freelancers/khasanr  
🔗 LinkedIn: https://www.linkedin.com/in/khasan-rakhimov-18021471/

---

## Project Overview – MoviesDemo (Flutter)

This project demonstrates how to build **cross-platform iOS and Android mobile application** using **Dart and the Flutter framework**.

The project applies proven architectural patterns such as **MVVM**, **ViewModel-driven navigation**, **Domain-Driven Design (DDD)**, and **Dependency Injection (DI)**.

The demo shows how:
- **MVVM** implementation in flutter project
- Navigation can be driven from **ViewModels**
- **Domain-Driven Design** structures the shared core
- Services remain fully abstract and are injected via **Dependency Injection** (DI)
- Comprehensive **logging** captures application actions for diagnostics and troubleshooting
- The architecture naturally supports **Unit Tests** and **Integration Tests**

The goal of this project is to demonstrate my experience in creating **beautiful**, **clear**, and **maintainable** mobile applications that can **scale to large, long-living products** without architectural bottlenecks.

### Other Implementations
 
- **MoviesDemo (Swift – SwiftUI)**  
  https://github.com/devperson/MoviesSwift
  
- **MoviesDemo (KMP – Fragment / UIKit)**  
  https://github.com/xusan/MoviesKmpSimplified

- **MoviesDemo (KMP – Jetpack Compose / SwiftUI)**  
  https://github.com/xusan/movieskmpcompose
  
- **MoviesDemo (.NET,C# – Fragment / UIKit)**  
  https://github.com/devperson/MyDemoApp
  
> All *MoviesDemo* implementations have **identical domain models, architecture, and features**.
> The repositories differ only in **platform technology and UI framework**, demonstrating how the same
> core architecture can support multiple native UI approaches without changes to the business layer.
  
---

## Application Features

- Fetches movies list from server
- Caches data in local storage
- Loads cached data on app restart
- Pull-to-refresh reloads data from server and updates cache
- Add new movie:
  - Name
  - Description
  - Photo (camera or gallery)
- Update movie
- Delete movie

---

## Screenshots

| iOS | Android |
|-----|---------|
| ![iOS Demo](assets/iosDemoApp.gif) | ![Android Demo](assets/androidDemo.gif) |

---

## Architecture Overview

High-level layering:

```
UI Layer (Flutter Widgets)
        ↓
ViewModels 
        ↓
Service Layer
        ↓           ↓
Domain Model, Infrastructure Services         

```

---

## UI Layer (Native, Declarative)

The UI layer is implemented using Flutter’s declarative widget framework, while still following the MVVM pattern and keeping all business logic outside the UI layer.

---

## 🧠 ViewModel Layer

- Contains most application use-case logic
- Platform-agnostic
- Implements MVVM pattern
- Uses interfaces for platform-specific services
- Fully unit-tested

---

## 🔧 Service Layer

The service layer is designed using **Domain-Driven Design** and common enterprise patterns such as **Facade** and **Decorator**.

All services are:
- Fully abstract
- Platform-independent
- Injected via **Dependency Injection**
- Implemented per platform only when required

### Contains:
- Domains
- Domain Services
- Application Services
- Infrastructure abstractions

---

## 🧪 Unit & Integration Testing

The project includes a comprehensive test suite:

1. **ViewModel Unit Tests**
   - Test shared use-case logic

2. **Application Services Unit Tests**
   - Validate business rules

3. **Infrastructure Unit Tests**
   - Test platform-specific implementations

4. **Integration Tests**
   - Use real services
   - Validate end-to-end behavior

---

## Why This Architecture?

This demo demonstrates how to build:
- Fully **native** mobile applications
- With **shared business logic via KMP**
- Clean separation of concerns
- High testability
- Long-term maintainability
- Scalability for enterprise-grade applications

---

## License

This project is provided for demonstration and educational purposes.
