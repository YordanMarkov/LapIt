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
    
    struct User: Hashable {
        var user_email: String
        var firstName: String
        var secondName: String
        var km: Float
        var min: Float
    }
    
    @Published public var activeCompetitions = [:]
    @Published public var deactivatedCompetitions = [:]
    @Published public var users: [User] = []
    @Published public var email = ""
    @Published public var error = ""
    @Published public var winners: [User] = []
    
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
                let activeCompetitions = try await network.getActiveCompetitionsByEmail(email: self.email)
                let deactivatedCompetitions = try await network.getDeactivatedCompetitionsByEmail(email: self.email)
                DispatchQueue.main.async {
                    self.email = email
                    self.activeCompetitions = activeCompetitions
                    self.deactivatedCompetitions = deactivatedCompetitions
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                }
            }
        }
    }
    
    func getUsers(currentCompetition: Competition) {
        Task {
            do {
                try await parseUsers(array: network.getUsersById(competition_id: currentCompetition.id))
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                }
            }
        }
    }
    
    func parseUsers(array: [AnyHashable : Any]) {
        Task {
            do {
                var users: [User] = []
                for (_, value) in array {
                    guard let value = value as? [String: Any] else { continue }
                    let user_email = value["user_email"] as? String ?? ""
                    let firstName = try await network.getUserFirstName(email: user_email)
                    let secondName = try await network.getUserSecondName(email: user_email)
                    let km = value["km"] as? Float ?? 0
                    let min = value["min"] as? Float ?? 0
                    let user = User(user_email: user_email, firstName: firstName, secondName: secondName, km: km, min: min)
                    users.append(user)
                }
                let finalized = users
                DispatchQueue.main.async {
                    self.users = finalized
                }
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
    
    func updateMin(currentCompetition: Competition, min: Float, user_email: String) {
        Task {
            do {
                try await network.updateMin(competition_id: currentCompetition.id, min: min, user_email: user_email)
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                }
            }
        }
    }
    
    func updateKm(currentCompetition: Competition, km: Float, user_email: String) {
        Task {
            do {
                try await network.updateKm(competition_id: currentCompetition.id, km: km, user_email: user_email)
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                }
            }
        }
    }
    
    func leaveCompetition(competition_id: String, user_email: String) {
        Task {
            do {
                try await network.leaveCompetition(competition_id: competition_id, user_email: user_email)
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                }
            }
        }
    }
}
