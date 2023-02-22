//
//  StatsView.swift
//  LapIt
//
//  Created by Yordan Markov on 26.01.23.
//

import Foundation
import SwiftUI

struct StatsView: View {
    @ObservedObject private var viewModel: StatsViewModel
    
    init(viewModel: StatsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack (spacing: 200) {
            VStack(spacing: 50) {
                Text("Stats")
                    .padding()
                    .background(Color(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor))
                    .font(.largeTitle)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                
                HStack {
                    Text("Total kilometers")
                        .padding()
                        .background(Color(.blue))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    
                    Text("\(viewModel.km)")
                        .padding()
                        .background(Color(.red))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }.padding()
                
                HStack {
                    Text("Total minutes")
                        .padding()
                        .background(Color(.blue))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    
                    Text("\(viewModel.min)")
                        .padding()
                        .background(Color(.red))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }.padding()
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
                                viewModel.route(to: .defaultHome)
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).ignoresSafeArea())
        .onAppear {
            viewModel.getDetails()
        }
    }
}
