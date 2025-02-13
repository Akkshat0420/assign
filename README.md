# assign
✅ Firebase - Manages authentication,Notification database, and storage.
✅ State Management - Uses setState (or Provider, Riverpod, etc.) for UI updates.
✅ Infinite Scroll - Loads more products when the user scrolls down.
✅ Bottom Sheet Login - Displays a modal for user authentication.
A few resources to get you started if this is your first Flutter project:

🏛️ Architecture Followed in This Project
Model: Represents the data layer (Firebase, APIs, Local Storage).
View: The UI components (Screens & Widgets).
ViewModel (Controller): Handles business logic, API calls, and state management.
API & Backend Architecture
Uses REST APIs for fetching and storing product/user data.
Integration with Firebase for authentication and real-time database and Notification.
API calls are handled in services/ using Dio or HTTP package.


## 🚀 Steps to Set Up and Run the Project

Follow these steps to set up and run your e-commerce project locally:

---

### 1️⃣ Clone the Repository  
- Open a terminal and run:
  ```sh
git clone https://github.com/your-username/your-repository.git
cd your-repository

flutter run

▶️ Run on a Specific Device

flutter run -d chrome  # For web  
flutter run -d emulator-5554  # For Android Emulator

6️⃣ Build the APK 
📦 Generate Android APK
flutter build apk --release


- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
