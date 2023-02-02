//
//  HistoryViewModel.swift
//  LapIt
//
//  Created by Yordan Markov on 26.01.23.
//

import Foundation
import SwiftUI

class HistoryViewModel: ObservableObject {
    private let network: Network
    private unowned let coordinator: Coordinator
    
    struct Competition: Hashable, Identifiable {
        var id: String
        var name: String
        var description: String
        var distanceOrTime: Int
        var isActive: Bool
    }
    
    @Published public var firstName = ""
    @Published public var secondName = ""
    @Published public var email = ""
    @Published public var error = ""
    @Published public var competitions = [:]
    @Published public var inactive_competitions = [:]
    @Published public var left = false
    
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
                self.firstName = try await network.getUserFirstName(email: self.email)
                self.secondName = try await network.getUserSecondName(email: self.email)
                self.competitions = try await network.getActiveAndJoinedCompetitions(user_email: self.email)
                self.inactive_competitions = try await network.getInactiveAndJoinedCompetitions(user_email: self.email)
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
    
    func parseInactiveCompetitions() -> [Competition] {
        var competitionsList: [Competition] = []
        for (_, value) in self.inactive_competitions {
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
    
    func leaveCompetition(currentCompetition: Competition) {
        Task {
            do {
                try await network.leaveCompetition(competition_id: currentCompetition.id, user_email: self.email)
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                }
            }
        }
    }
    
    func isAlreadyJoined(currentCompetition: Competition) {
        Task {
            do {
                self.left = try await !network.isAlreadyJoined(competition_id: currentCompetition.id, user_email: self.email)
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                }
            }
        }
    }
}
