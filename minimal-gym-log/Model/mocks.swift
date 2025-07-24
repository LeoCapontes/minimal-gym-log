//
//  mocks.swift
//  minimal-gym-log
//
//  Created by Leo Capontes on 24/07/2025.
//
import Foundation

func generateMockSetblocks(quantity: Int, exercise: Exercise) -> [SetBlock] {
    var setblocks = [SetBlock]()
    for i in (0..<quantity) {
        setblocks.append(
            SetBlock(
                exercise: exercise,
                sets: [Set(reps: 8+i, weight: 9), Set(reps: 8, weight: 10), Set(reps: 8, weight: 10)],
                date: Date().advanced(by: -86400*Double(i))
            )
        )
    }
    return setblocks
}
