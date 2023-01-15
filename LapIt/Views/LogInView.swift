//
//  LogInVieww.swift
//  LapIt
//
//  Created by Yordan Markov on 14.01.23.
//

import Foundation
import SwiftUI

struct LogIn: View {
    
    @ObservedObject private var viewModel: LogInViewModel
    
    init(viewModel: LogInViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).ignoresSafeArea()
            
            Image("LapItLogo")
                .resizable()
                .frame(width: 218, height: 174)
                .position(x: 205, y: 255)
            
            TextField("E-mail", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300, height: 300)
                .position(x: 205, y: 413)
           
            if viewModel.secured {
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300, height: 300)
                    .position(x: 205, y: 475)
            } else {
                TextField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300, height: 300)
                    .position(x: 205, y: 475)
            }
            
            Button( // URL: https://stackoverflow.com/questions/63095851/show-hide-password-how-can-i-add-this-feature
                action: {
                    viewModel.secured.toggle()
                }) {
                    Image(systemName: self.viewModel.secured ? "eye.slash" : "eye")
                        .accentColor(.black)
            }
                .position(x: 380, y: 475)
            
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
            .position(x: 205, y: 540)
            
            if viewModel.email.isEmpty || viewModel.password.isEmpty {
                Text("Fields are required!")
                    .position(x: 205, y: 370)
                    .foregroundColor(.red)
            } else {
                Button(
                    action: {
                        // Code upcoming
                    },
                    label: {
                        Text("Log in")
                            .frame(width: 100 , height: 30, alignment: .center)
                    })
                .buttonStyle(.borderedProminent)
                .position(x: 205, y: 600)
                .foregroundColor(.white)
                .tint(.init(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor))
            }
        }
    }
}
