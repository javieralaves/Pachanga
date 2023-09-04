//
//  UserManager.swift
//  Pachanga
//
//  Created by Javier Alaves on 12/8/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

struct DBUser: Codable, Hashable {
    let userId: String
    let name: String?
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
    let isPremium: Bool?
    
    
    // initializer passing an AuthDataResultModel for authentication flow
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.name = auth.name ?? "Juan Doe"
        self.email = auth.email
        self.photoUrl = auth.photoURL
        self.dateCreated = Date() // will need to update this flow eventually because it overrides the stored value with a new date every time user logs in
        self.isPremium = false
    }
    
    // initializer to adjust properties
    init(
        userId: String,
        name: String? = nil,
        email: String? = nil,
        photoUrl: String? = nil,
        dateCreated: Date? = nil,
        isPremium: Bool? = nil
    ) {
        self.userId = userId
        self.name = name ?? "Juan Doe"
        self.email = email
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.isPremium = isPremium
    }
    
    // a function that toggles plan for user, for whenever we need it, by calling user.togglePlan() and then updating the db with that user
    //    mutating func togglePlan() {
    //        let currentPlan = isPremium ?? false
    //        isPremium = !currentPlan
    //    }
    
    // custom coding strategy
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case name = "name"
        case email = "email"
        case photoUrl = "photo_url"
        case dateCreated = "date_created"
        case isPremium = "is_premium"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
    }
    
}

final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    //    // to encode DBUser property keys to match db properties
    //    private let encoder: Firestore.Encoder = {
    //        let encoder = Firestore.Encoder()
    //        encoder.keyEncodingStrategy = .convertToSnakeCase
    //        return encoder
    //    }()
    //
    //    // to get user with custom decoder
    //    private let decoder: Firestore.Decoder = {
    //        let decoder = Firestore.Decoder()
    //        decoder.keyDecodingStrategy = .convertFromSnakeCase
    //        return decoder
    //    }()
    
    // instead of creating a dictionary, pushing the user itself as a DBUser
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    //    func createNewUser(auth: AuthDataResultModel) async throws {
    //
    //        var userData: [String : Any] = [
    //            "user_id" : auth.uid,
    //            "date_created" : Timestamp(),
    //
    //        ]
    //
    //        if let email = auth.email {
    //            userData["email"] = email
    //        }
    //
    //        if let photoUrl = auth.photoURL {
    //            userData["photo_url"] = photoUrl
    //        }
    //
    //        try await userDocument(userId: auth.uid).setData(userData, merge: false)
    //    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    // take a user and push it back to database
    // this one is dangerous because it overrides the whole user
    //    func updateUserPlan(user: DBUser) async throws {
    //        try userDocument(userId: user.userId).setData(from: user, merge: true)
    //    }
    
    func updateUserPlan(userId: String, isPremium: Bool) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.isPremium.rawValue : isPremium
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    //    func getUser(userId: String) async throws -> DBUser {
    //        let snapshot = try await userDocument(userId: userId).getDocument()
    //
    //        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
    //            throw URLError(.badServerResponse)
    //        }
    //
    //        let email = data["email"] as? String
    //        let photoUrl = data["photo_url"] as? String
    //        let dateCreated = data["date_created"] as? Date
    //
    //        return DBUser(userId: userId, email: email, photoUrl: photoUrl, dateCreated: dateCreated)
    //    }
    
}
