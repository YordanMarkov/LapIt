//
//  MeasurementView.swift
//  LapIt
//
//  Created by Yordan Markov on 24.05.23.
//

import Foundation
import SwiftUI

struct MeasurementView: View {
    let measure: Float
    let action: (Float) -> Void
    let title: String
    let measure_type: String
    @State var value: Float = 0
    
    init(measure: Float, title: String, measure_type: String, action: @escaping (Float) -> Void) {
        self.measure = measure
        self.action = action
        self.title = title
        self.measure_type = measure_type;
    }
    
    var body: some View {
        HStack {
            Text("\(title): \(measure, specifier: "%.2f") \(measure_type)")
            
            TextField("Change", value: $value, format: .number)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if(value != measure && value >= 0) {
                Button(
                    action: {
                        action(value)
                    },
                    label: {
                        Text("Update")
                            .frame(width: 60 , height: 15)
                    })
                .buttonStyle(.borderedProminent)
                .foregroundColor(.white)
                .tint(.yellow)
            }
        }
    }
}

