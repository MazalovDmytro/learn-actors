//
//  GlobalNetworkActor.swift
//  ActorsApp
//
//  Created by Dmytro Mazalov on 21.09.2025.
//

import Foundation

@globalActor
public struct NetworkActor {
    public actor ActorType {}
    public static let shared = ActorType()
}

@NetworkActor
public final class NetworkService {
    public init() {}
    
    public func fetch() async throws -> String {
        try await Task.sleep(nanoseconds: 150_000_000)
        return "OK:\(Int.random(in: 100...999))"
    }
}
