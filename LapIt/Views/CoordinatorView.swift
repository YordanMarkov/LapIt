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
            LogInView(viewModel: coordinator.logInViewModel)
                .tag(Coordinator.Tab.login)
            
            RegisterView(viewModel: coordinator.registerViewModel)
                .tag(Coordinator.Tab.register)
            
            DefaultHomeView(viewModel: coordinator.defaultHomeViewModel)
                .tag(Coordinator.Tab.defaultHome)
            
            OrganizerHomeView(viewModel: coordinator.organizerHomeViewModel)
                .tag(Coordinator.Tab.organizerHome)
            
            StatsView(viewModel: coordinator.statsViewModel)
                .tag(Coordinator.Tab.stats)
            
            HistoryView(viewModel: coordinator.historyViewModel)
                .tag(Coordinator.Tab.history)
            
            LibraryView(viewModel: coordinator.libraryViewModel)
                .tag(Coordinator.Tab.library)
            
            ActiveView(viewModel: coordinator.activeViewModel)
                .tag(Coordinator.Tab.active)
        }
    }
}
