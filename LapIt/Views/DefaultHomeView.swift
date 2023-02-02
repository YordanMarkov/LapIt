//
//  DeefaultHomeVieew.swift
//  LapIt
//
//  Created by Yordan Markov on 16.01.23.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    
    @State private var showAlert = false
    
    @ObservedObject private var viewModel: DefaultHomeViewModel
    
    init(viewModel: DefaultHomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Profile")
                .padding()
                .background(Color(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor))
                .font(.largeTitle)
                .cornerRadius(10)
                .foregroundColor(.white)
//                .frame(width: 400)
//                .position(x: 205, y: 100)
            
            Text("First Name: " + viewModel.firstName)
            
            Text("Second Name: " + viewModel.secondName)
            
            Text("Email: " + viewModel.email)
            
            Button(
                action: {
                    showAlert = true
                },
                label: {
                    Text("Sign out")
                        .frame(width: 100 , height: 30, alignment: .center)
                }).alert(isPresented: $showAlert) {
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
//            .position(x: 205, y: 700)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).edgesIgnoringSafeArea(.vertical))
    }
}

struct DefaultHomeView: View {
    
    @ObservedObject private var viewModel: DefaultHomeViewModel
    @State private var selectedCompetition: DefaultHomeViewModel.Competition? = nil
    
    init(viewModel: DefaultHomeViewModel) {
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
                //                .frame(width: 400)
                //                .position(x: 205, y: 100)
                
                ScrollView {
                    if viewModel.competitions.isEmpty {
                        Text("Oops! Nothing to show.")
                    } else {
                        ForEach(viewModel.parseCompetitions().sorted(by: {$0.name < $1.name}), id: \.self) { competition in
                            Button(action: {
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
                }.sheet(item: self.$selectedCompetition, content: { selectedCompetition in
                    DefaultCompetitionButtonView(viewModel: viewModel, currentCompetition: selectedCompetition)
                })
            }
                
            VStack {
                ZStack() {
                    Rectangle()
                        .fill(Color(cgColor: UIColor(red: 0, green: 0.098, blue: 0.659, alpha: 1).cgColor))
                        .frame(width: 450, height: 21, alignment: .center)
                    //                    .position(x: 200, y: 143)
                    HStack(spacing: 50) {
                        Button(
                            action: {
                                viewModel.route(to: .stats)
                            },
                            label: {
                                Text("   Stats   ")
                                    .foregroundColor(.white)
                                    .bold()
                            })
                        .buttonStyle(.plain)
                        //                    .position(x: 65, y: 142.5)
                        Button(action: {
                            viewModel.profileView = true
//                            viewModel.getDetails()
                        }, label: {
                            Image("LapItLogo")
                                .resizable()
                                .frame(width: 109, height: 87, alignment: .center)
                            //                        .position(x: 200, y: 143)
                        }
                        ).sheet(isPresented: $viewModel.profileView) {
                            ProfileView(viewModel: viewModel)
                        }
                        
                        Button(
                            action: {
                                viewModel.route(to: .history)
                            },
                            label: {
                                Text("History  ")
                                    .foregroundColor(.white)
                                    .bold()
                            })
                        .buttonStyle(.plain)
                    }
                }
                
                Text("Profile")
            }
        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).edgesIgnoringSafeArea(.vertical))
        .onAppear {
            viewModel.getDetails()
        }
    }
}
