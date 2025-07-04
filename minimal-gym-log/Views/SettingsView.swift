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
                    Picker("", selection: $massUnitPreference){
                        ForEach(MassUnits.allCases) { unit in
                            Text(unit.rawValue)
                                .tag(unit)
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
}
