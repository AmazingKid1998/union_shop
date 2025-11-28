# Union Shop - Flutter Coursework

A cross-platform e-commerce application developed using Flutter, designed to recreate the functionality of the official [University of Portsmouth Student Union Shop](https://shop.upsu.net/).

## 📱 Project Overview
This project mimics the user experience of the UPSU shop, featuring a responsive design that works on both mobile and desktop web views. It allows users to browse collections, view product details, and manage a shopping cart.

## ✨ Features Implemented
* **Dynamic Homepage:** Displays featured "Essential Range" products dynamically from a data model.
* **Product Navigation:** Full navigation flow from Home -> Shop -> Collection -> Product Details.
* **Shopping Cart System:** * Add items to cart with immediate feedback.
    * View cart contents with total price calculation.
    * Remove items and clear cart functionality.
    * Dynamic badge on the navigation bar showing real-time item count.
* **Categorization:** Products are filtered by categories (Clothing, Accessories) in the Shop section.
* **Authentication UI:** A clean, responsive login interface.
* **Static Pages:** "About Us" and functional Footer.

## 🛠️ Tech Stack
* **Framework:** Flutter
* **Language:** Dart
* **State Management:** Global Singleton/Manager pattern for Cart state.

## 🚀 How to Run
1.  **Prerequisites:** Ensure you have the Flutter SDK installed.
2.  **Clone the repository:**
    ```bash
    git clone [https://github.com/YOUR-USERNAME/union_shop.git](https://github.com/YOUR-USERNAME/union_shop.git)
    ```
3.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
4.  **Run on Chrome (Recommended):**
    ```bash
    flutter run -d chrome
    ```

## 📂 Project Structure
* `lib/main.dart`: Entry point of the application.
* `lib/pages/`: Contains all screen UI (Home, Product, Cart, Login).
* `lib/widgets/`: Reusable components (Header, Footer).
* `lib/models/`: Data classes (Product, Collection) and Global Cart storage.
* `lib/data/`: Dummy data population.

## 🧪 Testing
The project includes widget tests ensuring the reliability of core components.
Run tests using:
```bash
flutter test
```