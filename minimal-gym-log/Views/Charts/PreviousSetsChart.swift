//
//  PreviousSetsChart.swift
//  minimal-gym-log
//
//  Created by Leo Capontes on 10/07/2025.
//
import SwiftUI
import Charts

struct PreviousSetsChart: View {
    @AppStorage("MassUnitPreference") var massUnitPreference: MassUnits = .kilogram
    var setblocks: [SetBlock]
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Volume (\(massUnitPreference.rawValue))")
            Chart{
                ForEach(setblocks, id: \.date) { setblock in
                    LineMark(
                        x: .value("Date", setblock.date.formatted(date: .numeric, time: .omitted)),
                        y: .value("Volume", setblock.getTotalVolume(as: massUnitPreference))
                    )
                    .symbol(.circle)
                }
            }
        }
    }
}

#Preview {
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
    
    PreviousSetsChart(setblocks: mock)
        .frame(height: 150)
}
