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
    
    
    func Register(email: String, password: String, firstName: String, secondName: String, isOrganizer: Bool) async throws {
        try await firebaseAuth.createUser(withEmail: email, password: password)
        firestore.collection("users").addDocument(data: ["firstName": firstName, "secondName": secondName, "isOrganizer": isOrganizer])
    }
    
//    func getCurrentUserData() -> [String: Any]? { // Experimental, might not work.
//        if let currentUser = firebaseAuth.currentUser {
//            var userData: [String: Any]?
//            firestore.collection("users")
//                .document(currentUser.uid)
//                .getDocument { (document, error) in
//                    if let document = document, document.exists {
//                        userData = document.data()
//                    }
//                }
//            return userData
//        }
//        return nil
//    }
}
