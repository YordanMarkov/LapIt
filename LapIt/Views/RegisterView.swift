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
    
    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
    }
    
    
    var body: some View {
        VStack {
//            Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).ignoresSafeArea()
            VStack(spacing: 20) {
                Text("Setting up")
                    .padding()
                    .background(Color(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor))
                    .font(.largeTitle)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                //                .frame(width: 400)
                //                .position(x: 205, y: 100)
                
                Group {
                    Toggle(isOn: $viewModel.isOrganizer, label: {
                        Text("Organizer account")
                            .padding()
                            .background(Color(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                        //                        .frame(width: 200)
                    })
                    //                .position(x: 193, y: 220)
                    .padding()
                    .toggleStyle(SwitchToggleStyle(tint: Color(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor)))
                    
                    TextField("First Name", text: $viewModel.firstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    //                    .frame(width: 300, height: 300)
                    //                    .position(x: 205, y: 313)
                    
                    TextField("Second Name", text: $viewModel.secondName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    //                    .frame(width: 300, height: 300)
                    //                    .position(x: 205, y: 375)
                    
                    TextField("E-mail", text: $viewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                    //                    .frame(width: 300, height: 300)
                    //                    .position(x: 205, y: 437)
                    HStack {
                        if viewModel.secured1 {
                            SecureField("Password", text: $viewModel.password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocapitalization(.none)
                            //                            .frame(width: 300, height: 300)
                            //                            .position(x: 205, y: 499)
                        } else {
                            TextField("Password", text: $viewModel.password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocapitalization(.none)
                              
                            //                            .frame(width: 300, height: 300)
                            //                            .position(x: 205, y: 499)
                        }
                        
                        
                        Button( // URL: https://stackoverflow.com/questions/63095851/show-hide-password-how-can-i-add-this-feature
                            action: {
                                viewModel.secured1.toggle()
                            }) {
                                Image(systemName: self.viewModel.secured1 ? "eye.slash" : "eye")
                                    .accentColor(.black)
                            }
                        //                        .position(x: 380, y: 499)
                    }
                    
                    HStack {
                        if viewModel.secured2 {
                            SecureField("Repeat Password", text: $viewModel.repeatPassword)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            //                            .frame(width: 300, height: 300)
                            //                            .position(x: 205, y: 561)
                        } else {
                            TextField("Repeat Password", text: $viewModel.repeatPassword)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            //                            .frame(width: 300, height: 300)
                            //                            .position(x: 205, y: 561)
                        }
                        
                        Button( // URL: https://stackoverflow.com/questions/63095851/show-hide-password-how-can-i-add-this-feature
                            action: {
                                viewModel.secured2.toggle()
                            }) {
                                Image(systemName: self.viewModel.secured2 ? "eye.slash" : "eye")
                                    .accentColor(.black)
                            }
                        //                        .position(x: 380, y: 561)
                    }
                    
                    if viewModel.repeatPassword != viewModel.password {
                        Text("The passwords must match!")
                        //                        .position(x: 205, y: 466)
                            .foregroundColor(.red)
                    } else if viewModel.password.count < 8 && !viewModel.password.isEmpty {
                        Text("The password must be at least 8 characters!")
                        //                        .position(x: 205, y: 466)
                            .foregroundColor(.red)
                    }
                    
                    if viewModel.firstName.isEmpty || viewModel.secondName.isEmpty || viewModel.email.isEmpty || viewModel.password.isEmpty {
                        Text("Filling the fields is required!")
                        //                        .position(x: 205, y: 275)
                            .foregroundColor(.red)
                    }
                }
            }
            .padding()
            
            // Navigator
            ZStack {
                Rectangle()
                    .fill(Color(cgColor: UIColor(red: 0, green: 0.098, blue: 0.659, alpha: 1).cgColor))
                    .frame(width: 450, height: 21)//
                    .position(x: 200, y: 143)//
                if !viewModel.firstName.isEmpty && !viewModel.secondName.isEmpty && !viewModel.email.isEmpty && !viewModel.password.isEmpty && !viewModel.repeatPassword.isEmpty && viewModel.repeatPassword == viewModel.password && viewModel.password.count >= 8 {
                    Button(
                        action: {
                            // Code upcoming
                            viewModel.register()
                            viewModel.route(to: .login)
                        },
                        label: {
                            Text("Register")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .bold()
                        })
                    .buttonStyle(.plain)
                    .position(x: 325, y: 142.5)//
                }
                
                Button(
                    action: {
                        // Go to LogIn
                        viewModel.route(to: .login)
                    },
                    label: {
                        Text("<<")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .bold()
                    })
                .buttonStyle(.plain)
                .position(x: 65, y: 142.5)//
                
                Image("LapItLogo")
                    .resizable()
                    .frame(width: 109, height: 87)
                    .position(x: 200, y: 143)
            }
            
        }
        .background(Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).ignoresSafeArea())
            //.edgesIgnoringSafeArea(.vertical))
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
////        LogInView(viewModel: LogInViewModel(network: Network(), coordinator: Coordinator()))
//        RegisterView(viewModel: RegisterViewModel(network: Network(), coordinator: Coordinator()))
//    }
//}
