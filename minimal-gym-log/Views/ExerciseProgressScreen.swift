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
    
    @AppStorage("MassUnitPreference")
    var unitPreference: MassUnits = .kilogram
    
    @AppStorage("StartTrackingDate")
    private var startTrackingDate = Date()
    
    @Query var lastSetBlocks: [SetBlock]
    
    @Query(sort: \UserBodyWeight.date) var bodyWeights: [UserBodyWeight]
    
    var setBlocksOfSelectedExercise: [SetBlock] {
        Array(lastSetBlocks.filter {$0.exercise == exercise})
    }
    
    init(exercise: Exercise) {
        self.exercise = exercise
        
        let startDateSetblockPredicate = #Predicate<SetBlock> {
            $0.date > startTrackingDate
        }
        
        let startDateBodyweightPredicate = #Predicate<UserBodyWeight> {
            $0.date > startTrackingDate
        }
        
        _lastSetBlocks = Query(filter: startDateSetblockPredicate, sort: \SetBlock.date, order: .reverse)
        _bodyWeights = Query(filter: startDateBodyweightPredicate, sort: \UserBodyWeight.date)
    }
    
    var body: some View {
        Form {
            if(!setBlocksOfSelectedExercise.isEmpty){
                if (!(setBlocksOfSelectedExercise.count < 2)){
                    AllSetsChart(
                        exercise: exercise,
                        setblocks: setBlocksOfSelectedExercise,
                        bodyWeights: bodyWeights
                    )
                    .frame(height: 350)
                }
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
                Text("No sets recorded for this exercise")
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
