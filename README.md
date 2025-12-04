Union Shop - Flutter E-Commerce AppA cross-platform (Web & Mobile) e-commerce application developed using Flutter, designed to replicate and enhance the functionality of a university student union shop. This project demonstrates modern Flutter development practices, including MVVM architecture, state management with Provider, responsive design, and Firebase backend integration.📱 Project OverviewThe Union Shop app allows students and staff to browse university merchandise, manage a shopping cart, and simulate a checkout process. It features a responsive layout that adapts seamlessly between mobile (hamburger menu) and desktop (navigation bar) views.Key FeaturesDynamic Product Catalog: Browse products by categories (Clothing, Merchandise, etc.) with deep linking support (e.g., /collection/c_clothing).Product Details: View rich product pages with image galleries, price details (including sale logic), and variant selection (size/color).Shopping Cart: Fully functional cart with persistent state (via Firebase/Local Storage), allowing users to add/remove items and adjust quantities.Search Functionality: Real-time product search with instant filtering.Authentication: User Sign Up, Login, and Profile management using Firebase Authentication.Data Persistence: User carts are stored in Cloud Firestore, ensuring cross-device synchronization for logged-in users.Responsive Design: Adaptive UI that shifts navigation patterns based on screen width (MobileNavMenu vs DesktopNavBar).Deep Linking: URL-based navigation for products and collections, enabling easy sharing and page refreshes on the web.🛠️ Tech Stack & ArchitectureThis project follows the MVVM (Model-View-ViewModel) architectural pattern to separate UI logic from business logic.Framework: Flutter (Dart)State Management: ProviderBackend: FirebaseAuthentication: Email/Password login.Cloud Firestore: Storing user cart data.Routing: Custom onGenerateRoute for dynamic path parsing and deep linking.Testing: flutter_test for Unit and Widget testing.Directory Structurelib/
├── config/          # Configuration files (e.g., Firebase options)
├── data/            # Dummy data sources (for development)
├── models/          # Data models (Product, CartItem)
├── pages/           # UI Screens (HomePage, ProductPage, CartPage)
├── repositories/    # Data layer handling API/DB calls
├── services/        # External services (AuthService)
├── viewmodels/      # State management logic (ShopViewModel, CartViewModel)
├── widgets/         # Reusable UI components (SiteHeader, ProductCard)
└── main.dart        # Entry point and Routing logic
🚀 Getting StartedPrerequisitesFlutter SDK installed.A Firebase project created with Authentication and Firestore enabled.InstallationClone the repository:git clone [https://github.com/your-username/union-shop.git](https://github.com/your-username/union-shop.git)
cd union-shop
Install dependencies:flutter pub get
Firebase Configuration:Create a file lib/config/firebase_options.dart.Add your Firebase configuration keys (API Key, App ID, etc.) to this file. Note: This file is ignored by git for security.Run the App:# For Chrome (Web)
flutter run -d chrome

# For Mobile (Emulator)
flutter run
🧪 TestingThe project includes a comprehensive test suite covering critical user flows and logic.Unit Tests: Verify ViewModel logic (e.g., Cart calculations, Search filtering).Widget Tests: Verify UI rendering and interaction (e.g., Navigation clicks, Form inputs).To run all tests:flutter test
To generate a coverage report:flutter test --coverage
# (Optional) Generate HTML report if you have lcov installed
genhtml coverage/lcov.info -o coverage/html
📸 ScreenshotsHome Page (Desktop)Product Page (Mobile)Cart & Checkout(Place screenshot here)(Place screenshot here)(Place screenshot here)🔮 Future ImprovementsPayment Integration: Connect Stripe or PayPal for real payment processing.Admin Panel: A dedicated interface for adding/removing products without code changes.User Reviews: Allow students to leave ratings on products.Author: [Your Name]Course: [Your Course Name]University: University of Portsmouth