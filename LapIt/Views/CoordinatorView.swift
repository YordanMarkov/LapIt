//
//  CoordinatorView.swift
//  LapIt
//
//  Created by Yordan Markov on 14.01.23.
//

import Foundation
import SwiftUI

struct CoordinatorView: View {
    @ObservedObject private var coordinator: Coordinator
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    var body: some View {
        TabView(selection: $coordinator.currTab) {
            switch coordinator.currTab {
            case .defaultHome:
                DefaultHomeView(viewModel: coordinator.defaultHomeViewModel)
                    .tag(Coordinator.Tab.defaultHome)
            case .history:
                HistoryView(viewModel: coordinator.historyViewModel)
                    .tag(Coordinator.Tab.history)
            case .stats:
                StatsView(viewModel: coordinator.statsViewModel)
                    .tag(Coordinator.Tab.stats)
            case .organizerHome:
                OrganizerHomeView(viewModel: coordinator.organizerHomeViewModel)
                    .tag(Coordinator.Tab.organizerHome)
            case .library:
                LibraryView(viewModel: coordinator.libraryViewModel)
                    .tag(Coordinator.Tab.library)
            case .active:
                ActiveView(viewModel: coordinator.activeViewModel)
                    .tag(Coordinator.Tab.active)
            case .login:
                LogInView(viewModel: coordinator.logInViewModel)
                    .tag(Coordinator.Tab.login)
            case .register:
                RegisterView(viewModel: coordinator.registerViewModel)
                    .tag(Coordinator.Tab.register)
            }
        }
    }
}
