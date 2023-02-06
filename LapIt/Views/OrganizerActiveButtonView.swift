//
//  OrganizerActiveButtonView.swift
//  LapIt
//
//  Created by Yordan Markov on 3.02.23.
//
import Foundation
import SwiftUI

struct KmView: View {
    let userKm: Int
    let action: (Int) -> Void
    @State var km: Int = 0
    
    init(userKm: Int, action: @escaping (Int) -> Void) {
        self.userKm = userKm
        self.action = action
    }
    
    var body: some View {
        HStack {
            Text("Distance: \(userKm)")
            TextField("Change", value: $km, format: .number)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
                .keyboardType(.numberPad)
            if(km != userKm && km > 0) {
                Button {
                        action(km)
                    }
                label: {
                    Text("Update")
                        .frame(width: 60 , height: 15)
                }
                .buttonStyle(.borderedProminent)
                .foregroundColor(.white)
                .tint(.yellow)
            }
        }
    }
}

struct MinView: View {
    let userMin: Int
    let action: (Int) -> Void
    @State var min: Int = 0
    
    init(userMin: Int, action: @escaping (Int) -> Void) {
        self.userMin = userMin
        self.action = action
    }
    
    var body: some View {
        HStack {
            Text("Time: \(userMin)")
            TextField("Change", value: $min, format: .number)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            if(min != userMin && min >= 0) {
                Button(
                    action: {
                        action(min)
                    },
                    label: {
                        Text("Update")
                            .frame(width: 100 , height: 30)
                    }
                )
                .buttonStyle(.borderedProminent)
                .foregroundColor(.white)
                .tint(.yellow)
            }
        }
    }
}

struct OrganizerActiveButtonView: View {
    
    @ObservedObject private var viewModel: ActiveViewModel
    @State private var currentCompetition: ActiveViewModel.Competition
    @State private var showAlert = false
    @State private var deactivated = false
    
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
            
            Text("All users")
                .fontWeight(.bold)
            ScrollView {
                ForEach(viewModel.users, id: \.self) { user in
                    VStack {
                        Text("\(user.firstName) \(user.secondName)")
                            .fontWeight(.bold)
                        if currentCompetition.distanceOrTime == 0 {
                            KmView(userKm: user.km, action: { newKm in
                                viewModel.updateKm(currentCompetition: currentCompetition, km: newKm, user_email: user.user_email)
                                viewModel.getDetails()
                                viewModel.getUsers(currentCompetition: currentCompetition)
                            })
                        } else {
                            MinView(userMin: user.min, action: { newMin in
                                viewModel.updateMin(currentCompetition: currentCompetition, min: newMin, user_email: user.user_email)
                                viewModel.getDetails()
                                viewModel.getUsers(currentCompetition: currentCompetition)
                            })
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
