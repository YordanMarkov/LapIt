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
        }
    }
}
