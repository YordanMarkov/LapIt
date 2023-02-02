//
//  CompetitionButtonView.swift
//  LapIt
//
//  Created by Yordan Markov on 2.02.23.
//

import Foundation
import SwiftUI

struct DefaultCompetitionButtonView: View {
    
    @ObservedObject private var viewModel: DefaultHomeViewModel
    @State private var currentCompetition: DefaultHomeViewModel.Competition
    
    init(viewModel: DefaultHomeViewModel, currentCompetition: DefaultHomeViewModel.Competition) {
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
            
            Text(currentCompetition.description)
                .italic()
            
            if currentCompetition.distanceOrTime == 0 {
                Text("The winners are ranked by distance.")
                    .bold()
            } else {
                Text("The winners are ranked by time.")
                    .bold()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).edgesIgnoringSafeArea(.vertical))
    }
}

//struct ContentView_Previews: PreviewProvider {
//    @ObservedObject private var viewModel: DefaultHomeViewModel
//    init(viewModel: DefaultHomeViewModel) {
//        self.viewModel = viewModel
//    }
//    static var previews: some View {
////        LogInView(viewModel: LogInViewModel(network: Network(), coordinator: Coordinator()))
////        RegisterView(viewModel: RegisterViewModel(network: Network(), coordinator: Coordinator()))
//        DefaultCompetitionButtonView(viewModel: DefaultHomeViewModel(network: Network(), coordinator: Coordinator(), currentCompetition: viewModel.Competition(name: "Test", description: "Description", distanceOrTime: 1, isActive: true)))
//    }
//}
