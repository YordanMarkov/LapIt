//
//  LibraryView.swift
//  LapIt
//
//  Created by Yordan Markov on 26.01.23.
//

import Foundation
import SwiftUI

struct LibraryView: View {
    @State private var showComp = false
    @ObservedObject private var viewModel: LibraryViewModel
    @State private var showAlert = false
    @State private var showDeletionAlert = false
    @State private var selectedCompetition: LibraryViewModel.Competition? = nil
    
    init(viewModel: LibraryViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 50) {
                Text("Library")
                    .padding()
                    .background(Color(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor))
                    .font(.largeTitle)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                VStack {
                    ScrollView {
                        if viewModel.competitions.isEmpty {
                            Text("Oops! Nothing to show.")
                        } else {
                            ForEach(viewModel.parseCompetitions().sorted(by: {$0.name < $1.name}), id: \.self) { competition in
                                HStack {
                                    Button(
                                        action: {
                                            self.selectedCompetition = competition
                                            self.showAlert = true
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
                                    .alert(isPresented: $showAlert) {
                                        Alert (
                                            title: Text("Do you want to reuse this model?"),
                                            primaryButton: .default(Text("Yes")) {
                                                viewModel.reuse = true
                                            },
                                            secondaryButton: .cancel()
                                        )
                                    }
                                    .sheet(isPresented: $viewModel.reuse) {
                                        CreateView(viewModel: viewModel, currentCompetition: LibraryViewModel.Competition(id: "", name: selectedCompetition?.name ?? "", description: selectedCompetition?.description ?? "", distanceOrTime: selectedCompetition?.distanceOrTime ?? 0, isActive: true))
                                    }
                                    
                                    Button(action: {
                                        self.selectedCompetition = competition
                                        self.showDeletionAlert = true
                                    },
                                           label: {
                                        Image("Delete")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    })
                                    .alert(isPresented: $showDeletionAlert) {
                                        Alert (
                                            title: Text("Do you want to delete this competition? Warning: This will also delete its history and activity! "),
                                            primaryButton: .default(Text("Yes")) {
                                                viewModel.delete(competition: selectedCompetition ?? nil)
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                    viewModel.getDetails()
                                                }
                                            },
                                            secondaryButton: .cancel()
                                        )
                                    }
                                }
                            }
                        }
                    }
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
                                viewModel.route(to: .organizerHome)
                            },
                            label: {
                                Text("<<")
                                    .frame(alignment: .center)
                                    .foregroundColor(.white)
                                    .bold()
                                    .offset(x: 10)
                            })
                        .buttonStyle(.plain)
                        
                        Image("LapItLogo")
                            .resizable()
                            .frame(width: 109, height: 87, alignment: .center)
                            .offset(x: 16)
                        
                        Button(
                            action: {
                                viewModel.createView = true
                            },
                            label: {
                                Text("Create")
                                    .frame(alignment: .center)
                                    .foregroundColor(.white)
                                    .bold()
                            })
                        .buttonStyle(.plain)
                        .sheet(isPresented: $viewModel.createView) {
                            CreateView(viewModel: viewModel, currentCompetition: LibraryViewModel.Competition(id: "", name: "", description: "", distanceOrTime: 0, isActive: true))
                        }
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
