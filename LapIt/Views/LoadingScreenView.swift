//
//  LoadingScreenView.swift
//  LapIt
//
//  Created by Yordan Markov on 24.05.23.
//

import Foundation
import SwiftUI

struct LoadingScreenView: View {
    @State private var isRotating = 0.0
    
    var body: some View {
        VStack (spacing: 40) {
            Image("LapItLogo")
                .resizable()
                .frame(width: 218, height: 174)
                .rotationEffect(.degrees(isRotating))
                .onAppear {
                    withAnimation(.linear(duration: 1)
                            .speed(0.5).repeatForever(autoreverses: false)) {
                        isRotating = 360.0
                    }
                }
            
            Text("Loading...")
                .padding()
                .background(Color(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor))
                .font(.largeTitle)
                .cornerRadius(10)
                .foregroundColor(.white)
                .frame(width: 400)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).ignoresSafeArea())
    }
}
