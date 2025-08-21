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
    var bodyWeights: [UserBodyWeight]
    
    var volumes: [Double] {
        if setblocks.first!.exercise.bodyWeightExercise {
            return setblocks.map {$0.getTotalVolume(as: massUnitPreference, using: bodyWeights)}
        } else {
            return setblocks.map {$0.getTotalVolume(as: massUnitPreference)}
        }
    }
    
    var stopPoint: CGFloat {
        if setblocks.count < 2 {return CGFloat(0)}
        return CGFloat(CGFloat(setblocks.count - 2) / CGFloat(setblocks.count-1))
    }
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Volume (\(massUnitPreference.rawValue))")
            Chart{
                ForEach(setblocks, id: \.self) { setblock in
                    LineMark(
                        x: .value("Date", setblock.date.formatted(date: .numeric, time: .omitted)),
                        y: .value(
                            "Volume",
                            setblock.exercise.bodyWeightExercise ?
                                setblock.getTotalVolume(as: massUnitPreference, using: bodyWeights) :
                                setblock.getTotalVolume(as: massUnitPreference)
                        )
                    )
                    .symbol(.circle)
                    .foregroundStyle(
                        .linearGradient(
                            Gradient(
                                stops: [
                                    .init(color: .gray, location:0),
                                    .init(color: .gray, location: stopPoint),
                                    .init(color: .blue, location: stopPoint+0.01),
                                    .init(color: .blue, location:1),
                                ]
                            ),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                }
            }
            .chartYScale(
                domain: volumes.min()!*0.9 ... volumes.max()!*1.1)
        }
    }
}

#Preview {
    let exercise = Exercise(name: "Bicep Curl", bodyPart: .bicep)
    let mock = generateMockSetblocks(quantity: 6, exercise: exercise)
    let mockWeights = generateMockUserBodyWeights(quantity: 6)
    
    PreviousSetsChart(setblocks: mock, bodyWeights: mockWeights)
        .frame(height: 150)
}
