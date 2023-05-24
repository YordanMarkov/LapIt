//
//  RegisterView.swift
//  LapIt
//
//  Created by Yordan Markov on 14.01.23.
//
import Foundation
import SwiftUI

struct RegisterView: View {
    
    @ObservedObject private var viewModel: RegisterViewModel
    @State private var showAlert = false
    @State private var showingLoadingScreen = false
    
    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
    }
    
    
    var body: some View {
        VStack {
            Text("Setting up")
                .padding()
                .background(Color(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor))
                .font(.largeTitle)
                .cornerRadius(10)
                .foregroundColor(.white)
            
            VStack(spacing: 20) {
                Group {
                    Toggle(isOn: $viewModel.isOrganizer, label: {
                        Text("Organizer account")
                            .padding()
                            .background(Color(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    })
                    .padding()
                    .toggleStyle(SwitchToggleStyle(tint: Color(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor)))
                    
                    TextField("First Name", text: $viewModel.firstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Second Name", text: $viewModel.secondName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("E-mail", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                    
                    HStack {
                        if viewModel.secured1 {
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
                                viewModel.secured1.toggle()
                            },
                            label: {
                                Image(systemName: self.viewModel.secured1 ? "eye.slash" : "eye")
                                    .accentColor(.black)
                            })
                    }
                    
                    HStack {
                        if viewModel.secured2 {
                            SecureField("Repeat Password", text: $viewModel.repeatPassword)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        } else {
                            TextField("Repeat Password", text: $viewModel.repeatPassword)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        Button(
                            action: {
                                viewModel.secured2.toggle()
                            },
                            label: {
                                Image(systemName: self.viewModel.secured2 ? "eye.slash" : "eye")
                                    .accentColor(.black)
                            })
                    }
                    
                    if viewModel.repeatPassword != viewModel.password {
                        Text("The passwords must match!")
                            .foregroundColor(.red)
                    } else if viewModel.password.count < 6 && !viewModel.password.isEmpty {
                        Text("The password must be at least 6 characters!")
                            .foregroundColor(.red)
                    }
                    
                    if viewModel.firstName.isEmpty || viewModel.secondName.isEmpty || viewModel.email.isEmpty || viewModel.password.isEmpty {
                        Text("Filling the fields is required!")
                            .foregroundColor(.red)
                    }
                }
            }
            .padding()
            
            Spacer()
            
            ZStack {
                Rectangle()
                    .fill(Color(cgColor: UIColor(red: 0, green: 0.098, blue: 0.659, alpha: 1).cgColor))
                    .frame(width: 450, height: 21)
                HStack(spacing: 20) {
                    
                    Button(
                        action: {
                            viewModel.route(to: .login)
                        },
                        label: {
                            Text("<<")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .bold()
                                .offset(x: -10)
                        })
                    .buttonStyle(.plain)
                    
                    Image("LapItLogo")
                        .resizable()
                        .frame(width: 109, height: 87)
                        .offset(x: 20)
                    
                    if !viewModel.firstName.isEmpty && !viewModel.secondName.isEmpty && !viewModel.email.isEmpty && !viewModel.password.isEmpty && !viewModel.repeatPassword.isEmpty && viewModel.repeatPassword == viewModel.password && viewModel.password.count >= 6 {
                        Button(
                            action: {
                                viewModel.register()
                                self.showingLoadingScreen = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    if viewModel.registerSuccess {
                                        viewModel.route(to: .login)
                                        self.showingLoadingScreen = false
                                    } else {
                                        self.showingLoadingScreen = false
                                        showAlert.toggle()
                                    }
                                }
                            },
                            label: {
                                Text("Register")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                    .bold()
                                    .offset(x: 30)
                            })
                        .buttonStyle(.plain)
                        .alert(isPresented: $showAlert) {
                            Alert (
                                title: Text(viewModel.error),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    } else {
                        Text("Disabled")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .bold()
                            .offset(x: 30)
                    }
                }
            }
            .offset(y: -28)
            
        }
        .overlay {
            if showingLoadingScreen {
                LoadingScreenView()
            }
        }
        .background(Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).ignoresSafeArea())
    }
}
