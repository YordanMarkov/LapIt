//
//  ActiveViewModel.swift
//  LapIt
//
//  Created by Yordan Markov on 26.01.23.
//

import Foundation
import SwiftUI

class ActiveViewModel: ObservableObject {
    
    struct Competition: Hashable, Identifiable {
        var id: String
        var name: String
        var description: String
        var distanceOrTime: Int
        var isActive: Bool
    }
    
    @Published public var activeCompetitions = [:]
    @Published public var deactivatedCompetitions = [:]
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
                self.email = try await network.getCurrentUserEmail()
                self.activeCompetitions = try await network.getActiveCompetitionsByEmail(email: self.email)
                self.deactivatedCompetitions = try await network.getDeactivatedCompetitionsByEmail(email: self.email)
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                }
            }
        }
    }
    
    func parseCompetitions(array: [AnyHashable : Any]) -> [Competition] {
        var competitionsList: [Competition] = []
        for (_, value) in array {
            guard let value = value as? [String: Any] else { continue }
            let name = value["name"] as? String ?? ""
            let description = value["description"] as? String ?? ""
            let distanceOrTime = value["distanceOrTime"] as? Int ?? 0
            let isActive = value["isActive"] as? Bool ?? false
            let id = value["id"] as? String ?? ""
            let competition = Competition(id: id, name: name, description: description, distanceOrTime: distanceOrTime, isActive: isActive)
            competitionsList.append(competition)
        }
        return competitionsList
    }
    
    func deactivateCompetition(currentCompetition: Competition) {
        Task {
            do {
                try await network.deactivateCompetitionById(competition_id: currentCompetition.id)
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                }
            }
        }
    }
    
    func activateCompetition(currentCompetition: Competition) {
        Task {
            do {
                try await network.activateCompetitionById(competition_id: currentCompetition.id)
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                }
            }
        }
    }
}
