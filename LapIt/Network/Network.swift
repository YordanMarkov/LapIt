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
    
    func signIn(email: String, password: String) async throws {
        try await firebaseAuth.signIn(withEmail: email, password: password)
    }
    
    func signOut() {
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func sendPasswordReset(email: String) async throws {
        try await firebaseAuth.sendPasswordReset(withEmail: email)
    }
    
    
    func Register(email: String, password: String, firstName: String, secondName: String, isOrganizer: Bool) async throws {
        try await firebaseAuth.createUser(withEmail: email, password: password)
        firestore.collection("users").addDocument(data: ["email": email, "firstName": firstName, "secondName": secondName, "isOrganizer": isOrganizer, "km": 0, "min": 0, "wins": 0])
    }
    
    func getUserData(email: String) -> [String: Any] {
        var userData: [String: Any]?
        firestore.collection("users").whereField("email", isEqualTo: email).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    userData = document.data()
                }
            }
        }
        return userData ?? [:]
    }
}
