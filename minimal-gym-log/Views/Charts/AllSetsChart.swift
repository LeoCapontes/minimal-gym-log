//
//  AllSetsChart.swift
//  minimal-gym-log
//
//  Created by Leo Capontes on 19/07/2025.
//

import SwiftUI
import Charts

struct AllSetsChart: View {
    @AppStorage("MassUnitPreference") var massUnitPreference: MassUnits = .kilogram
    var exercise: Exercise
    var setblocks: [SetBlock]
    
    var volumes: [Double] {
        setblocks.map {$0.getTotalVolume(as: massUnitPreference)}
    }
    
    var entriesByDate: [SetBlock] {
        setblocks.sorted(by: {$0.date < $1.date})
    }
    
    var dateFormat = Date.FormatStyle().year(.twoDigits).month(.twoDigits).day(.twoDigits)
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Volume per workout(\(massUnitPreference.rawValue))")
            Chart{
                ForEach(entriesByDate, id: \.self) { setblock in
                    LineMark(
                        x: .value("Date", setblock.date.formatted(dateFormat)
                        ),
                        y: .value("Volume", setblock.getTotalVolume(as: massUnitPreference))
                    )
                    .symbol(.circle)
                }
            }
            .chartYScale(
                domain: volumes.min()!*0.9 ... volumes.max()!*1.1)
            .chartXVisibleDomain(length: (entriesByDate.count > 10 ? 10 : entriesByDate.count))
            .chartScrollableAxes(.horizontal)
            .chartScrollPosition(initialX: Date())
        }
    }
}


#Preview {
    let exercise = Exercise(name: "Dumbbell curl", bodyPart: .bicep)
    let mock = generateMockSetblocks(quantity: 30, exercise: exercise)
    
    AllSetsChart(exercise: mock[0].exercise, setblocks: mock)
        .frame(height: 150)
}
