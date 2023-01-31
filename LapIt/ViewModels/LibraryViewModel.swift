//
//  LibraryViewModel.swift
//  LapIt
//
//  Created by Yordan Markov on 26.01.23.
//

import Foundation
import SwiftUI

class LibraryViewModel: ObservableObject {
    private let network: Network
    private unowned let coordinator: Coordinator
    
    @Published public var createView = false
    
    @Published public var name = ""
    @Published public var description = ""
    @Published public var distanceOrTime = 0
    
    init(network: Network, coordinator: Coordinator) {
        self.network = network
        self.coordinator = coordinator
    }
    
    func route(to newTab: Coordinator.Tab) {
        coordinator.route(to: newTab)
    }
}
