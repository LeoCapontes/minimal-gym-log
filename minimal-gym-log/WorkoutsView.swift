//
//  WorkoutsView.swift
//  minimal-gym-log
//
//  Created by Leo Capontes on 27/06/2025.
//

import SwiftUI
import SwiftData

struct WorkoutsView: View {
    @Environment(\.modelContext) var modelContext
    @Query var setblocks: [SetBlock]
    @Query var exercises: [Exercise]
    
    var addSetBlock : () -> Void
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(setblocks) { setblock in
                    NavigationLink(value: setblock){
                        VStack(alignment: .leading) {
                            Text(setblock.exercise.name)
                                .font(.headline)
                            Text("\(setblock.sets[0].weight)kg x \(setblock.sets[0].reps) reps")
                                .font(.subheadline)
                        }
                    }
                }
                .onDelete(perform: deleteSets)
            }
            .navigationDestination(
                for: SetBlock.self){ setblock in
                    EditSetblockView.init(setblock: setblock, exercises: exercises)
                }
            .navigationTitle("GymLog")
            .toolbar{
                Button("Add Sets", action: addSetBlock)
            }
        }
    }
    
    func deleteSets(_ indexSet: IndexSet) {
        for index in indexSet {
            let exerciseSet = setblocks[index]
            modelContext.delete(exerciseSet)
        }
    }
}

//#Preview {
//    WorkoutsView()
//}
