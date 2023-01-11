//
//  ContentView.swift
//  LapIt
//
//  Created by Yordan Markov on 24.12.22.
//

import SwiftUI

struct LogIn: View {
    @State public var isLoggedIn = false
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
                    Text("Don't have an accout?\nRegister here.")
                        .multilineTextAlignment(.center)
                        .underline()
                })
            .buttonStyle(.plain)
            .position(x: 205, y: 540)
            
            if email.isEmpty || password.isEmpty {
                Text("Fields are required!")
                    .position(x: 205, y: 370)
                    .foregroundColor(.red)
            } else {
                Button(
                    action: {
                        // Nothing for now
                    },
                    label: {
                        Text("Log in")
                            .frame(width: 100 , height: 30, alignment: .center)
                    })
                .buttonStyle(.borderedProminent)
                .position(x: 205, y: 600)
                .foregroundColor(.white)
                .tint(.init(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor))
            }
        }
    }
}

struct Register1View: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repeatPassword: String = ""
    @State private var secured1: Bool = true
    @State private var secured2: Bool = true
    var body: some View {
        ZStack {
            Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).ignoresSafeArea()
            Text("Setting up")
                .padding()
                .background(Color(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor))
                .font(.largeTitle)
                .cornerRadius(10)
                .foregroundColor(.white)
                .frame(width: 400)
                .position(x: 205, y: 100)
            
            TextField("E-mail", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300, height: 300)
                .position(x: 205, y: 313)
            
            if secured1 {
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300, height: 300)
                    .position(x: 205, y: 375)
            } else {
                TextField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300, height: 300)
                    .position(x: 205, y: 375)
            }
            
            Button( // URL: https://stackoverflow.com/questions/63095851/show-hide-password-how-can-i-add-this-feature
                action: {
                    secured1.toggle()
                }) {
                    Image(systemName: self.secured1 ? "eye.slash" : "eye")
                        .accentColor(.black)
            }
                .position(x: 380, y: 375)
            
            if secured2 {
                SecureField("Repeat Password", text: $repeatPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300, height: 300)
                    .position(x: 205, y: 437)
            } else {
                TextField("Repeat Password", text: $repeatPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300, height: 300)
                    .position(x: 205, y: 437)
            }
            
            Button( // URL: https://stackoverflow.com/questions/63095851/show-hide-password-how-can-i-add-this-feature
                action: {
                    secured2.toggle()
                }) {
                    Image(systemName: self.secured2 ? "eye.slash" : "eye")
                        .accentColor(.black)
            }
                .position(x: 380, y: 437)
            
            if repeatPassword != password {
                Text("The passwords must match!")
                    .position(x: 205, y: 480)
                    .foregroundColor(.red)
            } else if password.count < 8 && !password.isEmpty && !repeatPassword.isEmpty {
                Text("The password must be at least 8 characters!")
                    .position(x: 205, y: 480)
                    .foregroundColor(.red)
            }
            
            if email.isEmpty || password.isEmpty || repeatPassword.isEmpty {
                Text("Fields are required!")
                    .position(x: 205, y: 275)
                    .foregroundColor(.red)
            }
            
            // Navigator
            ZStack {
                Rectangle()
                    .fill(Color(cgColor: UIColor(red: 0, green: 0.098, blue: 0.659, alpha: 1).cgColor))
                    .frame(width: 450, height: 21)
                    .position(x: 205, y: 700)
                
                Button(
                    action: {
                        // Nothing for now
                    },
                    label: {
                        Text(">>")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .bold()
                    })
                .buttonStyle(.plain)
                .position(x: 350, y: 700)
                
                Button(
                    action: {
                        // Nothing for now
                    },
                    label: {
                        Text("<<")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .bold()
                    })
                .buttonStyle(.plain)
                .position(x: 65, y: 700)
                
                Image("LapItLogo")
                    .resizable()
                    .frame(width: 109, height: 87)
                    .position(x: 205, y: 700)
            }
        }
    }
}

struct Register2View: View {
    @State private var firstName: String = ""
    @State private var secondName: String = ""
    @State private var isOrganizer: Bool = false
    var body: some View {
        ZStack {
            Color.init(cgColor: UIColor(red: 0.568, green: 0.817, blue: 0.814, alpha: 1).cgColor).ignoresSafeArea()
            Text("Setting up")
                .padding()
                .background(Color(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor))
                .font(.largeTitle)
                .cornerRadius(10)
                .foregroundColor(.white)
                .frame(width: 400)
                .position(x: 205, y: 100)
            
            TextField("First Name", text: $firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300, height: 300)
                .position(x: 205, y: 313)
            
            TextField("Second Name", text: $secondName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300, height: 300)
                .position(x: 205, y: 375)
            
            Toggle(isOn: $isOrganizer, label: {
                Text("Organizer account")
                    .foregroundColor(.blue)
                    .bold()
                    .underline()
            })
                .position(x: 193, y: 425)
                .padding()
                .toggleStyle(SwitchToggleStyle(tint: .blue))
            
            
            
            if firstName.isEmpty || secondName.isEmpty {
                Text("Fields are required!")
                    .position(x: 205, y: 275)
                    .foregroundColor(.red)
            } else {
                Button(
                    action: {
                        // Nothing for now
                    },
                    label: {
                        Text("Register")
                            .frame(width: 100 , height: 30, alignment: .center)
                    })
                .buttonStyle(.borderedProminent)
                .position(x: 205, y: 500)
                .foregroundColor(.white)
                .tint(.init(cgColor: UIColor(red: 0, green: 0.686, blue: 0.678, alpha: 1).cgColor))
            }
            
            // Navigator
            ZStack {
                Rectangle()
                    .fill(Color(cgColor: UIColor(red: 0, green: 0.098, blue: 0.659, alpha: 1).cgColor))
                    .frame(width: 450, height: 21)
                    .position(x: 205, y: 700)
                
                Button(
                    action: {
                        // Nothing for now
                    },
                    label: {
                        Text("<<")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .bold()
                    })
                .buttonStyle(.plain)
                .position(x: 65, y: 700)
                
                Image("LapItLogo")
                    .resizable()
                    .frame(width: 109, height: 87)
                    .position(x: 205, y: 700)
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        //LogIn()
        //Register1View()
        Register2View()
    }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
