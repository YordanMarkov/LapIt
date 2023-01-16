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
            Button(
                action: {
                    viewModel.route(to: .login)
                    // code upcoming
                },
                label: {
                    Text("Sign out")
                        .frame(width: 100 , height: 30, alignment: .center)
                })
            .buttonStyle(.borderedProminent)
            .foregroundColor(.white)
            .tint(.init(.red))
        }
    }
}
