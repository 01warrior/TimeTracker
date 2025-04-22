# time_tracker

time_tracker cursera course exam

## Getting Started

This project is a starting point for a Flutter application.

# Flutter Time Tracker App

A mobile application built with Flutter to help users track time spent on different tasks and projects. Data is stored locally on the device using `shared_preferences`.

This project was developed as the final assignment for the Coursera Meta Flutter Course Flutter course.

![home-empty](https://github.com/user-attachments/assets/90d09deb-2a1f-40b3-8a31-6d301395682d)

## Features

*   **Track Time:** Log time spent on specific tasks within projects.
*   **Add Entries:** Easily add new time entries with details:
    *   Project selection (Dropdown)
    *   Task selection (Dropdown)
    *   Total time spent (Hours)
    *   Date selection
    *   Optional notes
*   **View Entries:**
    *   See a chronological list of all time entries.
    *   View entries grouped by project.
*   **Delete Entries:** Remove incorrect or unwanted entries using a swipe-to-delete gesture.
*   **Manage Projects & Tasks:**
    *   Add new projects via a dialog.
    *   Add new tasks via a dialog.
    *   Delete existing projects and tasks (accessible via the navigation drawer/menu).
*   **Local Persistence:** Time entries, projects, and tasks are saved locally using `shared_preferences`, ensuring data persists across app sessions.
*   **State Management:** Uses the `provider` package for managing application state.

## Technology Stack

*   **Framework:** Flutter ([Your Flutter Version, e.g., 3.x.x])
*   **Language:** Dart ([Your Dart Version, e.g., 3.x.x])
*   **State Management:** `provider`
*   **Local Storage:** `shared_preferences`
*   **Date Formatting:** `intl`
*   **Utilities:** `collection` (for `groupBy`)

## Setup and Installation

1.  **Prerequisites:**
    *   Ensure you have the Flutter SDK installed. See [Flutter installation guide](https://flutter.dev/docs/get-started/install).
    *   An editor like VS Code or Android Studio with Flutter plugins.
    *   An emulator/simulator or a physical device connected.

2.  **Clone the repository:**
    ```bash
    git clone https://github.com/[YourGitHubUsername]/[YourRepoName].git
    ```

3.  **Navigate to the project directory:**
    ```bash
    cd [YourRepoName]
    ```

4.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

5.  **Run the app:**
    ```bash
    flutter run
    ```
    (Make sure you have a device selected)

## Usage

1.  Launch the application.
2.  The "All Entries" tab will initially be empty.
3.  Tap the floating action button (`+`) to add a new time entry. Fill in the required details (Project, Task, Time, Date) and optionally add notes.
4.  Added entries will appear on the "All Entries" tab and grouped under their respective projects on the "Grouped by Projects" tab.
5.  Swipe an entry left on the "All Entries" tab to reveal the delete option. Confirm deletion.
6.  Use the navigation drawer (hamburger menu) to access the "Manage Projects & Tasks" screen.
7.  On the management screen, use the AppBar action (+) to add projects and the floating action button (+) to add tasks via dialog boxes. You can also delete existing projects/tasks from this screen.

## Acknowledgements

This project was developed based on the requirements and specifications provided by the Coursera
