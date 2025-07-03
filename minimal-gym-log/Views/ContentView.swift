//
//  ContentView.swift
//  minimal-gym-log
//
//  Created by Leo Capontes on 19/04/2025.
//

import SwiftUI
import SwiftData
import Foundation

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var setblocks: [SetBlock]
    @Query var exercises: [Exercise]
    
    var body: some View {
        TabView{
            WorkoutsView(addSetBlock: addSetBlock)
                .tabItem{
                    Label("Workouts", systemImage: "figure.strengthtraining.traditional")
                }
            EditExercisesView()
                .tabItem {
                    Label("Exercises", systemImage: "dumbbell")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
    
    func addExerciseSamples() {
        modelContext.insert(Exercise(name: "Dumbbell curl", bodyPart: .bicep))
        modelContext.insert(Exercise(name: "Dumbbell lateral raise", bodyPart: .shoulder))
        modelContext.insert(Exercise(name: "Floor chest press", bodyPart: .chest))
    }
    
    func addSetSamples() {
        modelContext.insert(
            SetBlock(
                exercise: Exercise(name: "Dumbbell curl", bodyPart: .bicep),
                sets: [Set(reps: 8, weight: 10), Set(reps: 8, weight: 10), Set(reps: 8, weight: 10)],
                date: Date()
            )
        )
        modelContext.insert(
            SetBlock(
                exercise: Exercise(name: "Lateral Raise", bodyPart: .shoulder),
                sets: [Set(reps: 8, weight: 10), Set(reps: 8, weight: 10), Set(reps: 8, weight: 10)],
                date: Date()
            )
        )
        modelContext.insert(
            SetBlock(
                exercise: Exercise(name: "Dumbbell Row", bodyPart: .chest),
                sets: [Set(reps: 8, weight: 10), Set(reps: 8, weight: 10), Set(reps: 8, weight: 10)],
                date: Date()
            )
        )
    }
    
    func addSetBlock() {
        modelContext.insert(
            SetBlock(
                exercise: exercises.first ?? Exercise(name: "Dumbbell curl", bodyPart: .bicep),
                sets: [Set(reps: 1, weight: 1)],
                date: Date()
            )
        )
        print("added set block")
        do{
            try modelContext.save()
        } catch {
            print("couldn't save")
        }
    }
}

#Preview {
    ContentView()
}
