# ShopApp 🛍️

A production-grade Flutter shopping application built with **BLoC + MVVM** clean architecture. Fetches products from [FakeStore API](https://fakestoreapi.com), supports real-time search, persistent favorites, and handles all loading/error/empty states gracefully.

---



## 📱 Screenshots

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/97ea75d8-db4a-493e-8236-52704e46fb0e" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/2cf1f2d1-7874-4e1f-b451-55fef10b8987" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/9f414d93-a718-42c7-8ec7-144e7d38d22b" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/fe7734dc-bfcc-4e6c-964f-2103f4732390" width="200"/></td>

  </tr>
</table>
---

## 🚀 Project Setup Instructions

### Prerequisites
- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- Android Studio / VS Code
- A real device or emulator

### Steps

**1. Clone the repository**
```bash
git clone https://github.com/your-username/shop_app.git
cd shop_app
```

**2. Install dependencies**
```bash
flutter pub get
```

**3. Add Internet Permission (Android)**

Open `android/app/src/main/AndroidManifest.xml` and add before `<application>`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
```

**4. Run the app**
```bash
flutter run
```

> ✅ The `product_model.g.dart` (Hive adapter) is already pre-generated and committed.  
> You do **not** need to run `build_runner` unless you modify the model.  
> If you do modify it, regenerate with:
> ```bash
> dart run build_runner build --delete-conflicting-outputs
> ```

---

## 🏗️ Architecture Explanation

This project follows **MVVM (Model-View-ViewModel)** pattern layered with a **Repository Pattern** and **BLoC** as the ViewModel. The codebase is split into 3 main layers:


### Why MVVM + BLoC?

| Role | Maps To |
|---|---|
| **Model** | `ProductModel`, `RatingModel` |
| **View** | Screens + Widgets |
| **ViewModel** | `ProductBloc`, `FavoritesBloc` |

The BLoC acts as the ViewModel — it holds no UI references, is fully testable, and exposes state as a stream that the View subscribes to.

---

## ⚙️ State Management Explanation

This app uses **[flutter_bloc](https://pub.dev/packages/flutter_bloc)** (BLoC pattern).

### ProductBloc

The central BLoC managing the entire product lifecycle:

| Event | Description |
|---|---|
| `LoadProductsEvent` | Initial fetch — emits `ProductLoading` → `ProductLoaded` or `ProductError` |
| `RefreshProductsEvent` | Pull-to-refresh — keeps current state visible with `isRefreshing: true` |
| `SearchProductsEvent` | Filters `allProducts` locally — no new API call |
| `ToggleFavoriteEvent` | Adds/removes ID from `favoriteIds`, persists via Hive |
| `LoadFavoritesEvent` | Reloads favorite IDs from Hive into current state |

### States

```dart
ProductInitial   // App just launched
ProductLoading   // Fetching from API — shows shimmer
ProductLoaded    // Success — holds allProducts, filteredProducts, favoriteIds
ProductError     // Failed — holds error message, UI shows retry button
```

### FavoritesBloc

A lightweight derived BLoC. It receives `allProducts` + `favoriteIds` from `ProductBloc` and filters the list for the Favorites screen. This keeps the source of truth in one place (`ProductBloc`) and avoids data duplication.

### Error Handling

Uses a custom `Either<L, R>` type across the repository layer:
- `Right(value)` → success path
- `Left(message)` → error path

This forces every caller to explicitly handle both outcomes, making silent failures impossible.

```dart
productsResult.fold(
  (error) => emit(ProductError(error)),   // Left
  (products) => emit(ProductLoaded(...)), // Right
);
```

---

## 📦 Third-Party Packages Used

| Package | Version | Purpose |
|---|---|---|
| [flutter_bloc](https://pub.dev/packages/flutter_bloc) | ^8.1.4 | BLoC state management |
| [equatable](https://pub.dev/packages/equatable) | ^2.0.5 | Value equality for BLoC events/states — prevents unnecessary rebuilds |
| [http](https://pub.dev/packages/http) | ^1.2.1 | HTTP client for REST API calls |
| [hive](https://pub.dev/packages/hive) | ^2.2.3 | Lightweight local key-value storage for favorites persistence |
| [hive_flutter](https://pub.dev/packages/hive_flutter) | ^1.1.0 | Flutter integration for Hive |
| [cached_network_image](https://pub.dev/packages/cached_network_image) | ^3.3.1 | Caches product images — prevents re-downloading on scroll |
| [flutter_rating_bar](https://pub.dev/packages/flutter_rating_bar) | ^4.0.1 | Star rating indicator widget |
| [shimmer](https://pub.dev/packages/shimmer) | ^3.0.0 | Skeleton loading animation |

### Dev Dependencies

| Package | Purpose |
|---|---|
| [hive_generator](https://pub.dev/packages/hive_generator) | Generates Hive TypeAdapters from annotations |
| [build_runner](https://pub.dev/packages/build_runner) | Code generation runner |
| [flutter_lints](https://pub.dev/packages/flutter_lints) | Recommended Flutter lint rules |

---

## ✅ Features

- [x] Product listing with image, title, price, star rating
- [x] Product detail screen with full description and category
- [x] Real-time local search by product title
- [x] Favorites with Hive persistence (survives app restart)
- [x] Shimmer skeleton loading state
- [x] User-friendly error state with Retry button
- [x] Empty state for no results / no favorites
- [x] Pull-to-refresh on product listing
- [x] Fully null-safe Dart code
- [x] Responsive 2-column grid layout
- [x] Clean MVVM + BLoC architecture

---

## 🗂️ Git Commit Convention
