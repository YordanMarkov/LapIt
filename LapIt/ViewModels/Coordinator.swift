//
//  Coordinator.swift
//  LapIt
//
//  Created by Yordan Markov on 14.01.23.
//

import Foundation
import SwiftUI

class Coordinator: ObservableObject {
    static var shared = Coordinator()
    
    enum Tab {
        case defaultHome
        case login
        case register
    }
    @Published var currTab = Tab.login
    // auth state loading
    @Published var loading = false
    
    private  let network: Network
    
    lazy var registerViewModel: RegisterViewModel = {
        RegisterViewModel(network: self.network, coordinator: self)
    }()
    
    lazy var logInViewModel: LogInViewModel =  {
        LogInViewModel(network: self.network, coordinator: self)
    }()
    
    lazy var defaultHomeViewModel: DefaultHomeViewModel = {
        DefaultHomeViewModel(network: self.network, coordinator: self)
    }()
    
    init() {
        self.network = Network()
    }
    
    func route(to newTab: Tab) {
        self.currTab = newTab
    }
}
