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
            LogIn(viewModel: coordinator.loginViewModel)
                .tag(Coordinator.Tab.login)
            
            RegisterView(viewModel: coordinator.registerViewModel)
                .tag(Coordinator.Tab.register)
            
//            HomeView(viewModel: coordinator.homeViewModel)
//                .tag(Coordinator.Tab.home)
        }
    }
}
