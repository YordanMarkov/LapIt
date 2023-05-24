//
//  OrganizerHomeView.swift
//  LapIt
//
//  Created by Yordan Markov on 25.01.23.
//

import Foundation
import SwiftUI
    
    
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
                                    }
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 10.0).fill(Color.white))
                                })
                        }
                    }
                }
                .sheet(item: self.$selectedCompetition, content: { selectedCompetition in
                    CompetitionButtonView(viewModel: viewModel, currentCompetition: selectedCompetition)
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
                                    .offset(x: 10)
                            })
                        .buttonStyle(.plain)
                        
                        Button(action: {
                            viewModel.profileView = true
                        }, label: {
                            Image("LapItLogo")
                                .resizable()
                                .frame(width: 109, height: 87, alignment: .center)
                                .offset(x: 3)
                        }
                        )
                        .sheet(isPresented: $viewModel.profileView) {
                            ProfileView(viewModel: viewModel)
                        }
                        
                        Button(
                            action: {
                                viewModel.route(to: .library)
                            },
                            label: {
                                Text("Library")
                                    .foregroundColor(.white)
                                    .bold()
                                    .offset(x: -10)
                            })
                        .buttonStyle(.plain)
                    }
                }
                
                Text("Profile")
            }
        }
        .background(Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).ignoresSafeArea())
        .onAppear {
            viewModel.getDetails()
        }
    }
}
