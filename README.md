📝 Task Manager Flutter App
A modern, elegant task management application built with Flutter that demonstrates Clean Architecture, BLoC state management, and Object-Oriented Programming principles. The app allows users to create, manage, and complete different types of tasks with specific business rules.

✨ Features
📋 Core Functionality
Task Management: Create, view, and mark tasks as completed

Task Types: Support for two different task types with specific business rules

Modern UI: Beautiful, responsive Material Design 3 interface

Real-time Updates: Instant UI updates using BLoC state management

🎯 Task Types & Business Rules
Simple Task

Can be completed at any time

No time restrictions

Basic task with title and description

Timed Task

Can only be completed after the due time

Visual countdown/status indicator

Date and time picker for setting deadlines

🎨 User Interface Features
Elegant Task Cards: Modern card design with shadows and rounded corners

Visual Task Type Indicators: Color-coded badges for task types

Intuitive Bottom Sheet: Beautiful modal for creating new tasks

Empty State Design: Friendly illustration when no tasks exist

Sorting: Tasks automatically sorted (incomplete first, newest first)

Responsive Design: Works on both mobile and tablet devices

⚙️ Technical Features
Clean Architecture: Clear separation of concerns (Domain, Data, Presentation)

BLoC Pattern: Predictable state management

OOP Principles: Abstraction, Inheritance, Encapsulation demonstrated

Repository Pattern: Abstract data layer for easy testing

Immutable State: Using Equatable for efficient state comparison

🏗️ Architecture
text
lib/
├── domain/
│   ├── entities/
│   │   ├── task.dart          # Abstract Task class
│   │   ├── simple_task.dart   # SimpleTask implementation
│   │   └── timed_task.dart    # TimedTask implementation
│   └── repositories/
│       └── task_repository.dart # Abstract repository
├── data/
│   └── repositories/
│       └── task_repository_impl.dart # Concrete implementation
└── presentation/
    ├── screens/
    │   └── task/
    │       └── task_screen.dart # Main UI screen
    └── task/                    # BLoC files
        ├── task_bloc.dart
        ├── task_event.dart
        └── task_state.dart
🚀 Getting Started
Prerequisites
Flutter SDK (>=3.0.0)

Dart (>=2.19.0)

Android Studio/VSCode with Flutter extension

Installation
Clone the repository

bash
git clone https://github.com/yourusername/task-manager-flutter.git
cd task-manager-flutter
Install dependencies

bash
flutter pub get
Run the app

bash
flutter run
Dependencies
The app uses the following packages:

flutter_bloc: State management

equatable: Immutable value objects

uuid: Unique ID generation

intl: Date/time formatting

📱 Screenshots
