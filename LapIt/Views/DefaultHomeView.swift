//
//  DeefaultHomeVieew.swift
//  LapIt
//
//  Created by Yordan Markov on 16.01.23.
//

import Foundation
import SwiftUI


struct DefaultHomeView: View {
    
    @ObservedObject private var viewModel: DefaultHomeViewModel
    
    init(viewModel: DefaultHomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).ignoresSafeArea()
        }
    }
}
