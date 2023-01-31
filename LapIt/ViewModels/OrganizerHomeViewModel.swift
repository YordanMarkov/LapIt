//
//  OrganizerHomeViewModel.swift
//  LapIt
//
//  Created by Yordan Markov on 25.01.23.
//

import Foundation
import SwiftUI

class OrganizerHomeViewModel: ObservableObject {
    private let network: Network
    private unowned let coordinator: Coordinator
    @Published public var userFullName = ""
    @Published public var profileView = false
    
    init(network: Network, coordinator: Coordinator) {
        self.network = network
        self.coordinator = coordinator
    }
    
    func route(to newTab: Coordinator.Tab) {
        coordinator.route(to: newTab)
    }
    
    func signOut() {
        network.signOut()
    }
}