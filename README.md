# ActorsApp

A SwiftUI demo project that demonstrates **Swift concurrency actors** and related concepts:

- [Actors](https://developer.apple.com/documentation/swift/actor) isolation and message-serial execution
- [`nonisolated`](https://developer.apple.com/documentation/swift/nonisolated) members
- Actor-to-actor calls and invariants (wallet transfer)
- [`@globalActor`](https://developer.apple.com/documentation/swift/globalactor) for subsystem isolation (Networking)
- [`@MainActor`](https://developer.apple.com/documentation/swift/mainactor) view-model coordinating multiple actors
- Reentrancy illustration ([reentrancy in Swift Concurrency](https://developer.apple.com/documentation/swift/concurrency))
- [`Sendable`](https://developer.apple.com/documentation/swift/sendable) value and reference types
- [`@Sendable`](https://developer.apple.com/documentation/swift/sendable) closures
- Async XCTest tests

---

## Structure

- `CounterActor` — safe shared counter with `nonisolated` example
- `WalletActor` — transfer between actors, error handling
- `LoggerActor` — serialized logging
- `NetworkActor` — custom `@globalActor` with `NetworkService`
- `CacheActor` — generic actor-based cache
- `ReentrancyDemoActor` — shows interleaving due to `await`
- `SendableExamples.swift`:
  - `LogEvent: Sendable` — immutable value type
  - `DataService: Sendable` + `EchoService` implementation
  - `LockedCounter: @unchecked Sendable` — manually synchronized class
  - `ClosureRunnerActor` — runs `@Sendable` closures
  - `TypedCache<Key: Hashable & Sendable, Value: Sendable>` — generic actor
- `MainActorViewModel` + `ContentView` — SwiftUI integration

---

## Run

Open the package in **Xcode** and run the iOS target.  
The UI provides buttons to trigger different actor scenarios:
- Concurrent counter increments
- Wallet transfer between two actors
- Burst logging with guaranteed serialization
- Network request on a custom `@globalActor`
- Reentrancy demonstration with interleaved events

---

## Sendable

Examples included in `SendableExamples.swift`:

- **`LogEvent: Sendable`**  
  Safe value type for cross-task communication.

- **`DataService: Sendable` + `EchoService`**  
  Protocol explicitly constrained to `Sendable` for implementations.

- **`LockedCounter: @unchecked Sendable`**  
  Reference type with manual synchronization using `NSLock`.  
  Marked `@unchecked` because the compiler cannot prove safety for classes.

- **`ClosureRunnerActor`**  
  Accepts `@Sendable` async closures and returns a `@Sendable` work item.

- **`TypedCache<Key: Hashable & Sendable, Value: Sendable>`**  
  Demonstrates combining actors with `Sendable` generic constraints.

---

## Tests

`ActorsAppTests` and `SendableExamplesTests` cover:

- Atomic increments under concurrency (`CounterActor`)
- Preservation of total balance in wallet transfers
- Logger actor serialization guarantees
- Thread-safety of `LockedCounter`
- Correct behavior of `ClosureRunnerActor` and `TypedCache`

Run tests in Xcode via **Product → Test**.

---

## Author

Created by [Dmytro Mazalov](https://github.com/MazalovDmytro)
