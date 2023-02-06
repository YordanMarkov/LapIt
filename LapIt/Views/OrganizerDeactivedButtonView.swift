//
//  OrganizerDeactivedButtonView.swift
//  LapIt
//
//  Created by Yordan Markov on 3.02.23.
//
import Foundation
import SwiftUI

struct OrganizerDeactivedButtonView: View {
    
    @ObservedObject private var viewModel: ActiveViewModel
    @State private var currentCompetition: ActiveViewModel.Competition
    @State private var showAlert = false
    @State private var activated = false
    
    init(viewModel: ActiveViewModel, currentCompetition: ActiveViewModel.Competition) {
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
            
            if !self.activated {
                Button(
                    action: {
                        self.showAlert = true
                    },
                    label: {
                        Text("Activate")
                            .frame(width: 100 , height: 30, alignment: .center)
                    }
                )
                .alert(isPresented: $showAlert) {
                    Alert (
                        title: Text("Are you sure you want to activate this competition? You can deactivate it again from the Currently activated menu."),
                        primaryButton: .default(Text("Yes")) {
                            viewModel.activateCompetition(currentCompetition: currentCompetition)
                            self.activated = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                viewModel.getDetails()
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
                .buttonStyle(.borderedProminent)
                .foregroundColor(.white)
                .tint(.init(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor))
            } else {
                Text("Already activated!")
                    .foregroundColor(.red)
            }
            
            Text("Winners")
                .fontWeight(.bold)
                .foregroundColor(.red)
            ForEach(viewModel.winners, id: \.self) { user in
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
        .onAppear{
            viewModel.getDetails()
            viewModel.getUsers(currentCompetition: currentCompetition)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).edgesIgnoringSafeArea(.vertical))
    }
}
