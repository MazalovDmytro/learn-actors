//
//  ActorsApp.swift
//  ActorsApp
//
//  Created by Dmytro Mazalov on 21.09.2025.
//

import SwiftUI

@main
struct ActorsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(vm: MainActorViewModel())
        }
    }
}
