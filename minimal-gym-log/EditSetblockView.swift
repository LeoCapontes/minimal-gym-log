//
//  EditSetblockView.swift
//  minimal-gym-log
//
//  Created by Leo Capontes on 23/06/2025.
//

import SwiftUI
import SwiftData

struct EditSetblockView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var setblock: SetBlock
    var exercises: [Exercise]
    @State var selectedExercise: Exercise?
    
    init(setblock: SetBlock, exercises: [Exercise]) {
        self.setblock = setblock
        self.exercises = exercises
    }
    
    var body: some View {
        Form(){
            DatePicker("Date", selection: $setblock.date)
            Picker(selection: $setblock.exercise, label: Text("Exercise")){
                ForEach(exercises, id: \.self){ exercise in
                    Text(exercise.name)
                        .tag(Optional(exercise))
                }
            }
            Section("Sets") {
                Button("Add set", action: addSet)
                List{
                    ForEach($setblock.sets) { set in
                        HStack{
                            TextField(
                                "Enter Repetitions",
                                value: set.reps,
                                format: .number,
                                prompt: Text("Reps")
                            )
                            .keyboardType(.numberPad)
                            TextField(
                                "Enter Weight (kg)",
                                value: set.weight,
                                format: .number,
                                prompt: Text("Weight(kg)")
                            )
                            .keyboardType(.numberPad)
                        }
                    }
                }
            }
        }
        .navigationTitle("Edit exercise")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func addSet(){
        setblock.sets.append(Set(reps: 0, weight: 0))
    }
}

#Preview {
    do{
        var container: ModelContainer
        
        let config = ModelConfiguration(for: SetBlock.self, Exercise.self, isStoredInMemoryOnly: true)
        container = try ModelContainer(for: SetBlock.self, Exercise.self, configurations: config)
        
        let mock = SetBlock(
            exercise: Exercise(name: "Dumbbell curl"),
            sets: [Set(reps: 8, weight: 10), Set(reps: 8, weight: 10), Set(reps: 8, weight: 10)],
            date: Date()
        )
        
        let mockExercises = [
            Exercise(name: "Dumbbell curl"),
            Exercise(name: "Dumbbell lateral raise"),
            Exercise(name: "Floor chest press")
        ]
        
        return EditSetblockView(setblock: mock, exercises: mockExercises).modelContainer(container)
    } catch {
        fatalError("Preview model container failed")
    }
}
