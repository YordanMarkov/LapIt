//
//  OrganizerHomeView.swift
//  LapIt
//
//  Created by Yordan Markov on 25.01.23.
//

import Foundation
import SwiftUI


struct OrganizerHomeView: View {
    
    @ObservedObject private var viewModel: OrganizerHomeViewModel
    
    init(viewModel: OrganizerHomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).ignoresSafeArea()
            Button(
                action: {
                    viewModel.signOut()
                    viewModel.route(to: .login)
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

