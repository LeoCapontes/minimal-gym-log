//
//  ExerciseProgressScreen.swift
//  minimal-gym-log
//
//  Created by Leo Capontes on 24/07/2025.
//

import SwiftUI
import SwiftData

struct ExerciseProgressScreen: View {
    var exercise: Exercise
    @Query(sort: [SortDescriptor(\SetBlock.date)]) var lastSetBlocks: [SetBlock]
    
    var setBlocksOfSelectedExercise: [SetBlock] {
        Array(lastSetBlocks.filter {$0.exercise == exercise})
    }
    
    var body: some View {
        Form {
            AllSetsChart(exercise: exercise, setblocks: setBlocksOfSelectedExercise)
        }
        .navigationTitle("\(exercise.name) Progress")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let exercise = Exercise(name: "Dumbbell curl", bodyPart: .bicep)
    let mock = generateMockSetblocks(quantity: 30, exercise: exercise)
    
    ExerciseProgressScreen(exercise: mock[0].exercise)
}
