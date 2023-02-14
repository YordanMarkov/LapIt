//
//  LibraryViewModel.swift
//  LapIt
//
//  Created by Yordan Markov on 26.01.23.
//

import Foundation
import SwiftUI

class LibraryViewModel: ObservableObject {
    
    struct Competition: Hashable, Identifiable {
        var id: String
        var name: String
        var description: String
        var distanceOrTime: Int
        var isActive: Bool
    }
    
    private let network: Network
    private unowned let coordinator: Coordinator
    
    @Published public var createView = false
    @Published public var reuse = false
    @Published public var error = ""
    @Published public var email = ""
    @Published public var name = ""
    @Published public var description = ""
    @Published public var distanceOrTime = 0
    @Published public var competitions = [:]
    
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
                let competitions = try await network.getCompetitionsByEmail(email: self.email)
                DispatchQueue.main.async {
                    self.email = email
                    self.competitions = competitions
                }
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
            let id = value["id"] as? String ?? ""
            let competition = Competition(id: id, name: name, description: description, distanceOrTime: distanceOrTime, isActive: isActive)
            competitionsList.append(competition)
        }
        return competitionsList
    }
    
    func create() {
        network.createCompetition(email: self.email, name: self.name, description: self.description, distanceOrTime: self.distanceOrTime, isActive: true)
    }
    
    func delete(competition: Competition?) {
        Task {
            do {
                try await network.deleteCompetition(competition_id: competition?.id ?? "")
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                }
            }
        }
    }
}
