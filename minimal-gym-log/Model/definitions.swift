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
    // for bodyweight exercise volume calculation
    var effectiveLoad: Double = 1
    
    init(name: String, bodyPart: BodyPart, isBodyWeight: Bool = false) {
        self.name = name
        self.bodyPart = bodyPart
        self.bodyWeightExercise = isBodyWeight
    }
    
    init(name: String, bodyPart: BodyPart, isBodyWeight: Bool = false, effectiveLoad: Double) {
        self.name = name
        self.bodyPart = bodyPart
        self.bodyWeightExercise = isBodyWeight
        self.effectiveLoad = effectiveLoad
    }
}

@Model
class Set{
    var reps: Int?
    var length: Int?
    
    // Kilograms
    var weightKg: Double? = 0
    var note: String
    
    init(reps: Int, weight: Double){
        self.reps = reps
        self.weightKg = weight
        self.note = ""
    }
    
    init(length: Int, weight: Double){
        self.length = length
        self.weightKg = weight
        self.note = ""
    }
    
    func asString(unitPreference: MassUnits) -> String {
        var setAsString: String = ""
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        // if reps
        let weightToShow = getWeight(as: unitPreference)
        if(reps != nil){
            setAsString = "\(formatter.string(from: NSNumber(value: weightToShow))!)\(unitPreference.rawValue) for \(reps ?? 0) reps"
        } else {
            setAsString = "\(formatter.string(from: NSNumber(value: weightToShow))!)\(unitPreference.rawValue) for \(length ?? 0)"
        }
        return setAsString
    }
    
    func setWeight(weight toSet: Double, as unit: MassUnits){
        switch unit{
        case .kilogram:
            weightKg = toSet
        case .pound:
            let pounds = Measurement<UnitMass>(value: toSet, unit: .pounds)
            weightKg = pounds.converted(to: .kilograms).value
        }
    }
    
    func setWeight(weight toSet: String, as unit: MassUnits){
        switch unit{
        case .kilogram:
            weightKg = Double(toSet)!
        case .pound:
            let pounds = Measurement<UnitMass>(value: Double(toSet)!, unit: .pounds)
            weightKg = pounds.converted(to: .kilograms).value
        }
    }
    
    func getWeight(as unit: MassUnits) -> Double{
        let kg = Measurement<UnitMass>(value: weightKg!, unit: .kilograms)
        switch unit{
        case .kilogram: return kg.value
        case .pound: return kg.converted(to: .pounds).value
        }
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
    
    func getTotalVolume(as unit: MassUnits) -> Double {
        var volumeKg: Double = 0
        for s in self.sets {
            volumeKg += (Double(s.reps ?? 0) * (s.weightKg ?? 0))
        }
        switch unit{
        case .kilogram: return volumeKg
        case .pound:
            let kg = Measurement<UnitMass>(value: volumeKg, unit: .kilograms)
            return kg.converted(to: .pounds).value
        }
    }
    
    func asString(unitPreference: MassUnits) -> String {
        var setsAsString: String = ""
        var setRepetitions: [Int] = [Int](repeating: 0, count: self.sets.count+1)
        var currentind: Int = 0
        for (index, set) in self.sets.enumerated() {
            if(index==0){
                setRepetitions[currentind] += 1
                continue;
            }
            if (set.asString(unitPreference: unitPreference) == sets[index-1].asString(unitPreference: unitPreference)) {
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
                    setsAsString.append(set.asString(unitPreference: unitPreference))
                }
                setsAsString.append("\n\(set.asString(unitPreference: unitPreference))")
            }
            return setsAsString
        }
        else {
            var currentSetIndex: Int = 0
            for (_, repetitions) in setRepetitions.enumerated() {
                if(repetitions==0){return setsAsString.trimmingCharacters(in: CharacterSet.newlines)}
                if(repetitions==1){
                    setsAsString.append(sets[currentSetIndex].asString(unitPreference: unitPreference))
                }
                else{
                    setsAsString.append("\(sets[currentSetIndex].asString(unitPreference: unitPreference)) x\(repetitions)")
                }
                setsAsString.append("\n")
                currentSetIndex+=repetitions
            }
            return setsAsString
        }
    }
}
