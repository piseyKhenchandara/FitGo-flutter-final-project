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

## Architecture Overview

![FitGo Architecture](./docs/architecture.svg)

### Architecture Flow:
The application follows a clean layered architecture pattern:

1. **User Layer** → Users interact through mobile and web interfaces
2. **Flutter Application** → Cross-platform framework handling the app
3. **UI Layer** → Screens, pages, widgets, and state management
4. **Data Layer** → Models and enums for data structure
5. **Service Layer** → Business logic (UserService, ValidationService, StorageService)
6. **UserSetupController** → Central singleton for in-memory state management
7. **Storage Layer** → Platform-specific persistent storage (File System for mobile, SharedPreferences for web)

#### Data Flow:
**Save Flow:**
1. User Input → UI Layer → ValidationService → UserService → UserSetupController (in-memory)
2. When complete → UserLocalStorageService.saveUserSetup() → Storage (JSON)

**Load Flow:**
1. UserLocalStorageService.loadUserSetup() → Read JSON → Load into UserSetupController

---

## Technologies Used
- Flutter  
- Dart  
- Material UI Widgets  
- Frontend only (no backend)  

---

## App Screens
- Welcome and onboarding pages  
- User setup (gender, height, weight)  
- Workout dashboard  
- Daily exercise list  
- Exercise detail screen with timer  

---

## Future Improvements
- Add backend and user authentication  
- Save workout progress using a database  
- Add more workout types  
- Add dark mode  
- Improve animations and overall UX  

---

