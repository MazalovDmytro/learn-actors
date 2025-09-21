//
//  ReentrancyDemoActor.swift
//  ActorsApp
//
//  Created by Dmytro Mazalov on 21.09.2025.
//

import Foundation

public actor ReentrancyDemoActor {
    public init() {}
    
    public func step(_ id: Int, events: inout [String]) async {
        events.append("start_\(id)")
        try? await Task.sleep(nanoseconds: 50_000_000)
        events.append("end_\(id)")
    }
    
    public func runMany(_ count: Int, sink: @Sendable (String) -> Void) async {
        sink("run:start")
        for i in 1...count {
            sink("call:step_\(i)")
            var capture: [String] = []
            await step(i, events: &capture)
            sink("captured:\(capture.joined(separator: ","))")
        }
        sink("run:end")
    }
}
