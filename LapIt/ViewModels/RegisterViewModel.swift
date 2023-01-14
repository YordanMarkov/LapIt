//
//  SingUpViewModel.swift
//  LapIt
//
//  Created by Yordan Markov on 14.01.23.
//

import Foundation
import SwiftUI

class RegisterViewModel: ObservableObject {
    @Published public var email: String = ""
    @Published public var password: String = ""
    @Published public var repeatPassword: String = ""
    @Published public var secured1: Bool = true
    @Published public var secured2: Bool = true
    
    private let network: Network
    private unowned let coordinator: Coordinator
    
    init(network: Network, coordinator: Coordinator) {
        self.network = network
        self.coordinator = coordinator
    }
    
    func route(to newTab: Coordinator.Tab) {
        coordinator.route(to: newTab)
    }
    
//    func signUp() {
//        // Posredvstom informaciqta v tozi viewModel signUp-ni nqkoj
//        network.register()
//    }
}
