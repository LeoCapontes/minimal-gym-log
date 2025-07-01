//
//  definitions.swift
//  minimal-gym-log
//
//  Created by Leo Capontes on 19/04/2025.
//

import SwiftData
import Foundation

extension Exercise {
    enum BodyPart: String, CaseIterable, Codable {
        case core = "Core"
        case bicep = "Biceps"
        case back = "Back"
        case legs = "Legs"
        case tricep = "Triceps"
        case shoulder = "Shoulders"
        case chest = "Chest"
        case cardio = "Cardio"
        case fullBody = "Full body"
        case other = "Other"
    }
}

@Model
class Exercise{
    #Unique<Exercise>([\.name])
    var name: String
    var bodyPart: BodyPart
    var bodyWeightExercise: Bool
    
    init(name: String, bodyPart: BodyPart, isBodyWeight: Bool = false) {
        self.name = name
        self.bodyPart = bodyPart
        self.bodyWeightExercise = isBodyWeight
    }
}

@Model
class Set{
    var reps: Int?
    var length: Int?
    
    // metric
    var weight: Float
    var note: String
    
    init(reps: Int, weight: Float){
        self.reps = reps
        self.weight = weight
        self.note = ""
    }
    
    init(length: Int, weight: Float){
        self.length = length
        self.weight = weight
        self.note = ""
    }
    
    func asString() -> String {
        var setAsString: String = ""
        // if reps
        if(reps != nil){
            setAsString = "\(weight)kg for \(reps ?? 0) reps"
        } else {
            setAsString = "\(weight)kg for \(length ?? 0)"
        }
        return setAsString
    }
}

@Model
class SetBlock {
    var exercise: Exercise
    
    @Relationship(deleteRule: .cascade)
    var sets: [Set]
    
    var date: Date
    
    init(exercise: Exercise, sets: [Set], date: Date) {
        self.exercise = exercise
        self.sets = sets
        self.date = date
    }
    
    func asString() -> String {
        var setsAsString: String = ""
        for (index, set) in self.sets.enumerated() {
            if(index==0) {
                setsAsString.append(set.asString())
            }
            setsAsString.append("\n\(set.asString())")
        }
        return setsAsString
    }
}
