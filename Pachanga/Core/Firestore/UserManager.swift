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
    // base props
    let userId: String
    let name: String?
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
    let isPremium: Bool?
    var fcmToken: String
    // profile props
    var firstLogin: Bool
    var firstName: String
    var lastName: String
    
    // initializer passing an AuthDataResultModel for authentication flow
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.name = auth.name ?? "Juan Doe"
        self.email = auth.email
        self.photoUrl = auth.photoURL
        self.dateCreated = Date() // will need to update this flow eventually because it overrides the stored value with a new date every time user logs in
        self.isPremium = false
        self.fcmToken = ""
        self.firstLogin = true
        self.firstName = ""
        self.lastName = ""
    }
    
    // initializer to adjust properties
    init(
        userId: String,
        name: String? = nil,
        email: String? = nil,
        photoUrl: String? = nil,
        dateCreated: Date? = nil,
        isPremium: Bool? = nil,
        fcmToken: String,
        firstLogin: Bool,
        firstName: String,
        lastName: String
    ) {
        self.userId = userId
        self.name = name ?? "Juan Doe"
        self.email = email
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.isPremium = isPremium
        self.fcmToken = fcmToken
        self.firstLogin = firstLogin
        self.firstName = firstName
        self.lastName = lastName
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case name = "name"
        case email = "email"
        case photoUrl = "photo_url"
        case dateCreated = "date_created"
        case isPremium = "is_premium"
        case fcmToken = "fcm_token"
        case firstLogin = "first_login"
        case firstName = "first_name"
        case lastName = "last_name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
        self.fcmToken = try container.decode(String.self, forKey: .fcmToken)
        self.firstLogin = try container.decode(Bool.self, forKey: .firstLogin)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
        try container.encode(self.fcmToken, forKey: .fcmToken)
        try container.encode(self.firstLogin, forKey: .firstLogin)
        try container.encode(self.firstName, forKey: .firstName)
        try container.encode(self.lastName, forKey: .lastName)
    }
    
}

final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    func deleteUser() async throws {
        // get user id
        let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
        
        // delete db reference
        try await userDocument(userId: userId).delete()
        
        // delete authentication info
        try await AuthenticationManager.shared.deleteUser()
    }
    
    func updateUserPlan(userId: String, isPremium: Bool) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.isPremium.rawValue : isPremium
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func getUserRating(userId: String) async throws -> Double {
        var userRating = 1.0
        
        // array of sessions that user was a member of
        let userSessions = try await SessionManager.shared.getUserSessions(userId: userId)
        
        for session in userSessions {
            let matches = try await SessionManager.shared.getAllSessionMatches(sessionId: session.sessionId)
            
            for match in matches {
                // user is in team one, and won
                if (match.t1p1 == userId || match.t1p2 == userId) && match.scoreOne > match.scoreTwo {
                    userRating += 0.12
                }
                
                // user is in team two, and lost
                if (match.t1p1 == userId || match.t1p2 == userId) && match.scoreOne < match.scoreTwo {
                    userRating -= 0.1
                }
                
                // user is in team two, and lost
                if (match.t2p1 == userId || match.t2p2 == userId) && match.scoreOne > match.scoreTwo {
                    userRating -= 0.1
                }
                
                // user is in team two, and won
                if (match.t2p1 == userId || match.t2p2 == userId) && match.scoreOne < match.scoreTwo {
                    userRating += 0.12
                }
            }
        }
        
        return userRating
    }
    
}
