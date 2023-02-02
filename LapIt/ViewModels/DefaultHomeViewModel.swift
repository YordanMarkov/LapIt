//
//  HomeViewModel.swift
//  LapIt
//
//  Created by Yordan Markov on 14.01.23.
//

import Foundation
import SwiftUI

class DefaultHomeViewModel: ObservableObject {
    
    struct Competition: Hashable, Identifiable {
        var id: Int
        var name: String
        var description: String
        var distanceOrTime: Int
        var isActive: Bool
    }
    
    private let network: Network
    private unowned let coordinator: Coordinator
    
    @Published public var profileView = false
    @Published public var firstName = ""
    @Published public var secondName = ""
    @Published public var email = ""
    @Published public var error = ""
    @Published public var competitions = [:]
    
    
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
    
    func getDetails() {
        Task {
            do {
                self.email = try await network.getCurrentUserEmail()
                self.firstName = try await network.getUserFirstName(email: self.email)
                self.secondName = try await network.getUserSecondName(email: self.email)
                self.competitions = try await network.getActiveCompetitions()
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                }
            }
        }
    }
    
    func parseCompetitions() -> [Competition] {
        var competitionsList: [Competition] = []
        for (_, value) in self.competitions {
            guard let value = value as? [String: Any] else { continue }
            let name = value["name"] as? String ?? ""
            let description = value["description"] as? String ?? ""
            let distanceOrTime = value["distanceOrTime"] as? Int ?? 0
            let isActive = value["isActive"] as? Bool ?? false
            let competition = Competition(id: UUID().hashValue, name: name, description: description, distanceOrTime: distanceOrTime, isActive: isActive)
            competitionsList.append(competition)
        }
        return competitionsList
    }
}
