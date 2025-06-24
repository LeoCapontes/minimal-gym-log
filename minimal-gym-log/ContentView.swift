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
        NavigationStack {
            List {
                ForEach(setblocks) { setblock in
                    NavigationLink(value: setblock){
                        VStack(alignment: .leading) {
                            Text(setblock.exercise.name)
                                .font(.headline)
                            Text("\(setblock.sets[0].weight)kg x \(setblock.sets[0].reps) reps")
                                .font(.subheadline)
                        }
                    }
                }
                .onDelete(perform: deleteSets)
            }
            .navigationDestination(
                for: SetBlock.self){ setblock in
                    EditSetblockView.init(setblock: setblock, exercises: exercises)
                }
            .navigationTitle("GymLog")
            .toolbar{
                Button("Add Exercise", action: addSetBlock)
                Button("Add Setblock Samples", action: addSetSamples)
                Button("Add Exercise Samples", action: addExerciseSamples)
            }
        }
    }
    
    func deleteSets(_ indexSet: IndexSet) {
        for index in indexSet {
            let exerciseSet = setblocks[index]
            modelContext.delete(exerciseSet)
        }
    }
    
    func addExerciseSamples() {
        modelContext.insert(Exercise(name: "Dumbbell curl"))
        modelContext.insert(Exercise(name: "Lateral raise"))
        modelContext.insert(Exercise(name: "Dumbbell row (unilateral)"))
    }
    
    func addSetSamples() {
        modelContext.insert(
            SetBlock(
                exercise: Exercise(name: "Dumbbell curl"),
                sets: [Set(reps: 8, weight: 10), Set(reps: 8, weight: 10), Set(reps: 8, weight: 10)],
                date: Date()
            )
        )
        modelContext.insert(
            SetBlock(
                exercise: Exercise(name: "Lateral Raise"),
                sets: [Set(reps: 8, weight: 10), Set(reps: 8, weight: 10), Set(reps: 8, weight: 10)],
                date: Date()
            )
        )
        modelContext.insert(
            SetBlock(
                exercise: Exercise(name: "Dumbbell Row"),
                sets: [Set(reps: 8, weight: 10), Set(reps: 8, weight: 10), Set(reps: 8, weight: 10)],
                date: Date()
            )
        )
    }
    
    func addSetBlock() {
        modelContext.insert(
            SetBlock(
                exercise: exercises.first ?? Exercise(name: "Dumbbel Curl"),
                sets: [Set(reps: 1, weight: 1)],
                date: Date()
            )
        )
    }
}

#Preview {
    ContentView()
}
