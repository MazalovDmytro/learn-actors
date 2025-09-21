import Foundation
import SwiftUI
import Combine

@MainActor
final class MainActorViewModel: ObservableObject {
    private let counter = CounterActor()
    private let logger = LoggerActor()
    private let walletA = WalletActor(balance: 100)
    private let walletB = WalletActor(balance: 20)
    private let reentrancy = ReentrancyDemoActor()
    
    @Published var counterValue: Int = 0
    @Published var balanceA: Int = 0
    @Published var balanceB: Int = 0
    @Published var lastData: String? = nil
    @Published var events: [String] = []
    
    init() {
        Task { await refreshBalances() }
        Task { counterValue = await counter.get() }
    }
    
    func incrementCounter() {
        Task {
            await counter.increment()
            counterValue = await counter.get()
        }
    }
    
    func addTen() {
        Task {
            await counter.add(10)
            counterValue = await counter.get()
        }
    }
    
    func raceIncrements() {
        Task {
            await withTaskGroup(of: Void.self) { group in
                for _ in 0..<1000 {
                    group.addTask { await self.counter.increment() }
                }
                await group.waitForAll()
            }
            counterValue = await counter.get()
        }
    }
    
    func transfer() {
        Task {
            do {
                try await walletA.transfer(5, to: walletB)
                await refreshBalances()
                await logger.log("Transferred 5 A→B")
            } catch {
                await logger.log("Transfer failed: \(error)")
            }
        }
    }
    
    private func refreshBalances() async {
        balanceA = await walletA.getBalance()
        balanceB = await walletB.getBalance()
    }
    
    func logBurst() {
        Task {
            await logger.clear()
            await withTaskGroup(of: Void.self) { group in
                for i in 1...5 {
                    group.addTask { await self.logger.log("line_\(i)") }
                }
                await group.waitForAll()
            }
            let lines = await logger.dump()
            self.events = lines
        }
    }
    
    func fetchData() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let text = try await self.fetchTextFromNetwork()
                self.lastData = text
            } catch {
                self.lastData = "Error: \(error)"
            }
        }
    }
    
    @NetworkActor
    private func fetchTextFromNetwork() async throws -> String {
        let service = NetworkService()
        return try await service.fetch()
    }
    
    func runReentrancyDemo() {
        events.removeAll()
        Task {
            await reentrancy.runMany(3) { [weak self] s in
                Task { @MainActor in
                    self?.events.append(s)
                }
            }
        }
    }
}
