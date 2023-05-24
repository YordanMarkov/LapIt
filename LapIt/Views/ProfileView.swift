//
//  ProfileView.swift
//  LapIt
//
//  Created by Yordan Markov on 23.05.23.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    
    @State private var showAlert = false
    @State private var showDeleteAlert = false
    
    @State private var firstName: String
    @State private var secondName: String
    
    @ObservedObject private var viewModel: BaseHomeViewModel
    
    init(viewModel: DefaultHomeViewModel) {
        self.viewModel = viewModel
        self.firstName = viewModel.firstName
        self.secondName = viewModel.secondName
    }
    
    init(viewModel: OrganizerHomeViewModel) {
        self.viewModel = viewModel
        self.firstName = viewModel.firstName
        self.secondName = viewModel.secondName
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel is DefaultHomeViewModel ? "Profile" : "Organizer Profile")
                .padding()
                .background(Color(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor))
                .font(.largeTitle)
                .cornerRadius(10)
                .foregroundColor(.white)

            
            VStack {
                Text("First Name: ")
                TextField("", text: $firstName)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            VStack {
                Text("Second Name: ")
                TextField("", text: $secondName)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Text("Email: " + viewModel.email)
            
            if(firstName != viewModel.firstName || secondName != viewModel.secondName) {
                Button(
                    action: {
                        viewModel.save(firstName: firstName, secondName: secondName)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            viewModel.getDetails()
                        }
                    },
                    label: {
                        Text("Save")
                            .frame(width: 100 , height: 30, alignment: .center)
                    })
                .buttonStyle(.borderedProminent)
                .foregroundColor(.white)
                .tint(.init(.green))
            }
            
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
            
            Button(
                action: {
                    showDeleteAlert = true
                },
                label: {
                    Text("Delete account")
                        .frame(width: 155 , height: 30, alignment: .center)
                }).alert(isPresented: $showDeleteAlert) {
                    Alert (
                        title: Text("You are about to delete your account. This will delete all of your stats and history. This action is irreversible. Continue?"),
                        primaryButton: .default(Text("Yes")) {
                            viewModel.profileView = false
                            viewModel.deleteAccount()
                            viewModel.route(to: .login)
                        },
                        secondaryButton: .cancel()
                    )
                }
            .buttonStyle(.borderedProminent)
            .foregroundColor(.white)
            .tint(.init(.yellow))
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).ignoresSafeArea())
    }
}
