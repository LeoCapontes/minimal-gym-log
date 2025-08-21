//
//  MeasurementHistory.swift
//  minimal-gym-log
//
//  Created by Leo Capontes on 07/08/2025.
//
import SwiftUI
import SwiftData

struct BodyWeightHistoryView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \UserBodyWeight.date, order: .reverse) var bodyWeightEntries: [UserBodyWeight]
    @AppStorage("MassUnitPreference") var unitPreference: MassUnits = .kilogram
    
    var weightFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter
    }
    
    var body: some View{
        Form{
            Section("Body Weight Entry") {
                MeasurementEntryView(unit: unitPreference.rawValue, addEntry: addEntry(value:date:))
            }
            Section("Body Weight History") {
                List{
                    ForEach(bodyWeightEntries, id: \.self) { entry in
                        HStack(){
                            Text(entry.date.formatted(date: .numeric, time: .omitted))
                                .font(.subheadline)
                            switch unitPreference {
                            case .kilogram:
                                Text(weightFormatter.string(
                                    from: NSNumber(value: entry.getWeight(as: .kilograms)))! + " kg"
                                )
                            case .pound:
                                Text(weightFormatter.string(
                                    from: NSNumber(value: entry.getWeight(as: .pounds)))! + " lb"
                                )
                            }
                        }
                        .swipeActions(allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                deleteEntry(entry)
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func deleteEntry(_ entry: UserBodyWeight) {
        modelContext.delete(entry)
    }
    
    func addEntry(value: Double, date: Date) {
        var unit: UnitMass = .kilograms
        switch unitPreference {
        case .kilogram:
            unit = .kilograms
        case .pound:
            unit = .pounds
        }
        modelContext.insert(UserBodyWeight(value: value, date: date, as: unit))
        print("added body weight entry")
        do{
            try modelContext.save()
        } catch {
            print("couldn't save")
        }
    }
}

struct MeasurementEntryView: View {
    @State var selectedDate: Date = Date()
    @State var enteredMeasurement: Double = 0
    var unit: String
    
    var addEntry: (Double, Date) -> Void
    
    var body: some View {
        HStack{
            VStack{
                DatePicker(
                    "Date",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                TextField(
                    "Enter Weight (\(unit))",
                    value: $enteredMeasurement,
                    format: .number
                )
                .keyboardType(.decimalPad)
            }
            Button {
                addEntry(enteredMeasurement, selectedDate)
            } label: {
                Label("Submit", systemImage: "plus.circle")
            }
        }
    }
}


#Preview {
    let config = ModelConfiguration(for: UserBodyWeight.self, isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: UserBodyWeight.self, configurations: config)
    let context = container.mainContext
    
    let mock = [
        UserBodyWeight(value: 70, date: Date().advanced(by: -86400*2), as: .kilograms),
        UserBodyWeight(value: 71, date: Date().advanced(by: -86400*1), as: .kilograms),
        UserBodyWeight(value: 72, date: Date().advanced(by: -86400), as: .kilograms),
    ]
    
    for weightEntry in mock {
        context.insert(weightEntry)
    }
    
    return BodyWeightHistoryView().modelContainer(container)
}
