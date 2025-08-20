//
//  minimal_gym_logApp.swift
//  minimal-gym-log
//
//  Created by Leo Capontes on 19/04/2025.
//

import SwiftUI
import SwiftData

@main
struct minimal_gym_logApp: App {
    var container: ModelContainer
    
    init() {
        do{
            let config = ModelConfiguration(
                for: SetBlock.self, Exercise.self, UserBodyWeight.self
            )
            
            container = try ModelContainer(
                for: SetBlock.self, Exercise.self, UserBodyWeight.self,
                configurations: config
            )
        } catch {
            fatalError("Failed to configure SwiftData container.")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
