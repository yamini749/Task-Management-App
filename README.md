#  Task Manager App (Flutter)

A simple and powerful Task Manager mobile application built using Flutter.  
This app allows users to manage tasks efficiently with features like CRUD operations, search, filtering, and task dependencies.

---

## 🚀 Features

### ✅ Core Features
- Add new tasks with:
  - Title
  - Description
  - Due Date
  - Status (To-Do, In Progress, Done)
- Edit existing tasks
- Delete tasks
- View all tasks in a list

### 🔍 Search & Filter
- Search tasks by title
- Filter tasks by:
  - All
  - Done
  - Pending

### 🔗 Task Dependency (Blocked By)
- Tasks can depend on other tasks
- A task is disabled (greyed out) if its dependency is not completed
- Automatically becomes active when dependency is completed

### ⏳ Loading State
- Simulated 2-second delay while adding/updating tasks
- Loading indicator shown

---

## 🛠️ Tech Stack

- Flutter
- Dart
- Material UI

---

## 📦 Setup Instructions

1. Install Flutter SDK  
   https://flutter.dev/docs/get-started/install  

2. Clone the repository:
   ```bash
   git clone <your-repo-link>
3. Navigate to Project  
   ```bash
   cd Task-Management-App
4. Install dependencies:  
   ```bash
   flutter pub get
5. Run the app  
   ```bash
   flutter run

