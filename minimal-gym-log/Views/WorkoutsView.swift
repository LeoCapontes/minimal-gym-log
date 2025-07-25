//
//  WorkoutsView.swift
//  minimal-gym-log
//
//  Created by Leo Capontes on 27/06/2025.
//

import SwiftUI
import SwiftData
import Foundation

struct WorkoutsView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \SetBlock.date, order: .reverse) var setblocks: [SetBlock]
    @Query var exercises: [Exercise]
    @AppStorage("MassUnitPreference")var unitPreference: MassUnits = .kilogram
    
    var groupedByDate: [Date:[SetBlock]] {
        Dictionary(grouping: setblocks, by: {Calendar.current.startOfDay(for: $0.date)})
    }
    
    var groupedByDateSorted: [Date: [SetBlock]] {
        groupedByDate.mapValues { blocks in
            blocks.sorted { $1.date > $0.date }
        }
    }
    
    var datesHeaders: [Date]{
        groupedByDate.map({$0.key}).sorted().reversed()
    }

    var addSetBlock : () -> Void
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(datesHeaders, id: \.self) { date in
                    Section(date.formatted(date: .long, time: .omitted)){
                        ForEach(groupedByDateSorted[date]!, id:  \.self) { setblock in
                            NavigationLink(value: setblock){
                                VStack(alignment: .leading) {
                                    Text(setblock.exercise.name)
                                        .font(.headline)
                                    Text(setblock.asString(unitPreference: unitPreference))
                                        .font(.subheadline)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            deleteSets(indexSet, for: date)
                        }
                    }
                }
            }
            .navigationDestination(for: SetBlock.self){ setblock in
                    EditSetblockView.init(setblock: setblock, exercises: exercises)
            }
            .navigationTitle("GymLog")
            .toolbar{
                Button("Add Sets", action: addSetBlock)
            }
        }
    }
    
    func deleteSets(_ indexSet: IndexSet, for date: Date) {
        guard let setblocksForDate = groupedByDate[date] else { return }
        for index in indexSet {
            let exerciseSet = setblocksForDate[index]
            modelContext.delete(exerciseSet)
        }
    }
}

//#Preview {
//    WorkoutsView()
//}
