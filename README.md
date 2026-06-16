# Sync Communication App

## Project Overview

Sync Communication App is a Flutter-based messaging and calling application designed for secure, real-time communication. It supports authenticated user sessions, chat conversations, voice and video calls, presence tracking, and user search. The project follows a clean, modular architecture with a centralized theming system to ensure maintainability, scalability, and a consistent user experience.

## Features

- User authentication with email/password and Google Sign-In
- Real-time chat with message history and typing controls
- Voice and video call integration using Zego SDK
- Presence status updates and active user listing
- Search for users and initiate conversations
- User profile management with editable display name and appearance settings
- Local persistence with Hive for fast startup and user session retention
- Centralized theme system with light and dark mode support for consistent UI experience
- Firebase backend integration for authentication, messaging, and notifications
- Responsive and polished UI with gradient-based design and animated transitions

## Architecture

The project follows a modular Flutter architecture with feature-based separation and clean routing. The key structural elements include:

- `lib/main.dart` - Application entry point, theme management, app lifecycle handling, and route generation
- `lib/app_initializer.dart` - App bootstrap, Firebase initialization, Hive setup, and Google Sign-In initialization
- `lib/core/` - Shared utilities, theme definitions, routing, and global app helpers
- `lib/cubit/` - BLoC-style state management implementation using `flutter_bloc` and `equatable`
- `lib/data/` - Data models, local storage adapters, and network-related models
- `lib/features/` - Feature modules split by domain:
  - `authentication/` - login, signup, and onboarding screens
  - `home/` - home feed, active user list, and chat summary UI
  - `main navigation/` - bottom navigation controller and page routing
  - `calls/` - call history and call interaction screens
  - `chats/` - direct chat conversation screen and message UI
  - `search/` - user discovery and search results
  - `profile/` - user profile settings, theme toggle, and logout flow
- `lib/services/` - integration services for third-party SDKs, including Zego call services
- `lib/widgets/` - reusable UI components such as gradient buttons, skeleton loaders, text fields, and overlays

### Folder Structure Explanation

- `lib/core/` contains shared app configuration, router paths, and theme logic.
- `lib/cubit/` holds the application state controllers and state definitions for each domain.
- `lib/features/` groups features by business capability, making the app easier to maintain and extend.
- `lib/data/` defines the data contract and persistence layers.
- `lib/services/` isolates integration logic for external SDKs and platform services.
- `lib/widgets/` provides a shared widget library, promoting UI consistency across screens.

## State Management Approach

Sync Communication App uses the BLoC pattern powered by `flutter_bloc` and `equatable`.

- Each functional area has its own cubit or bloc in `lib/cubit/`
- State changes are emitted as immutable objects and consumed by UI widgets with `BlocBuilder`, `BlocListener`, and `BlocSelector`
- This approach keeps UI logic separate from business logic and improves testability
- The app also uses a global `ThemeCubit` for theme toggling and a `UserCubit` for user session state

## Screens

### Splash Screen

- Loads the current user session from Hive
- Initializes Firebase and call infrastructure
- Redirects users to the onboarding screen or main app based on login state

### Get Started Screen

- Presents a branded entry experience for new users
- Navigates to login when the user is ready to begin

### Login Screen

- Collects email and password credentials
- Displays Google Sign-In option
- Authenticates users via Firebase Auth

### Signup Screen

- Allows users to register with username, email, and password
- Supports password confirmation validation
- Initiates a user session and navigates to the main app after successful signup

### Main Navigation / Home Tab

- Provides bottom navigation between Home, Calls, and Profile tabs
- Manages tab state through `BottomNavBarCubit`

### Home Screen

- Shows active users and current chat sessions
- Supports pull-to-refresh for chat and presence data
- Navigates to chat detail screens

### Search Screen

- Enables searching for users by name
- Displays matching results and lets users open chat sessions
- Uses debounced search queries for smooth UX

### Chat Screen

- Displays a conversation thread with message bubbles
- Supports sending new text messages
- Includes voice and video call buttons for live communication

### Calls Screen

- Lists recent call history with incoming/outgoing indicators
- Supports re-initiating calls through the call dialog

### Profile Screen

- Shows user avatar and editable username
- Includes theme toggle and account settings shortcuts
- Provides logout functionality

### UI Preview

![Chat Screen Screenshot](https://github.com/manaltaha555/portfolio-flutter/blob/master/assets/images/sync_chat.png)

![Dark_Theme Screenshot](https://github.com/manaltaha555/portfolio-flutter/blob/master/assets/images/sync_dark.png)

![Light_Theme Screenshot](https://github.com/manaltaha555/portfolio-flutter/blob/master/assets/images/sync_light.png)

![Profile Screenshot](https://github.com/manaltaha555/portfolio-flutter/blob/master/assets/images/sync_pick.png)


## API / Backend Integration

Sync Communication App integrates with multiple backend services:

- Firebase Authentication for email/password and Google Sign-In
- Cloud Firestore for chat data and user metadata
- Firebase Realtime Database for presence and real-time updates
- Firebase Cloud Messaging for push notifications
- Zego UIKit Prebuilt Call SDK for audio/video calling and signaling
- Hive local storage for cached user sessions and settings

### Initialization flow

- `lib/app_initializer.dart` initializes Hive and Firebase
- `lib/main.dart` starts state providers and loads theme/user state
- `lib/splash_screen.dart` checks login state and initializes presence/call services

## Packages Used

### Core packages

- `flutter` - Flutter SDK
- `flutter_bloc` - BLoC state management
- `equatable` - Immutable state comparison
- `logger` - Logging during development

### UI and assets

- `flutter_svg` - SVG icon rendering
- `iconsax` - Icon pack for UI elements
- `shimmer` - Loading state shimmer animation
- `flutter_native_splash` - Native splash screen generation
- `flutter_launcher_icons` - Launcher icon generation

### Persistence and storage

- `hive_ce` - Local key-value storage
- `hive_ce_flutter` - Hive Flutter integration
- `hive_ce_generator` - Hive type adapter generator

### Firebase and backend

- `firebase_core` - Firebase initialization
- `firebase_auth` - Authentication service
- `cloud_firestore` - Firestore database
- `firebase_database` - Realtime Database
- `firebase_messaging` - Push notifications
- `google_sign_in` - Google Sign-In

### Communication SDKs

- `zego_uikit_prebuilt_call` - Prebuilt voice/video call UI
- `zego_uikit_signaling_plugin` - Zego signaling support

## Setup & Installation Guide

### Prerequisites

- Flutter SDK installed (compatible with `sdk: ^3.11.4`)
- Android Studio, Xcode, or Visual Studio depending on the target platform
- Firebase project configured with Android/iOS bundle IDs
- Google Sign-In enabled for Firebase project

### Clone repository

```bash
git clone https://github.com/manaltaha555/sync-communication-app
cd sync_communication_app
```

### Install dependencies

```bash
flutter pub get
```

### Configure Firebase

1. Add Firebase configuration files to the platform directories:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
2. Ensure `firebase_core` and Firebase initialization are properly set.

### Run the app

```bash
flutter run
```

### Build for release

```bash
flutter build apk
```

## Future Improvements

- Add support for message attachments such as images and voice notes
- Implement group chat functionality and group calling
- Add typing indicators and read receipts
- Add more advanced user settings and profile customization
- Improve offline support and message synchronization
- Add automated tests for critical flows and state management
- Add accessibility improvements and localization support
