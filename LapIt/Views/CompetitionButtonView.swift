//
//  CompetitionButtonView.swift
//  LapIt
//
//  Created by Yordan Markov on 24.05.23.
//

import Foundation
import SwiftUI

struct CompetitionButtonView: View {
    @ObservedObject private var viewModel: BaseHomeViewModel
    @State private var currentCompetition: BaseHomeViewModel.Competition
    @State private var showAlert = false
    
    init(viewModel: BaseHomeViewModel, currentCompetition: BaseHomeViewModel.Competition) {
        self.viewModel = viewModel
        self.currentCompetition = currentCompetition
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(currentCompetition.name)
                .padding()
                .background(Color(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor))
                .font(.largeTitle)
                .cornerRadius(10)
                .foregroundColor(.white)
            
            ScrollView {
                Text(currentCompetition.description)
                    .italic()
            }
            
            if currentCompetition.distanceOrTime == 0 {
                Text("The players are ranked by distance.")
                    .bold()
            } else {
                Text("The players are ranked by time.")
                    .bold()
            }
        }
        .onAppear{
            viewModel.getDetails()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).ignoresSafeArea())
    }
}

