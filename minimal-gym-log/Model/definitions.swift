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
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 3
        // if reps
        if(reps != nil){
            setAsString = "\(formatter.string(from: NSNumber(value: weight))!)kg for \(reps ?? 0) reps"
        } else {
            setAsString = "\(formatter.string(from: NSNumber(value: weight))!)kg for \(length ?? 0)"
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
        var setRepetitions: [Int] = [Int](repeating: 0, count: self.sets.count+1)
        var currentind: Int = 0
        for (index, set) in self.sets.enumerated() {
            if(index==0){
                setRepetitions[currentind] += 1
                continue;
            }
            if (set.asString() == sets[index-1].asString()) {
                setRepetitions[currentind] += 1
            } else {
                currentind += 1
                setRepetitions[currentind] += 1
            }
        }
        // check if all sets were properly counted
        let sumOfRepetitions = setRepetitions.reduce(0, +)
        if( sumOfRepetitions != self.sets.count) {
            // temporary fallback with no set grouping
            print("doesn't add up, \(sumOfRepetitions) and sets.count is \(self.sets.count)")
            for (index, set) in self.sets.enumerated() {
                if(index==0) {
                    setsAsString.append(set.asString())
                }
                setsAsString.append("\n\(set.asString())")
            }
            return setsAsString
        }
        else {
            var currentSetIndex: Int = 0
            for (_, repetitions) in setRepetitions.enumerated() {
                if(repetitions==0){return setsAsString.trimmingCharacters(in: CharacterSet.newlines)}
                if(repetitions==1){
                    setsAsString.append(sets[currentSetIndex].asString())
                }
                else{
                    setsAsString.append("\(sets[currentSetIndex].asString()) x\(repetitions)")
                }
                setsAsString.append("\n")
                currentSetIndex+=repetitions
            }
            return setsAsString
        }
    }
}
