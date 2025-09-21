//
//  CounterActor.swift
//  ActorsApp
//
//  Created by Dmytro Mazalov on 21.09.2025.
//

import Foundation

public actor CounterActor {
    private var value: Int = 0
    
    public init() {}
    
    public func increment() { value += 1 }
    public func add(_ n: Int) { value += n }
    public func get() -> Int { value }
    
    public nonisolated var info: String { "CounterActor v1" }
}
