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
    @Published public var email: String = ""
    @Published public var password: String = ""
    @Published public var secured: Bool = true
    @Published public var error = ""
    
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
        self.error = ""
        Task {
            do {
                try await network.SignIn(email: self.email, password: self.password)
            } catch {
                self.error = error.localizedDescription
            }
        }
    }
}
