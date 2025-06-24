//
//  definitions.swift
//  minimal-gym-log
//
//  Created by Leo Capontes on 19/04/2025.
//

import SwiftData
import Foundation

@Model
class Exercise{
    #Unique<Exercise>([\.name])
    var name: String
    
    init(name: String) {
        self.name = name
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
}

//// stored arrays of structs become binary blobs when persisted, they need to be re-parsed when
//// using predicates etc. This is for arrays of Set
//final class SetTransformer : ValueTransformer {
//    override class func transformedValueClass() -> AnyClass {
//        return NSData.self
//    }
//    
//    override class func allowsReverseTransformation() -> Bool {
//        return true
//    }
//    
//    override func transformedValue(_ value: Any?) -> Any? {
//        guard let arr = value as? [Set] else { return nil }
//        return try? JSONEncoder().encode(arr)
//    }
//    
//    override func reverseTransformedValue(_ value: Any?) -> Any? {
//        guard let data = value as? Data else { return false }
//        return try? JSONDecoder().decode([Set].self, from: data)
//    }
//}

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
}
