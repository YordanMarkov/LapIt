//
//  StatsViewModel.swift
//  LapIt
//
//  Created by Yordan Markov on 26.01.23.
//

import Foundation
import SwiftUI

class StatsViewModel: ObservableObject {
    @Published public var km = 0
    @Published public var min = 0
    @Published public var email = ""
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
    
    func getDetails() {
        Task {
            do {
                let email = try await network.getCurrentUserEmail()
                let km = try await network.getUserKm(email: self.email)
                let min = try await network.getUserMin(email: self.email)
                DispatchQueue.main.async {
                    self.email = email
                    self.km = km
                    self.min = min
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                }
            }
        }
    }
}
