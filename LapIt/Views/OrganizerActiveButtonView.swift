//
//  OrganizerActiveButtonView.swift
//  LapIt
//
//  Created by Yordan Markov on 3.02.23.
//
import Foundation
import SwiftUI

struct OrganizerActiveButtonView: View {
    
    @ObservedObject private var viewModel: ActiveViewModel
    @State private var currentCompetition: ActiveViewModel.Competition
    @State private var showAlert = false
    @State private var deactivated = false
    @State private var showKickAlert = false
    @State private var emailToKick = ""
    @State private var user_name = ""
    
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
            
            if !self.deactivated {
                Button(
                    action: {
                        self.showAlert = true
                    },
                    label: {
                        Text("Deactivate")
                            .frame(width: 100 , height: 30, alignment: .center)
                    }
                )
                .alert(isPresented: $showAlert) {
                    Alert (
                        title: Text("Are you sure you want to deactivate this competition? You can activate it again from the Deactivated menu."),
                        primaryButton: .default(Text("Yes")) {
                            viewModel.deactivateCompetition(currentCompetition: currentCompetition)
                            self.deactivated = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                viewModel.getDetails()
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
                .buttonStyle(.borderedProminent)
                .foregroundColor(.white)
                .tint(.red)
            } else {
                Text("Already deactivated!")
                    .foregroundColor(.red)
            }
            if viewModel.users.isEmpty {
                Text("Oops! No users joined this competition.")
            } else {
                Text("All users")
                    .fontWeight(.bold)
                
                ScrollView {
                    ForEach(viewModel.users, id: \.self) { user in
                        VStack {
                            HStack {
                                VStack {
                                    Text("\(user.firstName) \(user.secondName)")
                                        .fontWeight(.bold)
                                    
                                    Text("\(user.user_email)")
                                        .fontWeight(.bold)
                                }
                                
                                Button(action: {
                                    self.showKickAlert = true
                                    self.user_name = user.firstName + " " + user.secondName
                                    self.emailToKick = user.user_email
                                },
                                       label: {
                                    Image("Delete")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                })
                                .alert(isPresented: $showKickAlert) {
                                    Alert (
                                        title: Text("Are you sure you want to kick \(user_name)? This will delete their stats and history!"),
                                        primaryButton: .default(Text("Yes")) {
                                            viewModel.leaveCompetition(competition_id: currentCompetition.id, user_email: emailToKick)
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                viewModel.getDetails()
                                                viewModel.getUsers(currentCompetition: currentCompetition)
                                            }
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                            }
                            if currentCompetition.distanceOrTime == 0 {
                                MeasurementView(measure: user.km, title: "Distance", measure_type: "km", action: { newKm in
                                    viewModel.updateKm(currentCompetition: currentCompetition, km: newKm, user_email: user.user_email)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        viewModel.getUsers(currentCompetition: currentCompetition)
                                    }
                                })
                            } else {
                                MeasurementView(measure: user.min, title: "Time", measure_type: "min", action: { newMin in
                                    viewModel.updateMin(currentCompetition: currentCompetition, min: newMin, user_email: user.user_email)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        viewModel.getUsers(currentCompetition: currentCompetition)
                                    }
                                })
                            }
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
        .background(Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).ignoresSafeArea())
    }
}
