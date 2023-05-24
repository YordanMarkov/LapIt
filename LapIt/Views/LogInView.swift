//
//  LogInVieww.swift
//  LapIt
//
//  Created by Yordan Markov on 14.01.23.
//

import Foundation
import SwiftUI

struct LogInView: View {
    
    @State private var showAlert = false
    
    @ObservedObject private var viewModel: LogInViewModel
    
    @State private var showingLoadingScreen = false
    
    init(viewModel: LogInViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 30) {
            
            Image("LapItLogo")
                .resizable()
                .frame(width: 218, height: 174)
            
            VStack (spacing: 10) {
                TextField("Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                
                HStack {
                    if viewModel.secured {
                        SecureField("Password", text: $viewModel.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                    } else {
                        TextField("Password", text: $viewModel.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                    }
                    
                    Button(
                        action: {
                            viewModel.secured.toggle()
                        }) {
                            Image(systemName: self.viewModel.secured ? "eye.slash" : "eye")
                                .accentColor(.black)
                        }
                }
            }
            
            Button(action: {
                viewModel.forgottenPassword = true
            },
                   label: {
                Text("I forgot my password.")
            }
            )
            .buttonStyle(.plain)
            .underline()
            .sheet(isPresented: $viewModel.forgottenPassword) {
                ForgottenPasswordView(viewModel: viewModel)
            }

            Button(
                action: {
                    viewModel.route(to: .register)
                },
                label: {
                    Text("Don't have an accout?\nRegister here.")
                        .multilineTextAlignment(.center)
                        .underline()
                })
            .buttonStyle(.plain)

            if viewModel.email.isEmpty || viewModel.password.isEmpty {
                Text("Filling the fields is required!")
                    .foregroundColor(.red)
            } else {
                Button(
                    action: {
                        viewModel.signIn()
                        viewModel.getUserOrganizerStatus()
                        self.showingLoadingScreen = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            if viewModel.signInSuccess {
                                if viewModel.isOrganizer == true {
                                    viewModel.route(to: .organizerHome)
                                } else if viewModel.isOrganizer == false {
                                    viewModel.route(to: .defaultHome)
                                }
                                self.showingLoadingScreen = false
                            } else {
                                self.showingLoadingScreen = false
                                showAlert.toggle()
                            }
                        }
                    },
                    label: {
                        Text("Log in")
                            .frame(width: 100 , height: 30, alignment: .center)
                    })
                .alert(isPresented: $showAlert) {
                        Alert (
                            title: Text(viewModel.error),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                .buttonStyle(.borderedProminent)
                .foregroundColor(.white)
                .tint(.init(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor))
            }
        }
        .overlay {
            if showingLoadingScreen {
                LoadingScreenView()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).ignoresSafeArea())
    }
}
