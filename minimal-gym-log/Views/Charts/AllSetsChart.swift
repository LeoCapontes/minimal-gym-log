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
            let strideBy: Double = 4

            let volumesMin = volumes.min()!
            let volumesMax = volumes.max()!

            let meanWeights = setblocks.map { $0.getMeanWeight(as: massUnitPreference) }
            let meanWeightsMin = meanWeights.min()!
            let meanWeightsMax = meanWeights.max()!
            
            Text("Volume per workout(\(massUnitPreference.rawValue))")
            Chart(entriesByDate) { setblock in
                LineMark(
                    x: .value("Date", setblock.date.formatted(dateFormat)
                    ),
                    y: .value("Volume", (setblock.getTotalVolume(as: massUnitPreference) - volumesMin) / (volumesMax-volumesMin))
                )
                .foregroundStyle(by: .value("Value", "Volume"))
                .symbol(.circle)
                
                LineMark(
                    x: .value("Date", setblock.date.formatted(dateFormat)
                    ),
                    y: .value("Volume", (setblock.getMeanWeight(as: massUnitPreference) - meanWeightsMin) / (meanWeightsMax-meanWeightsMin))
                )
                .foregroundStyle(by: .value("Value", "Mean Weight"))
                .symbol(.circle)
                
            }
            .chartYScale(
                domain: -0.2 ... 1.2)
            .chartYAxis {
                var defaultStride = Array(stride(from: 0, to: 1, by: 1.0/strideBy))
                let meanWeightsStride = Array(stride(from: meanWeightsMin,
                                               through: meanWeightsMax,
                                               by: (meanWeightsMax - meanWeightsMin)/strideBy))
                AxisMarks(position: .trailing, values: defaultStride) { axis in
                    AxisGridLine()
                    let value = meanWeightsStride[axis.index]
                    AxisValueLabel("\(String(format: "%.2F", value)) kg", centered: false)
                }

                let volumesStride = Array(stride(from: volumesMin,
                                                     through: volumesMax,
                                                     by: (volumesMax - volumesMin)/strideBy))
                AxisMarks(position: .leading, values: defaultStride) { axis in
                    AxisGridLine()
                    let value = volumesStride[axis.index]
                    AxisValueLabel("\(String(format: "%.1F", value)) kg", centered: false)
                }
            }
            .chartXVisibleDomain(length: (entriesByDate.count > 6 ? 6 : entriesByDate.count))
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
