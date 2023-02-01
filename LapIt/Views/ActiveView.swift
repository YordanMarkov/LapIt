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
                //                .frame(width: 400)
                //                .position(x: 205, y: 100)
                VStack {
                    Text("Currently activated")
                    ScrollView {
                        if viewModel.activeCompetitions.isEmpty {
                            Text("Oops! Nothing to show.")
                        } else {
                            ForEach(viewModel.parseCompetitions(array: viewModel.activeCompetitions).sorted(by: {$0.name < $1.name}), id: \.self) { competition in
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
                    Text("Deactivated")
                    ScrollView {
                        if viewModel.deactivatedCompetitions.isEmpty {
                            Text("Oops! Nothing to show.")
                        } else {
                            ForEach(viewModel.parseCompetitions(array: viewModel.deactivatedCompetitions).sorted(by: {$0.name < $1.name}), id: \.self) { competition in
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
            }
            
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color(cgColor: UIColor(red: 0, green: 0.098, blue: 0.659, alpha: 1).cgColor))
                        .frame(width: 450, height: 21)
                    //                    .position(x: 205, y: 700)
                    HStack(spacing: 50) {
                        Text("     ")
                        Image("LapItLogo")
                            .resizable()
                            .frame(width: 109, height: 87, alignment: .center)
                        //                    .position(x: 205, y: 700)
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
                        //                .position(x: 330, y: 700)
                    }
                }
            }
        }.background(Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).edgesIgnoringSafeArea(.vertical))
            .onAppear {
                viewModel.getDetails()
            }
    }
}
