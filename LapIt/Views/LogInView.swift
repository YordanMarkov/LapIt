//
//  LogInVieww.swift
//  LapIt
//
//  Created by Yordan Markov on 14.01.23.
//

import Foundation
import SwiftUI

struct LoadingScreen: View {
    var body: some View {
        VStack {
            Image("LapItLogo")
                .resizable()
                .frame(width: 218, height: 174)
            
            Text("Loading...")
                .padding()
                .background(Color(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor))
                .font(.largeTitle)
                .cornerRadius(10)
                .foregroundColor(.white)
                .frame(width: 400)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).ignoresSafeArea())
    }
}

struct ForgottenPassword: View {
    @ObservedObject private var viewModel: LogInViewModel
    @State private var showAlertForChange = false
    @State private var showingLoadingScreen = false
    
    init(viewModel: LogInViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Type your email in order to change your password.")
                .frame(alignment: .center)
            
            TextField("Email", text: $viewModel.emailForChange)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            
            if !viewModel.emailForChange.isEmpty {
                Button(
                    action: {
                        viewModel.forgottenPasswordByEmail()
                        self.showingLoadingScreen = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            if viewModel.sendEmailSuccess {
                                viewModel.forgottenPassword = false
                                self.showingLoadingScreen = false
                                
                            } else {
                                self.showingLoadingScreen = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    showAlertForChange.toggle()
                                }
                            }
                        }
                    },
                    label: {
                        Text("Send")
                            .frame(width: 100 , height: 30, alignment: .center)
                    }).alert(isPresented: $showAlertForChange) {
                        Alert (
                            title: Text(viewModel.errorForChange),
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
                LoadingScreen()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).ignoresSafeArea())
    }
}

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
                ForgottenPassword(viewModel: viewModel)
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
                LoadingScreen()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).ignoresSafeArea())
    }
}
