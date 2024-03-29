//
//  BaseHomeViewModel.swift
//  LapIt
//
//  Created by Yordan Markov on 24.05.23.
//

import Foundation
import SwiftUI

class BaseHomeViewModel: ObservableObject {

    struct Competition: Hashable, Identifiable {
        var id: String
        var name: String
        var description: String
        var distanceOrTime: Int
        var isActive: Bool
    }

    internal let network: Network
    private unowned let coordinator: Coordinator

    @Published public var profileView = false
    @Published public var firstName = ""
    @Published public var secondName = ""
    @Published public var email = ""
    @Published public var error = ""
    @Published public var competitions: [String: Any] = [:]

    init(network: Network, coordinator: Coordinator) {
        self.network = network
        self.coordinator = coordinator
    }

    func route(to newTab: Coordinator.Tab) {
        coordinator.route(to: newTab)
    }

    func signOut() {
        Task {
            do {
                try await network.signOut()
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                }
            }
        }
    }

    func getDetails() {
        Task {
            do {
                let email = try await network.getCurrentUserEmail()
                let firstName = try await network.getUserFirstName(email: email)
                let secondName = try await network.getUserSecondName(email: email)
                let competitions = try await network.getActiveCompetitions()
                DispatchQueue.main.async {
                    self.email = email
                    self.firstName = firstName
                    self.secondName = secondName
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

    func deleteAccount() {
        Task {
            do {
                try await network.deleteAccount(email: self.email)
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                }
            }
        }
    }

    func save(firstName: String, secondName: String) {
        Task {
            do {
                try await network.updateNames(firstName: firstName, secondName: secondName, email: self.email)
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                }
            }
        }
    }
}
