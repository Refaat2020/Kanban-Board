# Kanban Board

A production-ready Flutter task management application demonstrating enterprise-grade mobile architecture. This project implements offline-first design with background synchronization, Clean Architecture with clear separation of concerns, and comprehensive state management patterns suitable for scalable mobile applications.

---

## Problem Statement

Mobile task management applications must remain functional regardless of network conditions while maintaining data consistency with backend services. This application addresses the challenge of building a resilient offline-first system that:

- Executes all user operations locally without network dependency
- Maintains a persistent operation queue for failed requests
- Synchronizes changes in the background with intelligent retry logic
- Resolves conflicts between local and remote state
- Provides immediate UI feedback through optimistic updates

The implementation integrates with the Todoist API to demonstrate real-world patterns for handling REST APIs, authentication, and bidirectional synchronization in a distributed system.

---

## Architecture Overview

### Clean Architecture Implementation

The project strictly adheres to Clean Architecture principles with dependency inversion at layer boundaries. Each feature is self-contained with its own data, domain, and presentation layers.

**Critical architectural decision:** Repositories are **completely decoupled from remote data sources**. They only interact with local storage and the sync queue. The sync engine handles all network communication independently, enabling true offline-first operation.

```
lib/
├── core/
│   ├── bootstrap/              # App initialization & setup
│   ├── config/                 # Environment configuration
│   ├── constants/              # App-wide constants
│   ├── extensions/             # Dart extensions
│   ├── network/                # HTTP client configuration
│   ├── services/               # Cross-cutting services
│   │   ├── dio_client.dart           # HTTP client abstraction
│   │   ├── isar_service.dart         # Local database service
│   │   ├── preference_storage.dart   # Key-value storage
│   │   └── service_locator.dart      # Dependency injection
│   ├── sync/                   # Synchronization engine
│   │   ├── data/
│   │   │   ├── data_source/          # Sync queue persistence
│   │   │   └── models/               # Sync operation models
│   │   └── engine/
│   │       └── background_sync_engine.dart  # Sync orchestration
│   └── theme/                  # Theme management
└── features/
    ├── kanban_board/
    │   ├── data/
    │   │   ├── data_source/          # Local data sources only
    │   │   ├── models/               # DTOs with mappers
    │   │   └── repository/           # Repository implementations
    │   ├── domain/
    │   │   ├── entities/             # Business entities
    │   │   └── usecases/             # Business logic
    │   └── presentation/
    │       ├── cubit/                # State management
    │       └── views/                # UI components
    └── task_management/
        ├── data/
        │   ├── data_source/
        │   │   ├── task_local_data_source.dart    # Isar operations
        │   │   ├── tasks_data_source.dart          # API client (sync only)
        │   │   └── comment_repository.dart
        │   ├── models/
        │   │   ├── task_model.dart                 # Remote DTO
        │   │   └── task_local_model.dart           # Local entity
        │   └── repository/
        │       ├── task_repository.dart            # Abstract interface
        │       └── task_management_repository_impl.dart
        └── domain/
            ├── entities/
            └── usecases/
```

### Dependency Flow

```
Presentation → Domain → Data (Local Only)
     ↓           ↓           ↓
   Cubit    Use Cases   Repository → LocalDataSource
                ↓                  → SyncQueueDataSource
            Entities                        ↓
                                    BackgroundSyncEngine
                                            ↓
                                    RemoteDataSource
```

**Key principles:**
- **Dependency Rule**: Inner layers never depend on outer layers
- **Repository Simplification**: No remote dependency = no network errors in business logic
- **Sync Decoupling**: Sync engine is infrastructure concern, not domain concern
- **Single Responsibility**: Each layer has one reason to change
- **Testability**: Dependencies injected via constructor for easy mocking

---

## Offline-First Architecture

### Core Design

The application implements a **local-first, eventually consistent** architecture where:

1. All write operations succeed immediately against local storage (Isar database)
2. Operations are queued for background synchronization
3. The sync engine processes the queue when network is available
4. Conflicts are resolved using last-write-wins with server authority

### Synchronization Engine

Located in `core/sync/engine/background_sync_engine.dart`, the sync engine provides:

**Features:**
- **Persistent Queue**: Operations survive app restarts (stored in Isar)
- **Retry Logic**: Exponential backoff for transient failures (initial: 2s, max: 60s)
- **Network Awareness**: Pauses during offline, resumes on connectivity
- **Operation Ordering**: FIFO processing maintains causal consistency
- **Idempotency**: Duplicate operations safely retry without side effects

**Sync Flow:**
```
User Action
    ↓
Convert to LocalModel (isSynced: false)
    ↓
Save to Isar via LocalDataSource
    ↓
UI Update (immediate)
    ↓
Create SyncQueueItem with payload
    ↓
Persist to Sync Queue (Isar)
    ↓
Background Sync Engine processes queue
    ↓
Network Request to Todoist API
    ↓
Success: Mark as synced, remove from queue
Failure: Increment retryCount, calculate nextRetryAt
```

### Sync Queue Structure

Each queued operation contains:

```dart
class SyncQueueItem {
  String entityId;        // Task/comment ID for idempotency
  String entityType;      // 'task', 'comment', etc.
  String action;          // 'create', 'update', 'delete'
  String payload;         // JSON-serialized entity data
  int retryCount;         // Current retry attempt (0-based)
  DateTime nextRetryAt;   // Exponential backoff timestamp
}
```

**Retry strategy:**
- Initial retry: immediate (nextRetryAt = now)
- Subsequent retries: `delay = min(2^retryCount * 2s, 60s)`
- Max retries: 10 attempts before marking as failed
- Failed operations logged for manual review

### Data Sources

The application maintains strict separation between local storage and sync operations:

**Local Data Sources** (per feature):
- `TaskLocalDataSource`: CRUD operations on local Isar collections
- Uses local models (`TaskLocalModel`) with `isSynced` flag
- Provides reactive `Stream<List<Task>>` for real-time UI updates
- Handles optimistic updates and rollback on sync failure

**Sync Queue Data Source** (`core/sync/data/data_source/`):
- Manages `SyncQueueItem` collection in Isar
- Separate from business data - acts as operation log
- Supports queries by `entityType`, `nextRetryAt` for batch processing
- Atomic enqueue/dequeue operations

**Remote Data Sources** (accessed by sync engine only):
- `TasksDataSource`: Todoist API client for tasks
- Lives outside repository layer - repositories never call remote directly
- Used exclusively by `BackgroundSyncEngine` during queue processing
- Handles API authentication, request serialization, error mapping

This architecture ensures repositories remain simple and fast, with all network complexity isolated in the sync layer.

### Repository Pattern

Repositories coordinate between local data sources and the sync queue. All write operations follow the same pattern: **write locally, queue for sync, return immediately**.

**Actual implementation** (`task_management/data/repository/task_repository_impl.dart`):

```dart
class TaskManagementRepositoryImpl implements TaskManagementRepository {
  final TaskLocalDataSource _local;
  final SyncQueueDataSource _queue;

  Future<Task> createTask(Task task) async {
    try {
      // 1. Convert to local model and save immediately
      final localTask = TaskLocalModel.fromEntity(task, isSynced: false);
      await _local.upsertTask(localTask);
      
      // 2. Enqueue sync operation with retry metadata
      await _queue.enqueue(
        SyncQueueItem()
          ..entityId = task.id ?? task.labels?.first
          ..entityType = 'task'
          ..action = 'create'
          ..payload = jsonEncode(TaskModel.fromEntity(task).toJson())
          ..retryCount = 0
          ..nextRetryAt = DateTime.now(),
      );
      
      // 3. Return immediately - UI updates before network call
      return localTask.toEntity();
    } on FailureModel {
      rethrow;
    } catch (e) {
      throw FailureModel(state: 0, message: e.toString());
    }
  }
}
```

**Key aspects:**
- No remote data source in repository - sync is decoupled
- `isSynced: false` flag tracks unsynced local changes
- Sync queue stores serialized payload for later processing
- Errors caught and wrapped in domain-level `FailureModel`

### Conflict Resolution

**Strategy**: Last-Write-Wins with server timestamp authority

- Server timestamps are source of truth
- Local changes with older timestamps are discarded during sync
- User notified of conflicts via snackbar
- Suitable for single-user scenarios; extensible to CRDT for multi-user

**Trade-offs:**
- **Chosen**: Simple, predictable conflict resolution
- **Alternative**: CRDTs for commutative operations (higher complexity)
- **Rationale**: Single-user context makes LWW acceptable; CRDT overhead unnecessary

### Dual Model Architecture

The application maintains separate models for local and remote data:

**Remote Models** (`TaskModel`):
- Maps 1:1 with Todoist API schema
- Used only for serialization/deserialization
- Contains `toJson()` and `fromJson()` methods
- Lives in sync queue payload as JSON string

**Local Models** (`TaskLocalModel`):
- Optimized for Isar storage and querying
- Includes sync metadata: `isSynced`, `lastModified`
- Annotated with Isar decorators (`@collection`, `@Index()`)
- Contains `fromEntity()` and `toEntity()` converters

**Benefits:**
- Local schema evolution independent of API changes
- Efficient local queries without API constraints
- Clear separation between persistence and wire format
- Easier testing with distinct concerns

**Example:**
```dart
// Remote model for API
class TaskModel {
  final String? id;
  final String content;
  final String? projectId;
  
  Map<String, dynamic> toJson() => {...};
}

// Local model for Isar
@collection
class TaskLocalModel {
  Id id = Isar.autoIncrement;
  @Index()
  String? externalId;  // Maps to API id
  late String content;
  bool isSynced = false;
  DateTime? lastModified;
  
  Task toEntity() => Task(...);
}
```

---

## State Management

### Bloc/Cubit Architecture

State management follows the BLoC pattern with Cubit for simpler state:

**Features:**
- **Predictable State**: Pure functions transform state
- **Testability**: Easy to mock and assert state transitions
- **Reactive UI**: Widgets rebuild only on relevant state changes
- **Time-Travel Debugging**: State history for debugging

**Example** (`kanban_board/presentation/cubit/`):
```dart
class TaskCubit extends Cubit<TaskState> {
  final CreateTaskUseCase createTask;
  
  Future<void> create(Task task) async {
    emit(TaskLoading());
    final result = await createTask(task);
    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (task) => emit(TaskLoaded(task)),
    );
  }
}
```

---

## Design Patterns

| Pattern | Location | Purpose |
|---------|----------|---------|
| **Repository** | `features/*/data/repository/` | Abstracts data source complexity |
| **Use Case** | `features/*/domain/usecases/` | Encapsulates business logic |
| **Service Locator** | `core/services/service_locator.dart` | Dependency injection container |
| **Observer** | Bloc/Cubit | State change notification |
| **Command Queue** | `core/sync/` | Asynchronous operation execution |
| **Strategy** | `core/network/` | Configurable retry strategies |
| **Factory** | `data/models/` | DTO to entity mapping |
| **Singleton** | Services | Shared instance lifecycle |

---

## Testing Strategy

### Test Coverage by Layer

**Unit Tests** (`test/unit/`):
- **Domain Layer**: Use case logic, entity validation, business rules
- **Data Layer**: Repository implementations, DTO mappers, data source interactions
- **Sync Engine**: Queue operations, retry logic, conflict resolution
- **Services**: DI container, HTTP client, storage abstractions

**Widget Tests** (`test/widget/`):
- **Critical Flows**: Task CRUD, comment threads, board navigation
- **State Transitions**: Loading, success, error states
- **User Interactions**: Drag-and-drop, form validation, button actions

**Integration Tests** (`integration_test/`):
- End-to-end user journeys
- Offline → online transitions
- Multi-feature workflows

### Testing Tools

```yaml
dependencies:
  mockito: ^5.4.0           # Mock generation
  bloc_test: ^9.1.0         # Cubit/Bloc testing
  flutter_test: sdk
```

**Run tests:**
```bash
# All tests
flutter test

# Unit tests only
flutter test test/unit/

# Coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

---

## CI/CD Pipeline

### GitHub Actions Workflow

**Pipeline stages:**

1. **Lint**: `flutter analyze` for static analysis
2. **Format**: `dart format --set-exit-if-changed`
3. **Test**: `flutter test` with coverage reporting
4. **Build**: Platform-specific artifact generation
5. **Deploy**: APK/IPA to distribution (on release tags)

**Configuration**: `.github/workflows/ci.yml`

**Quality Gates:**
- Minimum 80% test coverage
- Zero analyzer warnings
- All tests passing
- Formatted code

---

## Technology Stack

| Component | Technology | Rationale |
|-----------|-----------|-----------|
| **Framework** | Flutter 3.x | Cross-platform with native performance, hot reload |
| **Language** | Dart 3.x | Null safety, strong typing, async/await |
| **State Management** | flutter_bloc 8.x | Predictable state, testability, separation of concerns |
| **Local Database** | Isar 3.x | Fast NoSQL, reactive queries, minimal boilerplate |
| **Key-Value Store** | shared_preferences | Simple persistence for app settings |
| **HTTP Client** | dio 5.x | Interceptors, retry logic, request cancellation |
| **Dependency Injection** | get_it 7.x | Service locator, lazy/singleton instances |
| **Backend API** | Todoist REST API | Real-world task management API |
| **Testing** | mockito, bloc_test | Mocking, state verification |

---

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.0.0
- Dart SDK ≥ 3.0.0
- Android SDK (for Android) or Xcode (for iOS)
- Todoist API token (free tier)

### Installation

```bash
# Clone repository
git clone https://github.com/Refaat2020/Kanban-Board.git
cd Kanban-Board

# Install dependencies
flutter pub get

# Generate code (if needed)
flutter pub run build_runner build

# Run application
flutter run

# Run with specific flavor
flutter run --flavor dev -t lib/main_dev.dart
```

### Configuration

Create `.env` file in project root:

```env
TODOIST_API_TOKEN=your_api_token_here
API_BASE_URL=https://api.todoist.com/rest/v2
```

---

## Project Structure Highlights

### Core Services

- **`service_locator.dart`**: GetIt-based DI container for dependency management
- **`dio_client.dart`**: Configured HTTP client with interceptors and error handling
- **`isar_service.dart`**: Local database service with schema management
- **`preference_storage.dart`**: Wrapper around SharedPreferences for app settings

### Sync Module

- **`background_sync_engine.dart`**: Orchestrates offline operation synchronization
- **`sync/data/data_source/`**: Persistent queue storage using Isar
- **`sync/data/models/`**: Sync operation models (create, update, delete)

### Feature Modules

Each feature (`kanban_board`, `task_management`) follows:

```
feature/
├── data/
│   ├── data_source/      # API clients, local DAO
│   ├── models/           # DTOs with toEntity/fromEntity
│   └── repository/       # Repository implementations
├── domain/
│   ├── entities/         # Business objects (pure Dart)
│   └── usecases/         # Single-responsibility business logic
└── presentation/
    ├── cubit/            # State holders
    └── views/            # UI screens and widgets
```

---

## Demo

### Screenshots

| Light Theme | Dark Theme |
|-------------|------------|
| ![Light Mode](https://i.ibb.co/6Nz2yCw/kanban-board-light.png) | ![Dark Mode](https://i.ibb.co/7X383jd/kanban-board.png) |

### Video Demo

[**Watch full demonstration →**](https://www.veed.io/view/16ca8058-7948-4bb4-805c-1e5f7574ef02?panel=share)

**Key features shown:**
- Offline task creation with immediate UI feedback
- Background synchronization with visual indicators
- Drag-and-drop task management
- Comment threading with real-time updates
- Theme switching with system preference detection

---

## Future Enhancements

### Scalability
- **Migration to Hive/SQLite**: For complex queries and larger datasets
- **GraphQL Integration**: More efficient data fetching with subscriptions
- **WebSocket Support**: Real-time collaboration features

### Reliability
- **CRDT Conflict Resolution**: For multi-device scenarios
- **Incremental Sync**: Timestamp-based delta synchronization
- **Optimistic Locking**: Version-based concurrency control

### Observability
- **Analytics Integration**: Firebase Analytics or Mixpanel
- **Crash Reporting**: Sentry or Firebase Crashlytics
- **Performance Monitoring**: Custom metrics and APM

### Testing
- **E2E Tests**: Patrol or integration_test framework
- **Snapshot Testing**: Golden tests for UI regression
- **Load Testing**: Simulate large task datasets

---

## Performance Considerations

- **Database Indexing**: Isar indexes on frequently queried fields (status, dueDate)
- **Lazy Loading**: Pagination for large task lists
- **Image Caching**: Cached network images with LRU eviction
- **Memory Management**: Dispose of streams and controllers properly
- **Build Optimization**: `const` constructors where applicable

---

## Security

- **API Token Storage**: Secure storage using flutter_secure_storage
- **HTTPS Only**: All network requests over TLS
- **Input Validation**: Sanitize user input before persistence
- **No Sensitive Logs**: Redact tokens from logs in production

---

## Contributing

Contributions are welcome. Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/improvement`)
3. Follow existing code style and architecture patterns
4. Add tests for new functionality
5. Submit a pull request with clear description

---

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

---

## Acknowledgments

Built as a reference implementation of production-grade Flutter architecture patterns. Demonstrates practical application of Clean Architecture, offline-first design, and comprehensive state management suitable for enterprise mobile applications.