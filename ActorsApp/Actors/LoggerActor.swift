//
//  LoggerActor.swift
//  ActorsApp
//
//  Created by Dmytro Mazalov on 21.09.2025.
//

import Foundation

public actor LoggerActor {
    private var lines: [String] = []
    
    public func log(_ text: String) {
        lines.append(text)
    }
    
    public func dump() -> [String] { lines }
    public func clear() { lines.removeAll() }
}
