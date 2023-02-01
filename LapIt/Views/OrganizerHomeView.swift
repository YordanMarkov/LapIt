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
    
    @ObservedObject private var viewModel: OrganizerHomeViewModel
    
    init(viewModel: OrganizerHomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Organizer Profile")
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
    
    
struct OrganizerHomeView: View {
    
    @ObservedObject private var viewModel: OrganizerHomeViewModel
    
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
                //                .frame(width: 400)
                //                .position(x: 205, y: 100)
                
                ScrollView {
                    if viewModel.competitions.isEmpty {
                        Text("Oops! Nothing to show.")
                    } else {
                        ForEach(viewModel.parseCompetitions().sorted(by: {$0.name < $1.name}), id: \.self) { competition in
                            Button(action: {
                                // code upcoming
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
                                viewModel.route(to: .active)
                            },
                            label: {
                                Text("Active")
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
        //        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).edgesIgnoringSafeArea(.vertical))
        .onAppear {
            viewModel.getDetails()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
//        LogInView(viewModel: LogInViewModel(network: Network(), coordinator: Coordinator()))
//        RegisterView(viewModel: RegisterViewModel(network: Network(), coordinator: Coordinator()))
//        StatsView(viewModel: StatsViewModel(network: Network(), coordinator: Coordinator()))
        OrganizerHomeView(viewModel: OrganizerHomeViewModel(network: Network(), coordinator: Coordinator()))
    }
}
