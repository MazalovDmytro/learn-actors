//
//  SendableExamples.swift
//  ActorsApp
//
//  Created by Dmytro Mazalov on 21.09.2025.
//

import Foundation

// MARK: - Basic Sendable models

public struct LogEvent: Sendable, Hashable {
    public let message: String
    public let timestamp: Date
    public init(_ message: String, timestamp: Date = Date()) {
        self.message = message
        self.timestamp = timestamp
    }
}

public protocol DataService: Sendable {
    func fetch() async throws -> String
}

public struct EchoService: DataService {
    public init() {}
    public func fetch() async throws -> String { "echo" }
}

// MARK: - @unchecked Sendable example (class)

public final class LockedCounter: @unchecked Sendable {
    private var _value: Int = 0
    private let lock = NSLock()
    
    public init() {}
    
    public func increment() {
        lock.lock()
        _value += 1
        lock.unlock()
    }
    
    public func value() -> Int {
        lock.lock(); defer { lock.unlock() }
        return _value
    }
}

// MARK: - Using @Sendable closures

public actor ClosureRunnerActor {
    public func run(_ work: @Sendable () async -> Void) async {
        await work()
    }
    
    public func makeCounterTask(initial: Int) -> @Sendable () async -> Int {
        actor Counter {
            var value: Int
            init(_ value: Int) { self.value = value }
            func next() -> Int {
                value += 1
                return value
            }
        }
        let counter = Counter(initial)
        return {
            await counter.next()
        }
    }
}

// MARK: - Combining Sendable with generic actors

public actor TypedCache<Key: Hashable & Sendable, Value: Sendable> {
    private var storage: [Key: Value] = [:]
    public init() {}
    public func set(_ key: Key, _ value: Value) { storage[key] = value }
    public func get(_ key: Key) -> Value? { storage[key] }
}
