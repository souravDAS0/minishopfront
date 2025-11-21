# MiniShopfront

A Flutter e-commerce application showcasing product listings, search with autocomplete, favorites management, and sorting features.

## Features

- **Product Listing**: Display products in a responsive grid layout with images, names, prices, and favorite toggles
- **Search with Autocomplete**: Smart search with Trie-based autocomplete suggestions (max 5 suggestions)
- **Favorites Management**: Add/remove products to favorites with local persistence using Hive
- **Sorting**: Sort products by price (Low to High, High to Low)
- **Favorites**: dedicated page to view favorite products
- **Product Details**: Detailed product view with full description and images
- **UI States**: Proper loading, error, and empty states

## How to Run

### Prerequisites

- Flutter SDK (>= 3.9.0)
- Dart SDK (>= 3.9.0)
- Android Studio / VS Code with Flutter extensions
- An emulator or physical device

### Installation Steps

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd minishopfront
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## Architecture

The project follows a **simplified clean architecture** with clear separation of concerns:

```
lib/
├── commons/
│   ├── models/              # Data models (Product)
|   │   └──product.dart
│   ├── notifiers/           # Riverpod State Notifiers
│   │   ├── favorites_notifier.dart
│   │   ├── product_notifier.dart
│   │   └── search_notifier.dart
│   ├── providers/           # Riverpod state management
│   │   ├── product_provider.dart
│   │   ├── search_provider.dart
│   │   └── favorites_provider.dart
│   └── services/            # Business logic & external services
│       ├── api_service.dart        # HTTP client using Dio
│       ├── hive_service.dart       # Local storage
│       └── autocomplete_trie.dart  # DSA: Trie algorithm
├── pages/
│   ├── home/               # Home page with product grid
│   │   └── widgets/        # Reusable widgets
│   ├── wishlist/
│   └── product_detail/     # Product detail page
└── main.dart               # App entry point
```

### State Management

**Flutter Riverpod** is used for reactive state management:

- `ProductProvider`: Manages product loading, sorting
- `SearchProvider`: Handles search query and autocomplete
- `FavoritesProvider`: Manages favorite products and filters

## Autocomplete Algorithm (DSA Task)

### Implementation: Trie (Prefix Tree)

The autocomplete feature uses a **Trie data structure** for efficient prefix-based search.

#### Why Trie over Binary Search?

| Aspect                | Trie                                                 | Binary Search                                   |
| --------------------- | ---------------------------------------------------- | ----------------------------------------------- |
| **Search Complexity** | O(m) where m = prefix length                         | O(log n + k) where n = total words, k = matches |
| **Live Typing**       | Excellent - constant time regardless of dataset size | Slower for live updates                         |
| **Memory**            | Higher (stores character tree)                       | Lower (sorted array)                            |
| **Best For**          | Autocomplete, live suggestions                       | Static sorted searches                          |

#### Algorithm Details

```dart
Time Complexity:
- Insert: O(L) where L is word length
- Search: O(m + k) where m is prefix length, k is number of suggestions
- Space: O(N * L) where N is number of words

Features:
- Case-insensitive search
- Maximum 5 suggestions
- DFS traversal for collecting results
- Early termination when limit reached
```

#### How It Works

1. **Initialization**: All product names are inserted into the Trie when products load
2. **Search**: As user types, traverse Trie to prefix node in O(m) time
3. **Suggestions**: Depth-first search collects up to 5 words with matching prefix
4. **Update**: Live results update on every keystroke

**Code Location**: `lib/commons/services/autocomplete_trie.dart`

## Persistence Method

### Hive - Local Storage Solution

**Why Hive?**

- **Fast**: Pure Dart, faster than SQLite for simple key-value storage
- **Type-Safe**: Strongly typed boxes prevent runtime errors
- **Lightweight**: No native dependencies, small footprint
- **Perfect for Favorites**: Simple list storage without complex queries
- **Cross-Platform**: Works on all Flutter platforms

**Alternative Considered**: SharedPreferences

- Rejected because: Limited to primitive types, requires JSON serialization for lists, slower performance

**Implementation**:

- Favorite product IDs stored as `List<int>` in Hive box
- Async operations for add/remove/toggle
- Initialized on app startup in `main.dart`

**Code Location**: `lib/commons/services/hive_service.dart`

## API Integration

**Fakestore API**: `https://fakestoreapi.com/products`

### HTTP Client: Dio

- **Features**: Timeout handling, interceptors, better error management
- **Advantages over `http` package**: Built-in request/response logging, interceptors, simpler timeout configuration
- **Error Handling**: Network errors mapped to user-friendly messages

### Data Mapping

```json
API Response → Product Model:
{
  "title" → "name",
  "image" → "image",
  "price" → "price",
  "description" → "description",
  "category" → "category"
}
```

## Dependencies

```yaml
dependencies:
  dio: ^5.4.0 # HTTP client
  flutter_riverpod: ^2.4.9 # State management
  hive: ^2.2.3 # Local database
  hive_flutter: ^1.1.0 # Hive Flutter integration
  cached_network_image: ^3.3.1 # Image caching
```

## Project Structure Highlights

### Key Components

1. **Product Model** (`product.dart`)

   - JSON serialization/deserialization
   - Maps API fields to app domain models
   - Includes `copyWith`, equality operators

2. **Providers** (Riverpod StateNotifiers)

   - ProductProvider: API calls, sorting logic
   - SearchProvider: Trie initialization, search logic
   - FavoritesProvider: Hive integration, filtering

3. **Services**

   - ApiService: Dio configuration, error handling
   - HiveService: CRUD operations for favorites
   - AutocompleteTrie: Custom DSA implementation

4. **UI Components**
   - ProductCard: Grid item with favorite toggle
   - SearchBarWidget: Search input with dropdown
   - AutocompleteDropdown: Suggestions list
   - HomePage: Main product grid with filters
   - ProductDetailPage: Full product details

## Features Breakdown

### 1. Product List Screen

- Grid layout (2 columns)
- Product card: image, name (1 line), price, favorite icon
- Pull-to-refresh
- Scroll performance optimized with `GridView.builder`

### 2. Search + Autocomplete

- Live search as user types
- Max 5 autocomplete suggestions
- Trie-based algorithm (custom implementation)
- Dropdown UI for suggestions
- Clear search button

### 3. Favorites

- Toggle favorite from list and detail screens
- Persisted locally with Hive
- "Show Favorites Only" filter toggle
- Visual indication (red heart icon)

### 4. Sorting

- Price: Low → High
- Price: High → Low
- Clear sort option
- Bottom sheet UI for sort options

### 5. Product Detail Screen

- Large product image
- Name, category, price
- Full description
- Product information card
- Favorite toggle button

### 6. UI States

- **Loading**: Spinner with "Loading products..." message
- **Error**: Error icon with message and retry button
- **Empty**:
  - No products: "No products available"
  - No search results: "No products found"
  - No favorites: "No favorite products yet"

## Known Limitations

1. **No Pagination**:

   - Fetches all products at once
   - Fakestore API doesn't support pagination parameters
   - May cause performance issues with larger datasets

2. **Network Dependency**:

   - No offline caching for products
   - Only favorites persist locally
   - Requires internet connection to load products

3. **Image Loading**:

   - Dependent on external image URLs
   - May fail if Fakestore API images are unavailable

4. **Single API Endpoint**:

   - Limited to Fakestore API products
   - No category filtering (API limitation)

5. **Basic Error Handling**:

   - Generic error messages
   - No retry logic beyond manual refresh
   - Network errors may not be specific enough

6. **No Authentication**:

   - No user accounts
   - Favorites not synced across devices
   - Local-only persistence

7. **Search Limitations**:
   - Only searches product names
   - No fuzzy matching or typo tolerance
   - Case-insensitive but exact prefix matching only

## Testing

Run tests:

```bash
flutter test
```

Analyze code:

```bash
flutter analyze
```

## Performance Optimizations

- `cached_network_image` for image caching
- `GridView.builder` for lazy loading
- Trie search optimized with early termination
- Hive for fast local storage (no SQL overhead)
- Riverpod for efficient state updates

## Future Enhancements

- Add category filtering
- Implement product search in description
- Add shopping cart functionality
- User authentication and cloud sync
- Offline mode with cached products
- Unit and widget tests
- Fuzzy search with typo tolerance
- Product rating and reviews

## License

This project is created as part of a technical assignment.

## Author

Sourav Das
