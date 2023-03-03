//
//  ActiveView.swift
//  LapIt
//
//  Created by Yordan Markov on 26.01.23.
//
import Foundation
import SwiftUI

struct ActiveView: View {
    @ObservedObject private var viewModel: ActiveViewModel
    @State private var selectedToDeactivateCompetition: ActiveViewModel.Competition? = nil
    @State private var selectedToActivateCompetition: ActiveViewModel.Competition? = nil
    
    init(viewModel: ActiveViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 50) {
                Text("Active")
                    .padding()
                    .background(Color(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor))
                    .font(.largeTitle)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                
                VStack {
                    Text("Currently activated")
                    
                    ScrollView {
                        if viewModel.activeCompetitions.isEmpty {
                            Text("Oops! Nothing to show.")
                        } else {
                            ForEach(viewModel.parseCompetitions(array: viewModel.activeCompetitions).sorted(by: {$0.name < $1.name}), id: \.self) { competition in
                                Button(
                                    action: {
                                        self.selectedToDeactivateCompetition = competition
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
                    .sheet(item: self.$selectedToDeactivateCompetition, content: { selectedToDeactivateCompetition in
                        OrganizerActiveButtonView(viewModel: viewModel, currentCompetition: selectedToDeactivateCompetition)
                    })
                }
                
                VStack {
                    Text("Deactivated")
                    
                    ScrollView {
                        if viewModel.deactivatedCompetitions.isEmpty {
                            Text("Oops! Nothing to show.")
                        } else {
                            ForEach(viewModel.parseCompetitions(array: viewModel.deactivatedCompetitions).sorted(by: {$0.name < $1.name}), id: \.self) { competition in
                                Button(
                                    action: {
                                        self.selectedToActivateCompetition = competition
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
                    .sheet(item: self.$selectedToActivateCompetition, content: { selectedToActivateCompetition in
                        OrganizerDeactivedButtonView(viewModel: viewModel, currentCompetition: selectedToActivateCompetition)
                    })
                }
            }
            
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color(cgColor: UIColor(red: 0, green: 0.098, blue: 0.659, alpha: 1).cgColor))
                        .frame(width: 450, height: 21)
                    
                    HStack(spacing: 50) {
                        Text("     ")
                        
                        Image("LapItLogo")
                            .resizable()
                            .frame(width: 109, height: 87, alignment: .center)
                        
                        Button(
                            action: {
                                viewModel.route(to: .organizerHome)
                            },
                            label: {
                                Text(">>")
                                    .frame(alignment: .center)
                                    .foregroundColor(.white)
                                    .bold()
                            })
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .background(Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).ignoresSafeArea())
        .onAppear {
            viewModel.getDetails()
        }
    }
}
