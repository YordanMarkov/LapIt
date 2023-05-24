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
        VStack (spacing: 150) {
            VStack(spacing: 100) {
                Text("Stats")
                    .padding()
                    .background(Color(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor))
                    .font(.largeTitle)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .offset(x: 6, y: -50)
                
                
                VStack(spacing: 100) {
                    HStack(spacing: 50) {
                        Text("Total kilometers")
                            .padding()
                            .foregroundColor(.black)
                            .font(.system(size: 25))
                        
                        Text("\(viewModel.km, specifier: "%.2f")")
                            .padding()
                            .background(
                                Circle()
                                    .fill(.white)
                                    .frame(width: 90, height: 90)
                                    .background(
                                        Circle()
                                            .fill(Color(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor))
                                            .frame(width: 120, height: 120)
                                            
                                    )
                            )
                            .foregroundColor(.black)
                    }
                    
                    HStack(spacing: 50) {
                        Text("\(viewModel.min, specifier: "%.2f")")
                            .padding()
                            .background(
                                Circle()
                                    .fill(.white)
                                    .frame(width: 90, height: 90)
                                    .background(
                                        Circle()
                                            .fill(Color(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor))
                                            .frame(width: 120, height: 120)
                                            
                                    )
                            )
                            .foregroundColor(.black)
                        
                        Text("Total minutes")
                            .padding()
                            .foregroundColor(.black)
                            .font(.system(size: 25))
                    }
                }
            }
            .offset(x: -7, y: 15)
            
            ZStack {
                Rectangle()
                    .fill(Color(cgColor: UIColor(red: 0, green: 0.098, blue: 0.659, alpha: 1).cgColor))
                    .frame(width: 450, height: 21)
                
                HStack(spacing: 50) {
                    
                    Image("LapItLogo")
                        .resizable()
                        .frame(width: 109, height: 87, alignment: .center)
                        .offset(x: 36)
    
                    Button(
                        action: {
                            viewModel.route(to: .defaultHome)
                        },
                        label: {
                            Text(">>")
                                .frame(alignment: .center)
                                .foregroundColor(.white)
                                .bold()
                                .offset(x: 36)
                        })
                    .buttonStyle(.plain)
                }
            }
            .offset(y: 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).ignoresSafeArea())
        .onAppear {
            viewModel.getDetails()
        }
    }
}
