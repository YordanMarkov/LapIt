//
//  SignIn.swift
//  LapIt
//
//  Created by Yordan Markov on 14.01.23.
//

import Foundation
import SwiftUI

class LogInViewModel: ObservableObject {
    @State public var isLoggedIn = false
    @State public var email: String = ""
    @State public var password: String = ""
    @State public var secured: Bool = true
    
    private let network: Network
    private unowned let coordinator: Coordinator
    
    init(network: Network, coordinator: Coordinator) {
        self.network = network
        self.coordinator = coordinator
    }
    
//    func signUp() {
//        // Posredvstom informaciqta v tozi viewModel signUp-ni nqkoj
//        network.login()
//    }
    func route(to newTab: Coordinator.Tab) {
        coordinator.route(to: newTab)
    }
}
