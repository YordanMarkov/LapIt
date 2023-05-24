//
//  SingUpViewModel.swift
//  LapIt
//
//  Created by Yordan Markov on 14.01.23.
//

import Foundation
import SwiftUI

class RegisterViewModel: ObservableObject {
    @Published public var email = ""
    @Published public var password = ""
    @Published public var repeatPassword = ""
    @Published public var secured1 = true
    @Published public var secured2 = true
    @Published public var firstName = ""
    @Published public var secondName = ""
    @Published public var isOrganizer = false
    @Published public var error = ""
    @Published public var registerSuccess = false
    
    private let network: Network
    private unowned let coordinator: Coordinator
    
    init(network: Network, coordinator: Coordinator) {
        self.network = network
        self.coordinator = coordinator
    }
    
    func route(to newTab: Coordinator.Tab) {
        coordinator.route(to: newTab)
    }
    
    func register() {
        Task {
            do {
                DispatchQueue.main.async {
                    self.error = ""
                    self.registerSuccess = true
                }
                try await network.register(email: self.email, password: self.password, firstName: self.firstName, secondName: self.secondName, isOrganizer: self.isOrganizer)
            }  catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                    self.registerSuccess = false
                }
            }
        }
    }
}
