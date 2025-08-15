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
    @AppStorage("MassUnitPreference") var unitPreference: MassUnits = .kilogram
    @Query(sort: \SetBlock.date, order: .reverse) var lastSetBlocks: [SetBlock]
    
    var setBlocksOfSelectedExercise: [SetBlock] {
        Array(lastSetBlocks.filter {$0.exercise == exercise})
    }
    
    var body: some View {
        Form {
            if (!setBlocksOfSelectedExercise.isEmpty){
                AllSetsChart(exercise: exercise, setblocks: setBlocksOfSelectedExercise)
                Section(header: Text("History")) {
                    List{
                        ForEach(setBlocksOfSelectedExercise, id: \.self){ setblock in
                            VStack(alignment: .leading){
                                Text(
                                    setblock.date.formatted(date: .complete, time: .omitted)
                                ).font(.headline)
                                Text(setblock.asString(unitPreference: unitPreference))
                                    .font(.subheadline)
                            }
                        }
                    }
                }
            } else {
                Text("No recorded sets for this exercise")
            }
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
