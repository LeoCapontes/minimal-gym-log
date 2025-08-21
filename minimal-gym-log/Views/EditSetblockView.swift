//
//  EditSetblockView.swift
//  minimal-gym-log
//
//  Created by Leo Capontes on 23/06/2025.
//

import SwiftUI
import SwiftData
import Combine

struct EditSetblockView: View {
    @Environment(\.modelContext) var modelContext
    @AppStorage("MassUnitPreference") var massUnitPreference: MassUnits = .kilogram
    @Bindable var setblock: SetBlock
    var exercises: [Exercise]
    @State var selectedExercise: Exercise?
    @Query(sort: \UserBodyWeight.date) var bodyWeights: [UserBodyWeight]
    
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
            Section(
                header: Text("Sets"),
                footer: Text("Total volume: \(totalVolume())\(massUnitPreference.rawValue)")
            ) {
                List{
                    ForEach($setblock.sets) { setBlockSet in
                        HStack{
                            Text("Reps:")
                            TextField(
                                "Enter Repetitions",
                                value: setBlockSet.reps,
                                format: .number,
                                prompt: Text("Reps")
                            )
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            Spacer()
                            Text("Weight:")
                            WeightEntry(
                                set: setBlockSet,
                                massUnitPreference: massUnitPreference
                            )
                        }
                        .animation(.default.speed(2.0))
                    }
                    .onDelete(perform: deleteSets)
                }
                Button() {
                    withAnimation() {
                        addSet()
                    }
                } label: {
                    HStack(alignment: .center){
                        Spacer()
                        Label{
                            Text("Add Set")
                        } icon:
                        {
                            Image(systemName: "plus.circle").foregroundStyle(.primary).padding()
                        }
                        .padding(4)
                        Spacer()
                    }
                }
                .buttonStyle(.bordered)
                
            }
            Section("Previous Sets") {
                PreviousSetBlocksOverview(selectedExercise: $setblock.exercise)
            }
            
        }
        .navigationTitle("Edit exercise")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func addSet(){
        // new set is copy of previous set
        if (!setblock.sets.isEmpty){
            let lastSet = setblock.sets.last
            setblock.sets.append(Set(reps: lastSet!.reps!, weight: lastSet!.weightKg!))
        } else {
            setblock.sets.append(Set(reps: 0, weight: 0))
        }
    }
    
    func deleteSets(_ indexSet: IndexSet){
        for index in indexSet {
            setblock.sets.remove(at: index)
        }
    }
    
    func totalVolume() -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        if (!setblock.exercise.bodyWeightExercise){
            return formatter.string(
                from: NSNumber(value: setblock.getTotalVolume(as: massUnitPreference))
            )!
        } else {
            return formatter.string(
                from: NSNumber(value: setblock.getTotalVolume(as: massUnitPreference, using: bodyWeights))
            )!
        }
    }
}

struct WeightEntry: View {
    @State var weightInput: String = ""
    @Binding var set: Set
    @FocusState var fieldFocused: Bool
    var massUnitPreference: MassUnits
    
    var body: some View {
        let weightBinding = Binding<String>(
            get: {
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.maximumFractionDigits = 2
                return (
                    formatter.string(
                        from: NSNumber(value: $set.wrappedValue.getWeight(as: massUnitPreference))
                    )
                    ?? String($set.wrappedValue.getWeight(as: massUnitPreference))
                )
            },
            set: { newWeight in
                $set.wrappedValue.setWeight(weight: newWeight, as: massUnitPreference)
            }
        )
        HStack{
        TextField(
            "Enter Weight (\(massUnitPreference.rawValue))",
            text: $weightInput
        )
        .textFieldStyle(.roundedBorder)
        .keyboardType(.decimalPad)
        .focused($fieldFocused)
        .onReceive(Just(weightInput)) { newValue in
            let filtered = newValue.filter { "0123456789.".contains($0) }
            if filtered != newValue {
                self.weightInput = filtered
            }
        }
        .onAppear {
            self.weightInput = weightBinding.wrappedValue
        }
        Text("\(massUnitPreference.rawValue)")}
        .onChange(of: fieldFocused) {
            self.weightInput = weightBinding.wrappedValue
        }
        if(fieldFocused) {
            Button("", systemImage: "checkmark.circle.fill") {
                weightBinding.wrappedValue = weightInput
                fieldFocused = false
            }
        }
    }
}

struct PreviousSetBlocksOverview: View {
    @Binding var selectedExercise: Exercise
    @Query(sort: [SortDescriptor(\SetBlock.date)]) var lastSetBlocks: [SetBlock]
    @Query(sort: \UserBodyWeight.date) var bodyWeights: [UserBodyWeight]
    @AppStorage("MassUnitPreference") var unitPreference: MassUnits = .kilogram
    
    var setBlocksOfSelectedExercise: [SetBlock] {
        Array(lastSetBlocks.filter {$0.exercise == selectedExercise}.suffix(4))
    }
    var body: some View {
        List{
            PreviousSetsChart(setblocks: setBlocksOfSelectedExercise, bodyWeights: bodyWeights)
            ForEach(setBlocksOfSelectedExercise.reversed()) { setblock in
                HStack(alignment: .top){
                    Text(setblock.date.formatted(date: .numeric, time: .omitted))
                        .font(.system(size: 14))
                    Text(setblock.asString(unitPreference: unitPreference))
                        .font(.system(size: 12))
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(for: SetBlock.self, Exercise.self, isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: SetBlock.self, Exercise.self, configurations: config)
    let context = container.mainContext
    
    let mock = [
        SetBlock(
            exercise: Exercise(name: "Dumbbell curl", bodyPart: .bicep),
            sets: [Set(reps: 8, weight: 9), Set(reps: 8, weight: 10), Set(reps: 8, weight: 10), ],
            date: Date().advanced(by: -86400*2)
        ),
        SetBlock(
            exercise: Exercise(name: "Dumbbell curl", bodyPart: .bicep),
            sets: [Set(reps: 8, weight: 10), Set(reps: 8, weight: 10), Set(reps: 8, weight: 10)],
            date: Date().advanced(by: -86400)
        ),
        SetBlock(
            exercise: Exercise(name: "Dumbbell curl", bodyPart: .bicep),
            sets: [Set(reps: 8, weight: 11), Set(reps: 8, weight: 10), Set(reps: 8, weight: 10)],
            date: Date()
        )]
    
    for setblock in mock {
        context.insert(setblock)
    }
    let mockExercises = [
        Exercise(name: "Dumbbell curl", bodyPart: .bicep),
        Exercise(name: "Dumbbell lateral raise", bodyPart: .shoulder),
        Exercise(name: "Floor chest press", bodyPart: .chest)
    ]
    
    return EditSetblockView(setblock: mock[2], exercises: mockExercises).modelContainer(container)

}
