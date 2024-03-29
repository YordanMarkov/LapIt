//
//  History.swift
//  LapIt
//
//  Created by Yordan Markov on 26.01.23.
//

import Foundation
import SwiftUI

struct HistoryView: View {
    @ObservedObject private var viewModel: HistoryViewModel
    @State private var selectedCompetition: HistoryViewModel.Competition? = nil
    
    init(viewModel: HistoryViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 50) {
                Text("History")
                    .padding()
                    .background(Color(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor))
                    .font(.largeTitle)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                
                VStack {
                    Text("Joined")
                    
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
                        DefaultHistoryCompetitionView(viewModel: viewModel, currentCompetition: selectedCompetition)
                    })
                }
                
                VStack {
                    Text("Previous")
                    
                    ScrollView {
                        if viewModel.inactive_competitions.isEmpty {
                            Text("Oops! Nothing to show.")
                        } else {
                            ForEach(viewModel.parseInactiveCompetitions().sorted(by: {$0.name < $1.name}), id: \.self) { competition in
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
                        DefaultHistoryCompetitionView(viewModel: viewModel, currentCompetition: selectedCompetition)
                    })
                }
            }
            
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color(cgColor: UIColor(red: 0, green: 0.098, blue: 0.659, alpha: 1).cgColor))
                        .frame(width: 450, height: 21)
                    
                    HStack(spacing: 50) {
                        Button(
                            action: {
                                viewModel.route(to: .defaultHome)
                            },
                            label: {
                                Text("<<")
                                    .frame(alignment: .center)
                                    .foregroundColor(.white)
                                    .bold()
                                    .offset(x: -40)
                            })
                        .buttonStyle(.plain)
                        
                        Image("LapItLogo")
                            .resizable()
                            .frame(width: 109, height: 87, alignment: .center)
                            .offset(x: -36)
                    }
                }
            }
            .offset(y: -28)
        }
        .background(Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).ignoresSafeArea())
        .onAppear {
            viewModel.getDetails()
        }
    }
}
