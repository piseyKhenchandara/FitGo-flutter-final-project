# FitGo – Fitness & Workout App (Flutter)

## Project Overview
**FitGo** is a mobile fitness application built using **Flutter**.  
The app helps users **lose weight** or **build muscle** by providing guided workouts, timers, and progress tracking.

This project is created as the **final project for the Frontend (Flutter) course**.

---

## Purpose of the App
- Help users choose workouts based on their body information  
- Support both **weight loss** and **muscle gain**  
- Provide simple **daily workout plans**  
- Track workout progress and completion  

---

## Main Features
- Onboarding screens with app introduction  
- Gender selection (Male / Female)  
- Height and weight input  
- User information form  
- BMI / weight average result  
- Daily workout plans (Day 1 – Day 7)  
- Exercise list with images  
- Workout timer (reps and time-based)  
- Progress tracking (completed percentage)  
- Clean and modern UI design  

---

## System Architecture

```mermaid
graph TB
    subgraph CLIENT["Client Layer"]
        USER[Users<br/>Mobile & Web Browsers]
    end

    subgraph APP["Flutter Application"]
        FLUTTER[Flutter Framework<br/>Dart Language<br/>Cross-platform Support]
    end

    subgraph PRESENTATION["UI Layer"]
        direction LR
        SCREENS[Screens & Pages<br/>Onboarding, Setup, Workout]
        WIDGETS[Custom Widgets<br/>Components]
        STATE[State Management<br/>UI Updates]
    end

    subgraph DATA_LAYER["Data Layer"]
        direction LR
        MODELS[Models<br/>User, Workout, Exercise]
        ENUMS[Enums<br/>GoalType, Gender]
    end

    subgraph SERVICE_LAYER["Service Layer"]
        direction TB
        USER_SERVICE[UserService<br/>User Info Management]
        VALIDATION[ValidationService<br/>Input Validation]
        STORAGE_SERVICE[UserLocalStorageService<br/>Platform-specific Storage]
    end

    subgraph CONTROLLER["State Controller"]
        SETUP_CONTROLLER[UserSetupController<br/>Singleton Instance<br/>In-Memory State]
    end

    subgraph STORAGE["Storage Layer"]
        direction LR
        MOBILE[Mobile Storage<br/>File System<br/>path_provider]
        WEB[Web Storage<br/>SharedPreferences<br/>Local Storage API]
    end

    subgraph PERSISTENCE["Persistent Storage"]
        JSON[JSON Serialization<br/>user_setup.json]
    end

    %% Main flow connections
    USER --> FLUTTER
    FLUTTER --> PRESENTATION
    
    PRESENTATION --> DATA_LAYER
    DATA_LAYER --> SERVICE_LAYER
    SERVICE_LAYER --> SETUP_CONTROLLER
    
    SETUP_CONTROLLER --> STORAGE
    
    STORAGE --> PERSISTENCE
    
    %% Platform-specific connections
    SETUP_CONTROLLER -.kIsWeb=false.-> MOBILE
    SETUP_CONTROLLER -.kIsWeb=true.-> WEB
    
    MOBILE --> JSON
    WEB --> JSON

    %% Styling
    classDef clientStyle fill:#1a1a1a,stroke:#2196F3,stroke-width:3px,color:#ffffff
    classDef appStyle fill:#2c3e50,stroke:#2196F3,stroke-width:3px,color:#ffffff
    classDef uiStyle fill:#0d7377,stroke:#2196F3,stroke-width:3px,color:#ffffff
    classDef dataStyle fill:#1565c0,stroke:#2196F3,stroke-width:3px,color:#ffffff
    classDef serviceStyle fill:#004d40,stroke:#2196F3,stroke-width:3px,color:#ffffff
    classDef controllerStyle fill:#1976d2,stroke:#2196F3,stroke-width:3px,color:#ffffff
    classDef storageStyle fill:#263238,stroke:#2196F3,stroke-width:3px,color:#ffffff
    classDef persistStyle fill:#0d47a1,stroke:#2196F3,stroke-width:3px,color:#ffffff
    
    class CLIENT,USER clientStyle
    class APP,FLUTTER appStyle
    class PRESENTATION,SCREENS,WIDGETS,STATE uiStyle
    class DATA_LAYER,MODELS,ENUMS dataStyle
    class SERVICE_LAYER,USER_SERVICE,VALIDATION,STORAGE_SERVICE serviceStyle
    class CONTROLLER,SETUP_CONTROLLER controllerStyle
    class STORAGE,MOBILE,WEB storageStyle
    class PERSISTENCE,JSON persistStyle
```

### Architecture Flow:

The application follows a clean layered architecture pattern:

1. **Client Layer** → Users interact through mobile and web interfaces
2. **Flutter Application** → Cross-platform framework (Android, iOS, Web)
3. **UI Layer** → Screens, widgets, and state management
4. **Data Layer** → Models and enums for data structure
5. **Service Layer** → Business logic (UserService, ValidationService, StorageService)
6. **UserSetupController** → Central singleton for in-memory state management
7. **Storage Layer** → Platform-specific persistent storage
   - **Mobile**: File System using `path_provider`
   - **Web**: SharedPreferences using Local Storage API
8. **Persistent Storage** → JSON serialization (`user_setup.json`)

### Data Flow:

**Save Flow:**
1. User Input → UI Layer → ValidationService → UserService
2. UserService → UserSetupController (in-memory)
3. When setup complete → UserLocalStorageService.saveUserSetup()
4. Platform detection (kIsWeb) → Mobile/Web Storage → JSON file

**Load Flow:**
1. App starts → UserLocalStorageService.loadUserSetup()
2. Read from platform-specific storage → Parse JSON
3. Load data into UserSetupController → Update UI

---

## Technologies Used
- **Flutter** - Cross-platform framework
- **Dart** - Programming language
- **Material Design** - UI/UX components
- **path_provider** - File system access (mobile)
- **shared_preferences** - Local storage (web)
- **Frontend only** (no backend)

---

## App Screens
- Welcome and onboarding pages  
- User setup (gender, height, weight)  
- Workout dashboard  
- Daily exercise list  
- Exercise detail screen with timer  

---

## What I Learned
- Flutter layout system (Column, Row, Stack)
- Navigation between screens
- Using widgets and custom UI components
- Handling user input with validation
- State management for UI updates
- Designing mobile-friendly interfaces
- Implementing clean architecture patterns
- Managing platform-specific storage (mobile vs web)
- Singleton pattern for state management
- JSON serialization and deserialization

---

## Future Improvements
- Add backend and user authentication  
- Save workout progress using a database  
- Add more workout types and exercises
- Implement workout history tracking
- Add dark mode support
- Improve animations and overall UX  
- Add social features (share progress)
- Integrate fitness APIs (step counter, heart rate)

---
