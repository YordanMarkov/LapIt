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
        case history
        case stats
        case organizerHome
        case library
        case active
        case login
        case register
    }
    
    @Published var currTab = Tab.login // has to be .login
    
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
    
    lazy var organizerHomeViewModel: OrganizerHomeViewModel = {
        OrganizerHomeViewModel(network: self.network, coordinator: self)
    }()
    
    lazy var historyViewModel: HistoryViewModel = {
        HistoryViewModel(network: self.network, coordinator: self)
    }()
    
    lazy var statsViewModel: StatsViewModel = {
        StatsViewModel(network: self.network, coordinator: self)
    }()
    
    lazy var libraryViewModel: LibraryViewModel = {
        LibraryViewModel(network: self.network, coordinator: self)
    }()
    
    lazy var activeViewModel: ActiveViewModel = {
        ActiveViewModel(network: self.network, coordinator: self)
    }()
    
    init() {
        self.network = Network()
    }
    
    func route(to newTab: Tab) {
        self.currTab = newTab
    }
}
