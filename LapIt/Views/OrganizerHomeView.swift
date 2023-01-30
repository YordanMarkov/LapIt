//
//  OrganizerHomeView.swift
//  LapIt
//
//  Created by Yordan Markov on 25.01.23.
//

import Foundation
import SwiftUI

struct ProfileViewO: View {
    
    @State private var showAlert = false
    
    @ObservedObject private var viewModel: OrganizerHomeViewModel
    
    init(viewModel: OrganizerHomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).ignoresSafeArea()
            Text("Profile - Organizer")
                .padding()
                .background(Color(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor))
                .font(.largeTitle)
                .cornerRadius(10)
                .foregroundColor(.white)
                .frame(width: 400)
                .position(x: 205, y: 100)
            Button(
                action: {
                    showAlert = true
                },
                label: {
                    Text("Sign out")
                        .frame(width: 100 , height: 30, alignment: .center)
                }).alert(isPresented: $showAlert) {
                    Alert (
                        title: Text("You are about to sign out. Continue?"),
                        primaryButton: .default(Text("Yes")) {
                            viewModel.profileView = false
                            viewModel.signOut()
                            viewModel.route(to: .login)
                        },
                        secondaryButton: .cancel()
                    )
                }
            .buttonStyle(.borderedProminent)
            .foregroundColor(.white)
            .tint(.init(.red))
            .position(x: 205, y: 500)
        }
    }
}


struct OrganizerHomeView: View {
    
    @ObservedObject private var viewModel: OrganizerHomeViewModel
    
    init(viewModel: OrganizerHomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).ignoresSafeArea()
            Text("Competitions")
                .padding()
                .background(Color(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor))
                .font(.largeTitle)
                .cornerRadius(10)
                .foregroundColor(.white)
                .frame(width: 400)
                .position(x: 205, y: 100)
            
            ScrollView {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(width: 350, height: 75)
                    Text("Competition 1")
                        .foregroundColor(.black)
                }.position(x: 205, y: 200)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(width: 350, height: 75)
                    Text("Competition 2")
                        .foregroundColor(.black)
                }.position(x: 205, y: 200)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(width: 350, height: 75)
                    Text("Competition 3")
                        .foregroundColor(.black)
                }.position(x: 205, y: 200)
            }
            
            
            // Navigator
            ZStack {
                Text("Profile")
                .frame(width: 100 , height: 30, alignment: .center)
                .position(x: 205, y: 760)
                Rectangle()
                    .fill(Color(cgColor: UIColor(red: 0, green: 0.098, blue: 0.659, alpha: 1).cgColor))
                    .frame(width: 450, height: 21)
                    .position(x: 205, y: 700)
                
                Button(
                    action: {
                        viewModel.route(to: .library)
                    },
                    label: {
                        Text("Library")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .bold()
                    })
                .buttonStyle(.plain)
                .position(x: 330, y: 700)
                
                Button(
                    action: {
                        viewModel.route(to: .active)
                    },
                    label: {
                        Text("Active")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .bold()
                    })
                .buttonStyle(.plain)
                .position(x: 65, y: 700)
                
                Button(action: {
                    viewModel.profileView = true
                    }, label: {
                        Image("LapItLogo")
                            .resizable()
                            .frame(width: 109, height: 87)
                            .position(x: 205, y: 700)
                    }
                ).sheet(isPresented: $viewModel.profileView) {
                    ProfileViewO(viewModel: viewModel)
                }
            }
        }
    }
}
