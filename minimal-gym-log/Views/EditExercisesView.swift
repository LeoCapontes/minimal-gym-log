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
    @State private var showingAddExerciseView = false

    var body: some View {
        NavigationStack{
            List {
                ForEach(Exercise.BodyPart.allCases, id :\.self){ bodyPart in
                    Section(bodyPart.rawValue) {
                        ForEach(exerciseByPart(part: bodyPart), id: \.self) { exercise in
                            if (exercise.bodyPart == bodyPart){
                                Text(exercise.name)
                            }
                        }
                        .onDelete(perform: deleteExercise)
                    }
                }
            }
            .navigationTitle(Text("Exercises"))
            .toolbar {
                Button("Add Exercise", action: {showingAddExerciseView.toggle()})
            }
            .sheet(isPresented: $showingAddExerciseView) {
                NewExerciseView(addExercise: addExercise)
            }
        }
    }
    
    func exerciseByPart(part: Exercise.BodyPart) -> [Exercise] {
        let byPart = exercises.filter { $0.bodyPart == part}
        return byPart
    }
    
    func addExercise(name: String, bodyPart: Exercise.BodyPart, isBodyweight: Bool) {
        modelContext.insert(Exercise(name: name, bodyPart: bodyPart, isBodyWeight: isBodyweight))
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

struct NewExerciseView: View {
    @Environment(\.dismiss) var dismiss
    var addExercise: (String, Exercise.BodyPart, Bool) -> Void
    @State var name: String = ""
    @State var bodyPart: Exercise.BodyPart = .other
    @State var isBodyWeight: Bool = false
    
    var body: some View {
        Form {
            Section("Name"){
                TextField("Enter exercise name", text: $name)
            }
            Section("Body part") {
                Picker("Body part", selection: $bodyPart){
                    ForEach (Exercise.BodyPart.allCases, id: \.self) { bodyPart in
                        Text(bodyPart.rawValue)
                            .tag(bodyPart)
                    }
                }
            }
            Section("Options"){
                Toggle("Is this a bodyweight exercise?", isOn: $isBodyWeight)
            }
        }
        Button("Add Exercise", action: {
            addExercise(name, bodyPart, isBodyWeight)
            dismiss()
        })
    }
}
