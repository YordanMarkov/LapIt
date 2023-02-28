//
//  OrganizerHomeView.swift
//  LapIt
//
//  Created by Yordan Markov on 25.01.23.
//

import Foundation
import SwiftUI

struct ProfileViewO: View {
    
    @State private var showAlert = false
    @State private var showDeleteAlert = false
    
    @State private var firstName: String
    @State private var secondName: String
    
    @ObservedObject private var viewModel: OrganizerHomeViewModel
    
    init(viewModel: OrganizerHomeViewModel) {
        self.viewModel = viewModel
        self.firstName = viewModel.firstName
        self.secondName = viewModel.secondName
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Organizer Profile")
                .padding()
                .background(Color(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor))
                .font(.largeTitle)
                .cornerRadius(10)
                .foregroundColor(.white)
            
            VStack {
                Text("First Name: ")
                TextField("", text: $firstName)
                    .multilineTextAlignment(.center)
            }
            
            VStack {
                Text("Second Name: ")
                TextField("", text: $secondName)
                    .multilineTextAlignment(.center)
            }
            
            Text("Email: " + viewModel.email)
            
            if(firstName != viewModel.firstName || secondName != viewModel.secondName) {
                Button(
                    action: {
                        viewModel.save(firstName: firstName, secondName: secondName)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            viewModel.getDetails()
                        }
                    },
                    label: {
                        Text("Save")
                            .frame(width: 100 , height: 30, alignment: .center)
                    })
                .buttonStyle(.borderedProminent)
                .foregroundColor(.white)
                .tint(.init(.green))
            }
            
            Button(
                action: {
                    showAlert = true
                },
                label: {
                    Text("Sign out")
                        .frame(width: 100 , height: 30, alignment: .center)
                })
            .alert(isPresented: $showAlert) {
                Alert (
                    title: Text("You are about to sign out. Continue?"),
                    primaryButton: .default(Text("Yes")) {
                        viewModel.profileView = false
                        viewModel.signOut()
                        viewModel.route(to: .login)
                    },
                    secondaryButton: .cancel()
                )
            }
            .buttonStyle(.borderedProminent)
            .foregroundColor(.white)
            .tint(.init(.red))
            
            Button(
                action: {
                    showDeleteAlert = true
                },
                label: {
                    Text("Delete account")
                        .frame(width: 155 , height: 30, alignment: .center)
                })
            .alert(isPresented: $showDeleteAlert) {
                Alert (
                    title: Text("You are about to delete your account. This will delete all of your competitions and scoreboards. This action is irreversible. Continue?"),
                    primaryButton: .default(Text("Yes")) {
                        viewModel.profileView = false
                        viewModel.deleteAccount()
                        viewModel.route(to: .login)
                    },
                    secondaryButton: .cancel()
                )
            }
            .buttonStyle(.borderedProminent)
            .foregroundColor(.white)
            .tint(.init(.yellow))
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).ignoresSafeArea())
    }
}
    
    
struct OrganizerHomeView: View {
    
    @ObservedObject private var viewModel: OrganizerHomeViewModel
    @State private var selectedCompetition: OrganizerHomeViewModel.Competition? = nil
    
    init(viewModel: OrganizerHomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 50) {
                Text("Competitions")
                    .padding()
                    .background(Color(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor))
                    .font(.largeTitle)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                
                ScrollView {
                    if viewModel.competitions.isEmpty {
                        Text("Oops! Nothing to show.")
                    } else {
                        ForEach(viewModel.parseCompetitions().sorted(by: {$0.name < $1.name}), id: \.self) { competition in
                            Button(
                                action: {
                                    self.selectedCompetition = competition
                                },
                                label: {
                                    VStack {
                                        Text(competition.name)
                                            .foregroundColor(.black)
                                            .bold()
                                        Text(competition.description)
                                            .foregroundColor(.black)
                                            .italic()
                                    }
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 10.0).fill(Color.white))
                                })
                        }
                    }
                }
                .sheet(item: self.$selectedCompetition, content: { selectedCompetition in
                    OrganizerCompetitionButtonView(viewModel: viewModel, currentCompetition: selectedCompetition)
                })
            }
            
            VStack {
                ZStack() {
                    Rectangle()
                        .fill(Color(cgColor: UIColor(red: 0, green: 0.098, blue: 0.659, alpha: 1).cgColor))
                        .frame(width: 450, height: 21, alignment: .center)
                    HStack(spacing: 50) {
                        Button(
                            action: {
                                viewModel.route(to: .active)
                            },
                            label: {
                                Text("Active")
                                    .foregroundColor(.white)
                                    .bold()
                            })
                        .buttonStyle(.plain)
                        
                        Button(action: {
                            viewModel.profileView = true
                        }, label: {
                            Image("LapItLogo")
                                .resizable()
                                .frame(width: 109, height: 87, alignment: .center)
                        }
                        )
                        .sheet(isPresented: $viewModel.profileView) {
                            ProfileViewO(viewModel: viewModel)
                        }
                        
                        Button(
                            action: {
                                viewModel.route(to: .library)
                            },
                            label: {
                                Text("Library ")
                                    .foregroundColor(.white)
                                    .bold()
                            })
                        .buttonStyle(.plain)
                    }
                }
                
                Text("Profile   ")
            }
        }
        .background(Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).ignoresSafeArea())
        .onAppear {
            viewModel.getDetails()
        }
    }
}
