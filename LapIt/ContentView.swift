//
//  ContentView.swift
//  LapIt
//
//  Created by Yordan Markov on 24.12.22.
//

import SwiftUI

struct ContentView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var secured: Bool = true
    var body: some View {
        ZStack {
            Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).ignoresSafeArea()
            
            Image("LapItLogo")
                .resizable()
                .frame(width: 218, height: 174)
                .position(x: 205, y: 255)
            
            TextField("E-mail", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300, height: 300)
                .position(x: 205, y: 413)
           
            if secured {
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300, height: 300)
                    .position(x: 205, y: 475)
            } else {
                TextField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300, height: 300)
                    .position(x: 205, y: 475)
            }
            
            Button( // URL: https://stackoverflow.com/questions/63095851/show-hide-password-how-can-i-add-this-feature
                action: {
                    secured.toggle()
                }) {
                    Image(systemName: self.secured ? "eye.slash" : "eye")
                        .accentColor(.black)
            }
                .position(x: 380, y: 475)
            
            Button(
                action: {
                    // Nothing for now
                },
                label: {
                    Text("Log in")
                        .frame(width: 100 , height: 30, alignment: .center)
                })
            .buttonStyle(.borderedProminent)
            .position(x: 205, y: 540)
            .foregroundColor(.white)
            .tint(.init(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor))
            
            Button(
                action: {
                    // Nothing for now
                },
                label: {
                    Text("Don't have an accout?\nRegister here.")
                        .multilineTextAlignment(.center)
                        .underline()
                })
            .buttonStyle(.plain)
            .position(x: 205, y: 600)
        }
    }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
