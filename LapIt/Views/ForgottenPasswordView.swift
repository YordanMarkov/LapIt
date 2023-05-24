//
//  ForgottenPasswordView.swift
//  LapIt
//
//  Created by Yordan Markov on 24.05.23.
//

import Foundation
import SwiftUI

struct ForgottenPasswordView: View {
    @ObservedObject private var viewModel: LogInViewModel
    @State private var showAlertForChange = false
    @State private var showingLoadingScreen = false
    
    init(viewModel: LogInViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            Image("Question")
                .resizable()
                .frame(width: 250, height: 250)
            
            Text("Type your email in order to receive a pasword reset. Check your Spam folder if it is not showing in the Inbox directory.")
                .frame(alignment: .center)
            
            TextField("Email", text: $viewModel.emailForChange)
                .keyboardType(.emailAddress)
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
                LoadingScreenView()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).ignoresSafeArea())
    }
}
