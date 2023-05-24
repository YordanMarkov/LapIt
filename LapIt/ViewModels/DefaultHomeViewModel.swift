//
//  HomeViewModel.swift
//  LapIt
//
//  Created by Yordan Markov on 14.01.23.
//

import Foundation
import SwiftUI

class DefaultHomeViewModel: BaseHomeViewModel {

    @Published public var joined = false

    override init(network: Network, coordinator: Coordinator) {
        super.init(network: network, coordinator: coordinator)
    }

    func isAlreadyJoined(currentCompetition: Competition) {
        Task {
            do {
                let joined = try await network.isAlreadyJoined(competition_id: currentCompetition.id, user_email: self.email)
                DispatchQueue.main.async {
                    self.joined = joined
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                }
            }
        }
    }

    func joinCompetition(currentCompetition: Competition) {
        network.joinCompetition(competition_id: currentCompetition.id, user_email: self.email)
    }
}
