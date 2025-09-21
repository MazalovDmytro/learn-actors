//
//  CacheActor.swift
//  ActorsApp
//
//  Created by Dmytro Mazalov on 21.09.2025.
//

import Foundation

public actor CacheActor<Key: Hashable & Sendable, Value: Sendable> {
    private var storage: [Key: Value] = [:]
    
    public init() {}
    
    public func set(_ key: Key, _ value: Value) {
        storage[key] = value
    }
    public func get(_ key: Key) -> Value? { storage[key] }
    public func remove(_ key: Key) { storage.removeValue(forKey: key) }
    public func removeAll() { storage.removeAll() }
}
