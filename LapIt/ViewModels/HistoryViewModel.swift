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
    
    struct User: Hashable {
        var user_email: String
        var firstName: String
        var secondName: String
        var km: Int
        var min: Int
    }
    
    @Published public var firstName = ""
    @Published public var secondName = ""
    @Published public var email = ""
    @Published public var error = ""
    @Published public var competitions = [:]
    @Published public var inactive_competitions = [:]
    @Published public var left = false
    @Published public var users: [User] = []
    
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
                let firstName = try await network.getUserFirstName(email: self.email)
                let secondName = try await network.getUserSecondName(email: self.email)
                let competitions = try await network.getActiveAndJoinedCompetitions(user_email: self.email)
                let inactive_competitions = try await network.getInactiveAndJoinedCompetitions(user_email: self.email)
                DispatchQueue.main.async {
                    self.email = email
                    self.firstName = firstName
                    self.secondName = secondName
                    self.competitions = competitions
                    self.inactive_competitions = inactive_competitions
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
                        let km = value["km"] as? Int ?? 0
                        let min = value["min"] as? Int ?? 0
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
                let left = try await !network.isAlreadyJoined(competition_id: currentCompetition.id, user_email: self.email)
                DispatchQueue.main.async {
                    self.left = left
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                }
            }
        }
    }
}
