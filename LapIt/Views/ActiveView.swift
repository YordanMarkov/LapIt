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
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: 350, height: 75)
                            Text("Competition 1")
                                .foregroundColor(.black)
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: 350, height: 75)
                            Text("Competition 2")
                                .foregroundColor(.black)
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: 350, height: 75)
                            Text("Competition 3")
                                .foregroundColor(.black)
                        }
                    }
                }
                
                VStack {
                    Text("Deactivated")
                    ScrollView {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: 350, height: 75)
                            Text("Competition 1")
                                .foregroundColor(.black)
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: 350, height: 75)
                            Text("Competition 2")
                                .foregroundColor(.black)
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: 350, height: 75)
                            Text("Competition 3")
                                .foregroundColor(.black)
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
    }
}
