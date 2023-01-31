//
//  SignIn.swift
//  LapIt
//
//  Created by Yordan Markov on 14.01.23.
//

import Foundation
import SwiftUI

class LogInViewModel: ObservableObject {
    @Published public var isLoggedIn = false
    @Published public var forgottenPassword = false
    @Published public var errorForChange = ""
    @Published public var emailForChange = ""
    @Published public var email: String = ""
    @Published public var password: String = ""
    @Published public var secured: Bool = true
    @Published public var error = ""
    @Published public var signInSuccess = false
    @Published public var sendEmailSuccess = false
    @Published public var stateForHome = -1
    
    private let network: Network
    private unowned let coordinator: Coordinator
    
    init(network: Network, coordinator: Coordinator) {
        self.network = network
        self.coordinator = coordinator
    }
    
    func route(to newTab: Coordinator.Tab) {
        coordinator.route(to: newTab)
    }
    
    func signIn() {
        Task {
            do {
                DispatchQueue.main.async {
                    self.error = ""
                    self.signInSuccess = true
                }
                try await network.signIn(email: self.email, password: self.password)
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                    self.signInSuccess = false
                }
            }
        }
    }
    
    func forgottenPasswordByEmail() {
        Task {
            do {
                DispatchQueue.main.async {
                    self.errorForChange = ""
                    self.sendEmailSuccess = true
                }
                try await network.sendPasswordReset(email: self.emailForChange)
            } catch {
                DispatchQueue.main.async {
                    self.errorForChange = error.localizedDescription
                    self.sendEmailSuccess = false
                }
            }
        }
    }
    
    func getIsOrganizer() {
        self.stateForHome = -1
        let userData = network.getUserData(email: self.email)
        if let isOrganizer = userData["isOrganizer"] as? Bool {
            if isOrganizer == true {
                self.stateForHome = 1
            } else if isOrganizer == false {
                self.stateForHome = 0
            }
        }
    }
}
