//
//  SignIn.swift
//  LapIt
//
//  Created by Yordan Markov on 14.01.23.
//

import Foundation
import SwiftUI

class LogInViewModel: ObservableObject {
    @Published public var forgottenPassword = false
    @Published public var errorForChange = ""
    @Published public var emailForChange = ""
    @Published public var email = ""
    @Published public var password = ""
    @Published public var secured = true
    @Published public var error = ""
    @Published public var signInSuccess = false
    @Published public var sendEmailSuccess = false
    @Published public var isOrganizer = false
    @Published public var isOrganizerError = ""
    
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
    
    func getUserOrganizerStatus() {
        Task {
            do {
                DispatchQueue.main.async {
                    self.isOrganizerError = ""
                }
                let user = try await network.getUserOrganizerStatus(email: self.email)
                DispatchQueue.main.async {
                    self.isOrganizer = user
                }
            } catch {
                DispatchQueue.main.async {
                    self.isOrganizerError = error.localizedDescription
                }
            }
        }
    }
}
