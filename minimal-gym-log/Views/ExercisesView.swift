//
//  EditExercisesView.swift
//  minimal-gym-log
//
//  Created by Leo Capontes on 27/06/2025.
//

import SwiftUI
import SwiftData

struct ExercisesView: View {
    @Environment(\.modelContext) var modelContext
    @Query var exercises: [Exercise]
    @State private var showingAddExerciseView = false
    
    var groupedByBodyPart: [Exercise.BodyPart: [Exercise]] {
        Dictionary(grouping: exercises, by: { $0.bodyPart })
    }
    
    var exerciseHeaders: [Exercise.BodyPart]{
        groupedByBodyPart.map({$0.key})
    }

    var body: some View {
        NavigationStack{
            List {
                ForEach(exerciseHeaders, id: \.self) { exerciseGroup in
                    Section(exerciseGroup.rawValue){
                        ForEach(groupedByBodyPart[exerciseGroup]!, id: \.self) { exercise in
                            NavigationLink(value: exercise) {
                                Text(exercise.name)
                            }
                            .swipeActions(allowsFullSwipe: false){
                                Button(role: .destructive) {
                                    deleteEntry(exercise)
                                } label : {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                                
                                NavigationLink {
                                    EditExerciseView(exercise: exercise)
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                            }
                        }
                    }
                }
            }
            .navigationDestination(for: Exercise.self) { exercise in
                ExerciseProgressScreen.init(exercise: exercise)
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
    
    func addExercise(name: String, bodyPart: Exercise.BodyPart, isBodyweight: Bool, effectiveLoad: Double) {
        modelContext.insert(Exercise(name: name, bodyPart: bodyPart, isBodyWeight: isBodyweight, effectiveLoad: effectiveLoad))
        print("Added exercise")
        do{
            try modelContext.save()
        } catch {
            print("couldn't save")
        }
    }
    
    func deleteEntry(_ entry: Exercise) {
        modelContext.delete(entry)
    }
    
    func deleteExercise(_ indexSet: IndexSet, for bodyPart: Exercise.BodyPart) {
        guard let exercisesForBodyPart = groupedByBodyPart[bodyPart] else { return }
        for index in indexSet {
            let exerciseSet = exercisesForBodyPart[index]
            modelContext.delete(exerciseSet)
        }
    }
}

struct EditExerciseView: View {
    @Bindable var exercise: Exercise
    
    var body: some View {
        Form{
            Section ("General") {
                LabeledContent{
                    TextField(
                        "Name",
                        text : $exercise.name
                    )
                } label: {
                    Text("Name")
                }
            }
            if(exercise.bodyWeightExercise) {
                Section("Body weight options"){
                    LabeledContent{
                        TextField(
                            "Effective Load",
                            value: $exercise.effectiveLoad,
                            format: .number
                        )
                    } label: {
                        Text("Effective Load")
                    }
                }
            }
        }
    }
}

struct NewExerciseView: View {
    @Environment(\.dismiss) var dismiss
    var addExercise: (String, Exercise.BodyPart, Bool, Double) -> Void
    @State var name: String = ""
    @State var bodyPart: Exercise.BodyPart = .other
    @State var isBodyWeight: Bool = false
    @State var effectiveLoad: Double = 1
    
    let effectiveLoadTip = EffectiveLoadTip()
    
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
            if(isBodyWeight) {
                Section("Body weight options"){
                    LabeledContent{
                        TextField(
                            "Effective Load",
                            value: $effectiveLoad,
                            format: .number
                        )
                    } label: {
                        Text("Effective Load")
                    }
                }
            }
        }
        Button("Add Exercise", action: {
            addExercise(name, bodyPart, isBodyWeight, effectiveLoad)
            dismiss()
        })
    }
}
