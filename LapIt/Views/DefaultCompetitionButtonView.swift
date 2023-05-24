//
//  DefaultCompetitionButtonView.swift
//  LapIt
//
//  Created by Yordan Markov on 2.02.23.
//

import Foundation
import SwiftUI

struct DefaultCompetitionButtonView: View {
    
    @ObservedObject private var viewModel: DefaultHomeViewModel
    @State private var currentCompetition: DefaultHomeViewModel.Competition
    @State private var showAlert = false
    
    init(viewModel: DefaultHomeViewModel, currentCompetition: DefaultHomeViewModel.Competition) {
        self.viewModel = viewModel
        self.currentCompetition = currentCompetition
    }
    
    var body: some View {
        VStack {
            CompetitionButtonView(viewModel: DefaultHomeViewModel(network: Network(), coordinator: Coordinator()), currentCompetition: currentCompetition)
            
            if !viewModel.joined {
                Button(
                    action: {
                        self.showAlert = true
                    },
                    label: {
                        Text("Join")
                            .frame(width: 100 , height: 30, alignment: .center)
                    })
                .alert(isPresented: $showAlert) {
                    Alert (
                        title: Text("Are you sure you want to join? You can leave this competition from the History tab."),
                        primaryButton: .default(Text("Yes")) {
                            viewModel.joinCompetition(currentCompetition: currentCompetition)
                            viewModel.joined = true
                        },
                        secondaryButton: .cancel()
                    )
                }
                .buttonStyle(.borderedProminent)
                .foregroundColor(.white)
                .tint(.init(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor))
            } else {
                Text("Already joined!")
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            viewModel.isAlreadyJoined(currentCompetition: currentCompetition)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).ignoresSafeArea())
    }
}
