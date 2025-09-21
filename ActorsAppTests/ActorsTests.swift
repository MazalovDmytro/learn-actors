//
//  ActorsTests.swift
//  ActorsApp
//
//  Created by Dmytro Mazalov on 21.09.2025.
//

import XCTest
@testable import ActorsApp

final class ActorsPlaygroundTests: XCTestCase {
    func testCounterActorIsAtomic() async throws {
        let counter = CounterActor()
        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<1_000 {
                group.addTask { await counter.increment() }
            }
            await group.waitForAll()
        }
        let value = await counter.get()
        XCTAssertEqual(value, 1_000)
    }
    
    func testWalletTransferPreservesSum() async throws {
        let walletA = WalletActor(balance: 50)
        let walletB = WalletActor(balance: 10)
        try await walletA.transfer(5, to: walletB)
        let total = await walletA.getBalance() + walletB.getBalance()
        XCTAssertEqual(total, 60)
    }
    
    func testLoggerOrdering() async throws {
        let logger = LoggerActor()
        await logger.clear()
        await withTaskGroup(of: Void.self) { group in
            for i in 1...10 {
                group.addTask { await logger.log("l_\(i)") }
            }
            await group.waitForAll()
        }
        let lines = await logger.dump()
        XCTAssertEqual(lines.count, 10)
    }
}
