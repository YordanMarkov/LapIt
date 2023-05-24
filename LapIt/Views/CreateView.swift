//
//  CreateView.swift
//  LapIt
//
//  Created by Yordan Markov on 24.05.23.
//

import Foundation
import SwiftUI

struct CreateView: View {
    @ObservedObject private var viewModel: LibraryViewModel
    @State private var currentCompetition: LibraryViewModel.Competition
    
    init(viewModel: LibraryViewModel, currentCompetition: LibraryViewModel.Competition) {
        self.viewModel = viewModel
        self.currentCompetition = currentCompetition
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Details")
                .padding()
                .background(Color(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor))
                .font(.largeTitle)
                .cornerRadius(10)
                .foregroundColor(.white)
            
            TextField("Name", text: $viewModel.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Desription", text: $viewModel.description, axis: .vertical)
                .lineLimit(5)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Picker(selection: $viewModel.distanceOrTime, label: Text("Please select an option")) {
                Text("Rank by distance").tag(0)
                Text("Rank by time").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            if !viewModel.description.isEmpty && !viewModel.name.isEmpty {
                Button(
                    action: {
                        viewModel.create()
                        viewModel.createView = false
                        viewModel.reuse = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            viewModel.getDetails()
                        }
                    },
                    label: {
                        Text("Activate")
                            .frame(width: 100 , height: 30, alignment: .center)
                    })
                .buttonStyle(.borderedProminent)
                .foregroundColor(.white)
                .tint(.green)
            }
            
            
        }
        .onAppear {
            viewModel.name = currentCompetition.name
            viewModel.description = currentCompetition.description
            viewModel.distanceOrTime = currentCompetition.distanceOrTime
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).ignoresSafeArea())
    }
}
