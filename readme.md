# News Headlines App

A Flutter news headlines application built with *Clean Architecture, **offline caching, and **Provider* state management. The app fetches top US news headlines from [NewsAPI](https://newsapi.org/) and stores them locally using Hive so users can read headlines even without an internet connection.

---

## What This App Does

- Displays the *top 30 US news headlines* in a scrollable list
- Each headline shows the article image, title, source name, and published date
- Tapping a headline opens a *detail page* with the full article image, title, description, and content
- Supports *pull-to-refresh* to fetch the latest headlines
- Works *offline* by serving cached data when there is no internet
- Shows clear *error messages* with a retry button when something goes wrong

---

## Assignment Requirements Covered

| Requirement | How It's Implemented |
|---|---|
| Fetch news from a public API | Uses NewsAPI (/v2/top-headlines) via Dio HTTP client |
| Display headlines in a list | HeadlinesPage with ListView showing image, title, source, date |
| Article detail screen | ArticleDetailPage with hero image, full title, description, and content |
| Offline support / caching | Hive local database caches articles as JSON; served when offline |
| State management | Provider + ChangeNotifier (HeadlinesViewModel) |
| Error handling | Custom Failure classes, user-friendly error messages, retry button |
| Clean Architecture | Separated into domain, data, and presentation layers |
| Dependency injection | GetIt service locator registers all dependencies |

---

## Tech Stack

| Purpose | Package | Why |
|---|---|---|
| State management | provider | Simple, lightweight reactive state via ChangeNotifier |
| Dependency injection | get_it | Service locator for clean dependency management |
| HTTP client | dio | Powerful HTTP client with timeouts and interceptors |
| Connectivity check | connectivity_plus | Detects whether the device is online or offline |
| Local storage | hive + hive_flutter | Fast, lightweight NoSQL database for caching articles |
| Image caching | cached_network_image | Loads and caches images from the network |
| Typography | google_fonts | Roboto Slab font for a clean editorial look |

---

## Project Structure


lib/
├── main.dart                              # App entry point, Hive init, Provider setup
│
├── di/
│   └── service_locator.dart               # GetIt dependency registration
│
├── Services/
│   └── api_client.dart                    # Dio wrapper for NewsAPI requests
│
├── core/
│   ├── error/
│   │   └── failures.dart                  # ServerFailure, CacheFailure classes
│   ├── network/
│   │   └── network_info.dart              # Checks internet connectivity
│   └── usecase/
│       └── usecase.dart                   # Base UseCase class
│
├── data/
│   ├── datasources/
│   │   ├── news_remote_data_source.dart   # Fetches articles from NewsAPI
│   │   └── news_local_data_source.dart    # Reads/writes articles from/to Hive
│   ├── models/
│   │   └── article_model.dart             # ArticleModel with JSON serialization
│   └── repositories/
│       └── news_repository_impl.dart      # Decides: fetch remote or serve cache
│
├── domain/
│   ├── entities/
│   │   └── article.dart                   # Article entity (pure Dart class)
│   ├── repositories/
│   │   └── news_repository.dart           # Repository contract (abstract class)
│   └── usecases/
│       └── get_top_headlines.dart          # GetTopHeadlines use case
│
└── presentation/
    ├── pages/
    │   ├── headlines_page.dart            # Main screen with headline list
    │   └── article_detail_page.dart       # Detail screen for a single article
    ├── viewmodels/
    │   └── headlines_view_model.dart       # ChangeNotifier managing UI state
    └── widgets/
        ├── article_list_item.dart         # Single headline row widget
        ├── error_view.dart                # Error message + retry button
        └── loading_view.dart              # Loading spinner


---

## How Offline Caching Works

This is the core feature of the app. Here's how it works in simple terms:

### The Big Idea

Every time the app successfully loads headlines from the internet, it *saves a copy locally* on the device using Hive (a lightweight local database). Later, if the internet is unavailable, the app *reads that saved copy* instead and shows it to the user.

### Step-by-Step Flow

#### When the device is ONLINE:

1. The app checks internet connectivity using connectivity_plus
2. It makes an API call to NewsAPI to fetch the latest headlines
3. If the API call *succeeds*:
   - The articles are *saved to Hive* (overwriting any old cache)
   - The fresh articles are shown on screen
4. If the API call *fails* (e.g., server error, timeout):
   - The app tries to *read from Hive* cache
   - If cache exists, those cached articles are shown
   - If no cache exists, an error message is shown with a retry button

#### When the device is OFFLINE:

1. The app detects there is no internet
2. It goes *directly to Hive* to read the saved articles
3. If cache exists, those articles are shown (the user may not even notice they're offline)
4. If no cache exists (e.g., first time opening the app with no internet), the error message says: "No internet connection and no cached headlines."

### Where It Happens in the Code

*The decision logic* lives in NewsRepositoryImpl:


news_repository_impl.dart (simplified):

is device online?
  ├── YES → fetch from API
  │         ├── success → save to Hive, return articles
  │         └── failure → read from Hive (fallback)
  └── NO  → read from Hive directly
              ├── cache exists → return cached articles
              └── no cache    → throw CacheFailure error


*The Hive storage* lives in NewsLocalDataSourceImpl:
- cacheTopHeadlines() — converts articles to JSON and writes them to a Hive box called headlines_cache
- getLastTopHeadlines() — reads the JSON from the Hive box and converts it back to article objects

*Image caching* is handled separately by the cached_network_image package. Once an article image is downloaded, it is stored on disk and shown from cache on subsequent views — even offline.

---

## How to Run the Project

### Prerequisites

- Flutter SDK 3.3.0 or higher
- A physical device or emulator/simulator
- An active internet connection for the first run (to fetch initial data)

### Steps

bash
# 1. Clone the repository
git clone <repository-url>
cd Flutter-assignment

# 2. Install dependencies
flutter pub get

# 3. Run on your connected device or emulator
flutter run


The app runs on *Android, **iOS, **Web, and **macOS*.

---

## How to Test Offline Caching

Follow these steps to verify that offline caching works correctly:

### Test 1: Normal Online Usage (Populate the Cache)

1. Make sure your device/emulator has an *active internet connection*
2. Open the app
3. Wait for headlines to load — you should see a list of news articles
4. This load has *automatically cached* the articles to Hive in the background

### Test 2: Go Offline and Reopen

1. Turn on *Airplane Mode* (or disable Wi-Fi and mobile data)
2. *Force close* the app completely
3. Reopen the app
4. *Expected result:* The same headlines from your last online session should appear — loaded from cache
5. You can also *pull down to refresh* — it will still show cached data since there's no internet

### Test 3: Fresh Install with No Internet

1. *Uninstall* the app (or clear app data from device settings)
2. Make sure the device is *offline* (Airplane Mode)
3. *Reinstall and open* the app
4. *Expected result:* You should see an error message: "No internet connection and no cached headlines." with a *Retry* button
5. Turn the internet back on and tap *Retry* — headlines should load

### Test 4: API Failure Fallback

1. Load the app normally once while online (to populate cache)
2. Now, without clearing the cache, simulate an API failure. You can do this by:
   - Temporarily changing the API key in lib/Services/api_client.dart to something invalid
   - Or blocking newsapi.org on your network
3. Reopen the app or pull-to-refresh
4. *Expected result:* The app shows *cached headlines* instead of an error, because it falls back to cache when the API fails

### Testing on Android Emulator

- Open the emulator's extended controls (three dots icon)
- Go to *Settings > Cellular > Network type* and set it to *No connection*
- Or simply toggle Wi-Fi off in the emulator's quick settings

### Testing on iOS Simulator

- The iOS Simulator shares the Mac's network — turn off Wi-Fi on your Mac
- Or use Network Link Conditioner (available in Xcode's developer tools) to simulate no network

---

## Architecture Overview

The app follows *Clean Architecture* with three main layers:


┌─────────────────────────────────────────────┐
│              Presentation Layer              │
│   (Pages, Widgets, ViewModels)              │
│   Handles UI and user interactions           │
├─────────────────────────────────────────────┤
│               Domain Layer                   │
│   (Entities, Use Cases, Repository contracts)│
│   Pure business logic, no dependencies       │
├─────────────────────────────────────────────┤
│                Data Layer                    │
│   (Models, Data Sources, Repository impl)    │
│   Handles API calls and local storage        │
└─────────────────────────────────────────────┘


- *Domain* defines what the app does (entities, use cases, contracts)
- *Data* defines how it does it (API calls, Hive storage, JSON mapping)
- *Presentation* defines what the user sees (screens, widgets, state)

Dependencies point *inward* — the domain layer has zero dependencies on data or presentation.

---

## State Management

The app uses *Provider + ChangeNotifier*:

- HeadlinesViewModel holds the current state: loading, loaded, error, or initial
- The UI (HeadlinesPage) watches the ViewModel and rebuilds when state changes
- On loaded — shows the article list
- On loading — shows a spinner
- On error — shows an error message with a retry button

---

## API Details

- *API:* [NewsAPI](https://newsapi.org/) (free tier)
- *Endpoint:* GET /v2/top-headlines?country=us&pageSize=30
- *Response:* Returns an array of article objects with title, description, content, image URL, source, and published date
