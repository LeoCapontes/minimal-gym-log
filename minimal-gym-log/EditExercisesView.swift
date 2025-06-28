//
//  EditExercisesView.swift
//  minimal-gym-log
//
//  Created by Leo Capontes on 27/06/2025.
//

import SwiftUI
import SwiftData

struct EditExercisesView: View {
    @Environment(\.modelContext) var modelContext
    @Query var exercises: [Exercise]
    
    var body: some View {
        NavigationStack{
            List {
                ForEach(exercises) { exercise in
                    Text(exercise.name)
                }
                .onDelete(perform: deleteExercise)
            }
            .navigationTitle(Text("Exercises"))
        }
    }
    
    func addExercise(name: String, bodyPart: Exercise.BodyPart) {
        modelContext.insert(Exercise(name: name, bodyPart: bodyPart))
        print("Added exercise")
        do{
            try modelContext.save()
        } catch {
            print("couldn't save")
        }
    }
    
    func deleteExercise(_ indexSet: IndexSet) {
        for index in indexSet {
            let exercise = exercises[index]
            modelContext.delete(exercise)
        }
    }
}
