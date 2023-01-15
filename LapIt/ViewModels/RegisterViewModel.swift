//
//  SingUpViewModel.swift
//  LapIt
//
//  Created by Yordan Markov on 14.01.23.
//

import Foundation
import SwiftUI

class RegisterViewModel: ObservableObject {
    // Short the types
    @Published public var email: String = ""
    @Published public var password: String = ""
    @Published public var repeatPassword: String = ""
    @Published public var secured1: Bool = true
    @Published public var secured2: Bool = true
    @Published public var firstName: String = ""
    @Published public var secondName: String = ""
    @Published public var isOrganizer: Bool = false
    @Published private(set) var error = ""
    
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
                try await network.Register(email: self.email, password: self.password, firstName: self.firstName, secondName: self.secondName, isOrganizer: self.isOrganizer)
            }  catch {
                self.error = error.localizedDescription
            }
        }
    }
}
