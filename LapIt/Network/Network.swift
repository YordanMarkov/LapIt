//
//  Network.swift
//  LapIt
//
//  Created by Yordan Markov on 14.01.23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class Network {
    
    private lazy var firebaseAuth: Auth = {
        Auth.auth()
    }()
    
    private lazy var firestore: Firestore = {
        Firestore.firestore()
    }()
    
    func SignIn(email: String, password: String) async throws {
        try await firebaseAuth.signIn(withEmail: email, password: password)
    }
    
    
    func Register(email: String, password: String, firstName: String, secondName: String, isOrganizer: Bool) async throws {
        try await firebaseAuth.createUser(withEmail: email, password: password)
        firestore.collection("profiles").addDocument(data: ["firstName": firstName, "secondName": secondName, "isOrganizer": isOrganizer])
    }
}
