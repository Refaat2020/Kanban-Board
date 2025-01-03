
# 📝 Kanban Board

A **Flutter-based application** designed to help you manage tasks using the **Kanban methodology**. It provides a clean, intuitive interface for tracking tasks, adding comments, and managing your progress efficiently. Built with state-of-the-art architecture, this app ensures scalability and maintainability while providing a seamless user experience.

---

## 🚀 Overview

Kanban Board helps you:
- Create, update, and track tasks.
- Add comments to tasks for better collaboration.
- Use a built-in timer to track task progress.
- Enjoy a responsive UI with support for dark and light themes.
- Benefit from error handling and user feedback for a smoother experience.

---

## ✨ Features

- **Manage tasks** with a Kanban-style board.
- Add **comments** to tasks for collaboration.
- Built-in **timer functionality** to track progress.
- Supports **dark and light themes** for better accessibility.
- Robust **error handling** and user feedback mechanisms.
- Fully **responsive UI** for all screen sizes.

---

## 🛠️ Tech Stack

- **Frontend**: Flutter
- **State Management**: Flutter Bloc & Cubit
- **Backend**: Todoist Free API
- **Persistence**: Shared Preferences
- **Dependency Injection**: GetIt (Service Locator)
- **Unit Testing**: Mockito and BlocTest
- **Networking**: HTTP/Dio

---

## 🧱 Architecture

The app is built using **Clean Architecture** to ensure a modular and maintainable codebase. The responsibilities are divided into three layers:

### Architecture Layers

1. **Presentation Layer**:
   - Handles UI/UX.
   - Manages state using Cubits/Blocs.
   - Example: `TaskManagementCubit`.

2. **Domain Layer**:
   - Contains business logic, use cases, and abstract repositories.
   - Example: `TaskManagementService`.

3. **Data Layer**:
   - Manages data sources (APIs, local storage).
   - Implements repositories and mappers.
   - Example: `TaskDataSource`.

### Project Structure

```plaintext
lib/
├── common/
│   ├── constants/      # App-wide constants
│   ├── model/          # Shared models (e.g., FailureModel)
│   └── widgets/        # Reusable widgets
├── core/
│   ├── services/       # Shared services (e.g., ThemeService, DI)
│   └── utils/          # Utility functions
├── features/
│   ├── kanban_board/
│   │   ├── data/
│   │   │   ├── data_source/
│   │   │   ├── models/
│   │   │   └── repository/
│   │   ├── domain/     # Cubits, Services
│   │   └── presentation/
│   └── task_management/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── main.dart           # Entry point of the app
```

---

## 🌀 State Management

This app uses **Flutter Bloc** and **Cubit** for effective state management.

### Examples:
- **TaskManagementCubit**: Manages task-related operations.
- **ThemeCubit**: Handles app theme changes.

### Why Bloc/Cubit?
- Ensures **predictable app behavior**.
- Simplifies **debugging with clear state transitions**.

---

## 🚦 Getting Started

### Prerequisites
- **Flutter SDK**: >= 3.0
- **IDE**: Android Studio, VS Code, or IntelliJ IDEA.
- **Platform tools**: Android SDK, Xcode for iOS (if applicable).

### Setup Instructions

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Refaat2020/Kanban-Board.git
   cd repo-name
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

4. **(Optional) Run tests**:
   ```bash
   flutter test
   ```

---

## 📸 Screenshots & 🎥 Video

### Screenshots
| Light Theme | Dark Theme |
|-------------|------------|
| ![Light Theme Screenshot](https://i.ibb.co/6Nz2yCw/kanban-board-light.png) | ![Dark Theme Screenshot](https://i.ibb.co/7X383jd/kanban-board.png) |
### Video
Check out the app in action:

[![Kanban Board Demo](https://i.ibb.co/7X383jd/kanban-board.png)](https://www.veed.io/view/16ca8058-7948-4bb4-805c-1e5f7574ef02?panel=share)

---

## 🤝 Contributions

Contributions are welcome! Feel free to submit a pull request or open an issue for any improvements or bugs you find.

---

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

Enjoy building tasks with **Kanban Board**! 🎉
```
