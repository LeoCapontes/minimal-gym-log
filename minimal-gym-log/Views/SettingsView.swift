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
    
    // store date as double
    @AppStorage("StartTrackingDate")
    private var startTrackingDate = Date()
    
    var body: some View {
        let startDateBinding = Binding<Date>(
            get: { return startTrackingDate },
            set: { startTrackingDate = $0}
        )
        
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
                Section("Start Date") {
                    DatePicker(
                        "Start Date",
                        selection: startDateBinding,
                        displayedComponents: [.date]
                    )
                }
            }
        }
        .onAppear{
            print(startTrackingDate)
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


// from https://fatbobman.com/en/snippet/extending-supported-data-types-for-appstorage/
// allows for better handling of dates in AppStorage
extension Date: RawRepresentable {
    public typealias RawValue = String
    
    public init?(rawValue: RawValue) {
        guard let data = rawValue.data(using: .utf8),
              let date = try? JSONDecoder().decode(Date.self, from: data) else {
            return nil
        }
        self = date
    }
    
    public var rawValue: RawValue {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8) else {
            return ""
        }
        return result
    }
}
