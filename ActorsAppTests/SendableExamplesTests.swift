//
//  SendableExamplesTests.swift
//  ActorsApp
//
//  Created by Dmytro Mazalov on 21.09.2025.
//

import XCTest
@testable import ActorsApp

final class SendableExamplesTests: XCTestCase {
    func testLockedCounterIsThreadSafe() async {
        let counter = await LockedCounter()
        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<1_000 {
                group.addTask {
                    await MainActor.run {
                        counter.increment()
                    }
                }
            }
            
            await group.waitForAll()
        }
        let value = await MainActor.run { counter.value() }
        XCTAssertEqual(value, 1_000)
    }
    
    func testClosureRunnerActor() async {
        let runner = ClosureRunnerActor()
        let task = await runner.makeCounterTask(initial: 10)
        let value = await task()
        XCTAssertEqual(value, 11)
    }
    
    func testTypedCacheSendable() async {
        let cache = TypedCache<String, Int>()
        await cache.set("a", 1)
        let value = await cache.get("a")
        XCTAssertEqual(value, 1)
    }
}
