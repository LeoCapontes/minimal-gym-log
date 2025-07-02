//
//  minimal_gym_logTests.swift
//  minimal-gym-logTests
//
//  Created by Leo Capontes on 19/04/2025.
//

import Testing
import Foundation
@testable import minimal_gym_log

struct minimal_gym_logTests {
    
    @Test func setBlockToString() {
        let setBlock = SetBlock(
            exercise: Exercise(name: "push ups", bodyPart: Exercise.BodyPart.chest),
            sets: [
                Set(reps: 12, weight: 10),
                Set(reps: 12, weight: 10),
                Set(reps: 10, weight: 10)
            ],
            date: Date()
        )
        
        #expect(setBlock.asString() == "10kg for 12 reps x2\n10kg for 10 reps")
    }

}
