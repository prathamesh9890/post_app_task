# post_app_task
This Flutter project is a functional assignment app that fetches posts from a REST API and displays them in a dynamic list. The app supports offline caching, read-state persistence, per-item timers that pause/resume based on visibility, and detailed post viewing. The project is built using a clean architecture approach with BLoC state management.


This Flutter application demonstrates real-world mobile development concepts including API integration, offline-first caching, reusable architecture, and UI state persistence. The app fetches posts from a remote REST API and displays them in a list with real-time timers that automatically start, pause, and resume based on user interaction and scroll visibility. A post is marked as "read" once tapped, and the status is persistently stored using SharedPreferences.

The project follows a clean and maintainable architecture with layers for data handling, repository logic, state management, and presentation. Error handling, user-friendly messaging, and responsive UI behavior are implemented to ensure a smooth experience. This solution demonstrates concepts such as BLoC state management, Dio-based API communication, widget reusability, and local data persistence suitable for scalable production environments.
