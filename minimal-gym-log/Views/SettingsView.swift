//
//  SettingsView.swift
//  minimal-gym-log
//
//  Created by Leo Capontes on 03/07/2025.
//
import SwiftUI

struct SettingsView: View {
    @AppStorage("MassUnitPreference")
    private var massUnitPreference: MassUnits = .kilogram
    
    var body: some View {
        NavigationStack{
            Form{
                Section("Units"){
                    Picker("Weight Units", selection: $massUnitPreference){
                        ForEach(MassUnits.allCases) { unit in
                            Text(unit.rawValue)
                                .tag(unit)
                        }
                    }
                }
                Section("Measurements"){
                    List{
                        NavigationLink{
                            BodyWeightHistoryView()
                        } label: {
                            Text("Body Weight")
                        }
                    }
                }
            }
        }
    }
}

enum MassUnits: String, CaseIterable, Codable, Identifiable {
    case kilogram = "kg",
         pound = "lb"
    
    var id: String {rawValue}
    
    var asUnitMass: UnitMass {
        switch(self){
        case .kilogram: return UnitMass.kilograms
        case .pound: return UnitMass.pounds
        }
    }
}
