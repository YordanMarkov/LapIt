//
//  DeefaultHomeVieew.swift
//  LapIt
//
//  Created by Yordan Markov on 16.01.23.
//

import Foundation
import SwiftUI

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
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10.0).fill(Color.white))
                            })
                        }
                    }
                }
                .sheet(item: self.$selectedCompetition, content: { selectedCompetition in
                    DefaultCompetitionButtonView(viewModel: viewModel, currentCompetition: selectedCompetition)
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
                                viewModel.route(to: .stats)
                            },
                            label: {
                                Text("Stats")
                                    .foregroundColor(.white)
                                    .bold()
                                    .offset(x: 10)
                            })
                        .buttonStyle(.plain)
                        
                        Button(
                            action: {
                            viewModel.profileView = true
                            }, label: {
                                Image("LapItLogo")
                                    .resizable()
                                    .frame(width: 109, height: 87, alignment: .center)
                                    .offset(x: 8)
                            })
                        .sheet(isPresented: $viewModel.profileView) {
                            ProfileView(viewModel: viewModel)
                        }
                        
                        Button(
                            action: {
                                viewModel.route(to: .history)
                            },
                            label: {
                                Text("History")
                                    .foregroundColor(.white)
                                    .bold()
                                    .offset(x: -5)
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
