
import Foundation
import SwiftData

 
@Model
class UserBodyWeight {
    var date: Date
    var valueAsKg: Double
    
    func setWeight(value toSet: Double, as unit: UnitMass) {
        let x = Measurement<UnitMass>(value: toSet, unit: unit)
        self.valueAsKg = x.converted(to: .kilograms).value
    }
    
    func getWeight(as unit: UnitMass) -> Double{
        let x = Measurement<UnitMass>(value: self.valueAsKg, unit: .kilograms)
        return x.converted(to: unit).value
    }
    
    init(value: Double, date: Date, as unit: UnitMass){
        self.date = date
        
        let x = Measurement<UnitMass>(value: value, unit: unit)
        self.valueAsKg = x.converted(to: .kilograms).value
    }
}
