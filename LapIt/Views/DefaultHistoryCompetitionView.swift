//
//  DefaultHistoryCompetitionView.swift
//  LapIt
//
//  Created by Yordan Markov on 2.02.23.
//

import Foundation
import SwiftUI

struct DefaultHistoryCompetitionView: View {
    
    @ObservedObject private var viewModel: HistoryViewModel
    @State private var currentCompetition: HistoryViewModel.Competition
    @State private var showAlert = false
    
    init(viewModel: HistoryViewModel, currentCompetition: HistoryViewModel.Competition) {
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
                Text("The players are ranked by distance.")
                    .bold()
            } else {
                Text("The players are ranked by time.")
                    .bold()
            }
            
            if !viewModel.left && currentCompetition.isActive != false {
                Button(
                    action: {
                        self.showAlert = true
                    },
                    label: {
                        Text("Leave")
                            .frame(width: 100 , height: 30, alignment: .center)
                    }
                )
                .alert(isPresented: $showAlert) {
                    Alert (
                        title: Text("Are you sure you want to leave? You can rejoin this competition from the Home tab."),
                        primaryButton: .default(Text("Yes")) {
                            viewModel.leaveCompetition(currentCompetition: currentCompetition)
                            viewModel.left = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                viewModel.getDetails()
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
                .buttonStyle(.borderedProminent)
                .foregroundColor(.white)
                .tint(.red)
            } else if currentCompetition.isActive != false {
                Text("You just left!")
                    .foregroundColor(.red)
            } else if currentCompetition.isActive == false {
                Text("Old competition. You cannot join nor leave.")
                    .foregroundColor(.red)
            }
            
            Text("All users")
                .fontWeight(.bold)
            ScrollView {
                ForEach(viewModel.users, id: \.self) { user in
                    VStack {
                        Text("\(user.firstName) \(user.secondName)")
                            .fontWeight(.bold)
                        if currentCompetition.distanceOrTime == 0 {
                            Text("Distance: \(user.km)")
                        } else {
                            Text("Time: \(user.min)")
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.isAlreadyJoined(currentCompetition: currentCompetition)
            viewModel.getUsers(currentCompetition: currentCompetition) 
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).edgesIgnoringSafeArea(.vertical))
    }
}
