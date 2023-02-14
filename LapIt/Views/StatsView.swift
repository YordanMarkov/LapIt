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
                //                .frame(width: 400)
                //                .position(x: 205, y: 100)
                
                HStack {
                    Text("Total kilometers")
                        .padding()
                        .background(Color(.blue))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    //                .frame(width: 400)
                    //                .position(x: 150, y: 300)
                    Text("\(viewModel.km)")
                        .padding()
                        .background(Color(.red))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    //                .frame(width: 400)
                    //                .position(x: 305, y: 300)
                }.padding()
                
                HStack {
                    Text("Total minutes")
                        .padding()
                        .background(Color(.blue))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    //                    .frame(width: 400)
                    //                    .position(x: 150, y: 400)
                    Text("\(viewModel.min)")
                        .padding()
                        .background(Color(.red))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    //                    .frame(width: 400)
                    //                    .position(x: 305, y: 400)
                }.padding()
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
                                viewModel.route(to: .defaultHome)
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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor)
            .edgesIgnoringSafeArea(.vertical))
        .onAppear {
            viewModel.getDetails()
        }
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
////        LogInView(viewModel: LogInViewModel(network: Network(), coordinator: Coordinator()))
////        RegisterView(viewModel: RegisterViewModel(network: Network(), coordinator: Coordinator()))
//        StatsView(viewModel: StatsViewModel(network: Network(), coordinator: Coordinator()))
//    }
//}
