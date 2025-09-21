//
//  WalletActor.swift
//  ActorsApp
//
//  Created by Dmytro Mazalov on 21.09.2025.
//

import Foundation

public actor WalletActor {
    private var balance: Int
    
    public init(balance: Int) {
        self.balance = balance
    }
    
    public func getBalance() -> Int { balance }
    
    private func deposit(_ amount: Int) { balance += amount }
    private func withdraw(_ amount: Int) throws {
        guard balance >= amount else { throw WalletError.insufficientFunds }
        balance -= amount
    }
    
    public func transfer(_ amount: Int, to other: WalletActor) async throws {
        try withdraw(amount)
        await other.deposit(amount)
    }
}

public enum WalletError: Error {
    case insufficientFunds
}
