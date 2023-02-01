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
    
    func createCompetition(email: String, name: String, description: String, distanceOrTime: Int, isActive: Bool) {
        firestore.collection("competitions").addDocument(data: ["email": email, "name": name, "description": description, "distanceOrTime": distanceOrTime, "isActive": isActive])
    }
    
    func getActiveCompetitions() async throws -> [String: Any] {
        var competitions = [String: Any]()
        let competitionsCollection = firestore.collection("competitions")
        let query = competitionsCollection.whereField("isActive", isEqualTo: true)
        let querySnapshot = try await query.getDocuments()
        let competitionsData = querySnapshot.documents
        competitionsData.forEach { document in
            let competition = document.data()
            competitions[document.documentID] = competition
        }
        return competitions
    }
    
    func getActiveCompetitionsByEmail(email: String) async throws -> [String: Any] {
        var competitions = [String: Any]()
        let competitionsCollection = firestore.collection("competitions")
        let query = competitionsCollection.whereField("isActive", isEqualTo: true).whereField("email", isEqualTo: email)
        let querySnapshot = try await query.getDocuments()
        let competitionsData = querySnapshot.documents
        competitionsData.forEach { document in
            let competition = document.data()
            competitions[document.documentID] = competition
        }
        return competitions
    }
    
    func getDeactivatedCompetitionsByEmail(email: String) async throws -> [String: Any] {
        var competitions = [String: Any]()
        let competitionsCollection = firestore.collection("competitions")
        let query = competitionsCollection.whereField("isActive", isEqualTo: false).whereField("email", isEqualTo: email)
        let querySnapshot = try await query.getDocuments()
        let competitionsData = querySnapshot.documents
        competitionsData.forEach { document in
            let competition = document.data()
            competitions[document.documentID] = competition
        }
        return competitions
    }
    
    func getCompetitionsByEmail(email: String) async throws -> [String: Any] {
        var competitions = [String: Any]()
        let competitionsCollection = firestore.collection("competitions")
        let query = competitionsCollection.whereField("email", isEqualTo: email)
        let querySnapshot = try await query.getDocuments()
        let competitionsData = querySnapshot.documents
        competitionsData.forEach { document in
            let competition = document.data()
            competitions[document.documentID] = competition
        }
        return competitions
    }
    
    func getUserOrganizerStatus(email: String) async throws -> Bool {
        let userCollection = firestore.collection("users")
        let query = userCollection.whereField("email", isEqualTo: email)
        let querySnapshot = try await query.getDocuments()
        let userData = querySnapshot.documents.first
        let isOrganizer = userData?["isOrganizer"] as? Bool ?? false
        return isOrganizer
    }
    
    func getCurrentUserEmail() async throws -> String {
        if let user = firebaseAuth.currentUser {
            return user.email ?? ""
        } else {
            throw NSError(domain: "UserNotFound", code: 0, userInfo: nil)
        }
    }
    
    func getUserFirstName(email: String) async throws -> String {
        let userCollection = firestore.collection("users")
        let query = userCollection.whereField("email", isEqualTo: email)
        let querySnapshot = try await query.getDocuments()
        let userData = querySnapshot.documents.first
        let firstName = userData?["firstName"] as? String ?? ""
        return firstName
    }
    
    func getUserSecondName(email: String) async throws -> String {
        let userCollection = firestore.collection("users")
        let query = userCollection.whereField("email", isEqualTo: email)
        let querySnapshot = try await query.getDocuments()
        let userData = querySnapshot.documents.first
        let secondName = userData?["secondName"] as? String ?? ""
        return secondName
    }
    
    func getUserKm(email: String) async throws -> Int {
        let userCollection = firestore.collection("users")
        let query = userCollection.whereField("email", isEqualTo: email)
        let querySnapshot = try await query.getDocuments()
        let userData = querySnapshot.documents.first
        let km = userData?["km"] as? Int ?? 0
        return km
    }
    
    func getUserMin(email: String) async throws -> Int {
        let userCollection = firestore.collection("users")
        let query = userCollection.whereField("email", isEqualTo: email)
        let querySnapshot = try await query.getDocuments()
        let userData = querySnapshot.documents.first
        let min = userData?["min"] as? Int ?? 0
        return min
    }
    
    func getUserWins(email: String) async throws -> Int {
        let userCollection = firestore.collection("users")
        let query = userCollection.whereField("email", isEqualTo: email)
        let querySnapshot = try await query.getDocuments()
        let userData = querySnapshot.documents.first
        let wins = userData?["wins"] as? Int ?? 0
        return wins
    }
}
