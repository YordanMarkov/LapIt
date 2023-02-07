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
    
    
    func register(email: String, password: String, firstName: String, secondName: String, isOrganizer: Bool) async throws {
        try await firebaseAuth.createUser(withEmail: email, password: password)
        firestore.collection("users").addDocument(data: ["email": email, "firstName": firstName, "secondName": secondName, "isOrganizer": isOrganizer])
    }
    
    func deleteAccount(email: String) async throws {
        try await firebaseAuth.currentUser?.delete()
        
        let usersCollection = firestore.collection("users")
        let query = usersCollection.whereField("email", isEqualTo: email)
        let querySnapshot = try await query.getDocuments()
        let userData = querySnapshot.documents.first
        try await userData?.reference.delete()
        
        let competitionsCollection = firestore.collection("competitions")
        let query2 = competitionsCollection.whereField("email", isEqualTo: email)
        let querySnapshot2 = try await query2.getDocuments()
        let competitionsData = querySnapshot2.documents
        competitionsData.forEach { document in
            document.reference.delete()
        }
        
        let competitionsStatsCollection = firestore.collection("competitions_stats")
        let query3 = competitionsStatsCollection.whereField("user_email", isEqualTo: email)
        let querySnapshot3 = try await query3.getDocuments()
        let competitionsStatsData = querySnapshot3.documents
        competitionsStatsData.forEach { document in
            document.reference.delete()
        }
    }
    
    func createCompetition(email: String, name: String, description: String, distanceOrTime: Int, isActive: Bool) {
        let documentRef = firestore.collection("competitions").addDocument(data: ["id": "", "email": email, "name": name, "description": description, "distanceOrTime": distanceOrTime, "isActive": isActive])
        let documentID = documentRef.documentID
        firestore.collection("competitions").document(documentID).updateData(["id": documentID])
    }
    
    func joinCompetition(competition_id: String, user_email: String) {
        let data: [String: Any] = [
            "competition_id": competition_id,
            "user_email": user_email,
            "min": 0,
            "km": 0
        ]
        firestore.collection("competitions_stats").addDocument(data: data)
    }
    
    func leaveCompetition(competition_id: String, user_email: String) async throws {
        let competitionStatsCollection = firestore.collection("competitions_stats")
        let query = competitionStatsCollection.whereField("competition_id", isEqualTo: competition_id).whereField("user_email", isEqualTo: user_email)
        let querySnapshot = try await query.getDocuments()
        let competitionStatsData = querySnapshot.documents
        competitionStatsData.forEach { document in
            document.reference.delete()
        }
    }
    
    func isAlreadyJoined(competition_id: String, user_email: String) async throws -> Bool {
        let competitionsStatsCollection = firestore.collection("competitions_stats")
        let query = competitionsStatsCollection.whereField("competition_id", isEqualTo: competition_id).whereField("user_email", isEqualTo: user_email)
        let querySnapshot = try await query.getDocuments()
        let competitionsStatsData = querySnapshot.documents
        if competitionsStatsData.count > 0 {
            return true
        } else {
            return false
        }
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
    
    func getInactiveCompetitions() async throws -> [String: Any] {
        var competitions = [String: Any]()
        let competitionsCollection = firestore.collection("competitions")
        let query = competitionsCollection.whereField("isActive", isEqualTo: false)
        let querySnapshot = try await query.getDocuments()
        let competitionsData = querySnapshot.documents
        competitionsData.forEach { document in
            let competition = document.data()
            competitions[document.documentID] = competition
        }
        return competitions
    }
    
    func getActiveAndJoinedCompetitions(user_email: String) async throws -> [String: Any] {
        var competitions = [String: Any]()
        let activeCompetitions = try await getActiveCompetitions()
        for (key, value) in activeCompetitions {
            let isAlreadyJoined = try await isAlreadyJoined(competition_id: key, user_email: user_email)
            if isAlreadyJoined {
                competitions[key] = value
            }
        }
        return competitions
    }
    
    func getInactiveAndJoinedCompetitions(user_email: String) async throws -> [String: Any] {
        var competitions = [String: Any]()
        let activeCompetitions = try await getInactiveCompetitions()
        for (key, value) in activeCompetitions {
            let isAlreadyJoined = try await isAlreadyJoined(competition_id: key, user_email: user_email)
            if isAlreadyJoined {
                competitions[key] = value
            }
        }
        return competitions
    }
    
    func deactivateCompetitionById(competition_id: String) async throws {
        let competitionCollection = firestore.collection("competitions")
        let query = competitionCollection.document(competition_id)
        try await query.updateData(["isActive": false])
    }
    
    func activateCompetitionById(competition_id: String) async throws {
        let competitionCollection = firestore.collection("competitions")
        let query = competitionCollection.document(competition_id)
        try await query.updateData(["isActive": true])
    }
    
    func deleteCompetition(competition_id: String) async throws {
        let competitionCollection = firestore.collection("competitions")
        let query = competitionCollection.document(competition_id)
        try await query.delete()
        let competitionStatsCollection = firestore.collection("competitions_stats")
        let query2 = competitionStatsCollection.whereField("competition_id", isEqualTo: competition_id)
        let querySnapshot = try await query2.getDocuments()
        let competitionStatsData = querySnapshot.documents
        competitionStatsData.forEach { document in
            document.reference.delete()
        }
    }
    
    func getUsersById(competition_id: String) async throws -> [String: Any] {
        var users = [String: Any]()
        let competitionsStatsCollection = firestore.collection("competitions_stats")
        let query = competitionsStatsCollection.whereField("competition_id", isEqualTo: competition_id)
        let querySnapshot = try await query.getDocuments()
        let usersData = querySnapshot.documents
        usersData.forEach { document in
            let user = document.data()
            users[document.documentID] = user
        }
        return users
    }
    
    func updateKm(competition_id: String, km: Int, user_email: String) async throws {
        let competitionsStatsCollection = firestore.collection("competitions_stats")
        let query = competitionsStatsCollection.whereField("competition_id", isEqualTo: competition_id).whereField("user_email", isEqualTo: user_email)
        let querySnapshot = try await query.getDocuments()
        for document in querySnapshot.documents {
            try await document.reference.updateData(["km": km])
        }
    }
    
    func updateMin(competition_id: String, min: Int, user_email: String) async throws {
        let competitionsStatsCollection = firestore.collection("competitions_stats")
        let query = competitionsStatsCollection.whereField("competition_id", isEqualTo: competition_id).whereField("user_email", isEqualTo: user_email)
        let querySnapshot = try await query.getDocuments()
        for document in querySnapshot.documents {
            try await document.reference.updateData(["min": min])
        }
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
        let competitionsStatsCollection = firestore.collection("competitions_stats")
        let query = competitionsStatsCollection.whereField("user_email", isEqualTo: email)
        let querySnapshot = try await query.getDocuments()
        var totalKm = 0
        for document in querySnapshot.documents {
            let data = document.data()
            if let km = data["km"] as? Int {
                totalKm += km
            }
        }
        return totalKm
    }
    
    func getUserMin(email: String) async throws -> Int {
        let competitionsStatsCollection = firestore.collection("competitions_stats")
        let query = competitionsStatsCollection.whereField("user_email", isEqualTo: email)
        let querySnapshot = try await query.getDocuments()
        var totalMin = 0
        for document in querySnapshot.documents {
            let data = document.data()
            if let min = data["min"] as? Int {
                totalMin += min
            }
        }
        return totalMin
    }
}
