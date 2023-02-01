//
//  LibraryView.swift
//  LapIt
//
//  Created by Yordan Markov on 26.01.23.
//

import Foundation
import SwiftUI

struct CreateView: View {
    @ObservedObject private var viewModel: LibraryViewModel
    
    init(viewModel: LibraryViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Details")
                .padding()
                .background(Color(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor))
                .font(.largeTitle)
                .cornerRadius(10)
                .foregroundColor(.white)
            
            TextField("Name", text: $viewModel.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Desription", text: $viewModel.description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Picker(selection: $viewModel.distanceOrTime, label: Text("Please select an option")) {
                Text("Rank by distance").tag(0)
                Text("Rank by time").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            if !viewModel.description.isEmpty && !viewModel.name.isEmpty {
                Button(
                    action: {
                        viewModel.create()
                        viewModel.createView = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            viewModel.getDetails()
                        }
                    },
                    label: {
                        Text("Activate")
                            .frame(width: 100 , height: 30, alignment: .center)
                    })
                .buttonStyle(.borderedProminent)
                //                .position(x: 205, y: 600)
                .foregroundColor(.white)
                .tint(.green)
            }
            
            
        }.padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).edgesIgnoringSafeArea(.vertical))
    }
}

struct LibraryView: View {
    @ObservedObject private var viewModel: LibraryViewModel
    
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
                //                .frame(width: 400)
                //                .position(x: 205, y: 100)
                VStack {
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
            }
            
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color(cgColor: UIColor(red: 0, green: 0.098, blue: 0.659, alpha: 1).cgColor))
                        .frame(width: 450, height: 21)
                    //                    .position(x: 205, y: 700)
                    HStack(spacing: 50) {
                        Button(
                            action: {
                                viewModel.route(to: .organizerHome)
                            },
                            
                            
                            label: {
                                Text(" <<    ")
                                    .frame(alignment: .center)
                                    .foregroundColor(.white)
                                    .bold()
                            })
                        .buttonStyle(.plain)
                        //                .position(x: 330, y: 700)
                        Image("LapItLogo")
                            .resizable()
                            .frame(width: 109, height: 87, alignment: .center)
                        //                    .position(x: 205, y: 700)
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
                            CreateView(viewModel: viewModel)
                        }
                    }
                }
            }
        }.background(Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).edgesIgnoringSafeArea(.vertical))
            .onAppear {
                viewModel.getDetails()
            }
    }
}


