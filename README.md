# Taskun: RPG Task Manager App

<br></br>

## Description

Taskun is a mobile RPG-style task management app built with Flutter. Users can create tasks, track progress, and level up their character and pet as they complete real-world goals.

<br></br>

## Tech Stack
- Flutter (Dart)
- Firebase (Authentication, Firestore Database)
- Unity 2D Editor & Gimp (Custom Pixel Art)
- Provider (State Management)
- Android Emulator (Testing)

<br></br>

## Features

- 📅 Weekly and Monthly Calendar Views
- 🎯 Task Creation, Editing, and Deletion
- 🧙 Character and Pet Selection
- 🏆 Reward System for Task Completion
- 📈 Shop where users can redeem Rewards and Upgrade Player

<br></br>

## App Demo
![image](https://github.com/user-attachments/assets/345f62cf-b668-482d-b75e-876a2f5be383) ![image](https://github.com/user-attachments/assets/c487383e-51f9-4928-9373-67366f5c350e) ![image](https://github.com/user-attachments/assets/fd2833f0-6f08-46c2-a22d-98923bd51226) ![image](https://github.com/user-attachments/assets/7717787c-75e0-4f31-801e-23eceeb8a81b)

<br></br>

## Getting Started (Windows)

### Prerequisites
Before you begin, make sure the following tools are installed:

* Git - [Download Git](https://git-scm.com/downloads)
* Flutter SDK - [Install Flutter](https://docs.flutter.dev/get-started/install)
* Android Studio - [Download Android Studio](https://developer.android.com/studio?gad_source=1&gbraid=0AAAAAC-IOZl3O8pgYH5podY2uyhpbWY3l&gclid=Cj0KCQjw5azABhD1ARIsAA0WFUGvoSISEaIxP171MAsk2colnEaVIA2-Rngk6yDCKoS67xaHt3a8lP0aAhcBEALw_wcB&gclsrc=aw.ds) with:
  - Android SDK
  - Android Emulator
  - Flutter and Dart Plugins

### 🛠️ Installation
#### 1. Clone the repository
* Download and install Git from [git-scm.com](https://git-scm.com/downloads)
* Confirm installation:
  ```
  git --version
   ```
#### 2. Install Flutter SDK
* Download the latest Flutter SDK from [flutter.dev](https://docs.flutter.dev/get-started/install)
* Extract the Flutter zip to a folder (e.g., ```C:\src\flutter```).
* Add ```C:\src\flutter\bin``` to your system ```PATH``` environment variables.
* Confirm installation:
  ```
  flutter --version
  ```
#### 3. Install Android Studio
* Download and install Android Studio from [developer.android.com/studio](https://developer.android.com/studio).
* During setup, ensure you install
  - **Android SDK**
  - **Android Emulator**
  - **Android Virtual Device (AVD)**
  - After installation, open Android Studio and install the **Flutter** and **Dart** plugins:
    * Go to **File** > **Settings** > **Plugins** -> Search "Flutter" -> Install (Dart will install automatically).
### 📤 Clone the Repository
#### 1. Open a terminal or Git Bash
#### 2. Navigate to the folder where you want to store the project:
```
cd C:\Users\YourName\Documents
```
#### 3. Clone the repository:
```
git clone https://github.com/KietLy0120/Taskun.git
```
#### 4. Open the project in Android Studio:
   *Click **Open** -> Select the cloned project folder
### 🚀 Running the App
#### 1. Install Project Dependencies
* In the terminal inside Android Studio, run:
```
flutter pub get
```
#### 2. Set Up an Emulator
* Open **Device Manager** (small phone icon in the Android Studio toolbar).
* Click **Create Device**.
* Select a device (e.g., Pixel 9) and a system image (e.g., Android 12)
* Finish setup and launch the emulator
#### 3. Run the App
* Select your emulator as the target device.
* Press the green **Run** button at the top of Android Studio.
### ✔️ Final Checks
* You can run the Flutter doctor command to verify your environment:
```
flutter doctor
```


## 📚 Additional Resources
A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
