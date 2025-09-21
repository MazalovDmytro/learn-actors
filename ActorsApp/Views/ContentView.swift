//
//  ContentView.swift
//  ActorsApp
//
//  Created by Dmytro Mazalov on 21.09.2025.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var vm: MainActorViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section("CounterActor") {
                    HStack {
                        Text("Count: \(vm.counterValue)")
                        Spacer()
                        Button("+1") { vm.incrementCounter() }
                            .buttonStyle(.bordered)
                            .allowsHitTesting(true)
                        Button("+10") { vm.addTen() }
                            .buttonStyle(.bordered)
                            .allowsHitTesting(true)
                    }
                    .allowsHitTesting(false)
                    
                    Button("Race test (1000 concurrent increments)") {
                        vm.raceIncrements()
                    }
                }
                
                Section("Wallet transfer (actor-to-actor)") {
                    Text("A: \(vm.balanceA) • B: \(vm.balanceB)")
                    Button("Transfer 5 from A → B") { vm.transfer() }
                }
                
                Section("LoggerActor (ordering & isolation)") {
                    Button("Log burst") { vm.logBurst() }
                }
                
                Section("@globalActor NetworkActor") {
                    Button("Fetch mock data") { vm.fetchData() }
                    if let text = vm.lastData {
                        Text("Response: \(text)")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Reentrancy demo") {
                    Button("Run reentrancy scenario") { vm.runReentrancyDemo() }
                    if !vm.events.isEmpty {
                        ForEach(vm.events, id: \.self) { e in
                            Text(e).font(.caption.monospaced())
                        }
                    }
                }
            }
            .navigationTitle("Actors Playground")
        }
    }
}
