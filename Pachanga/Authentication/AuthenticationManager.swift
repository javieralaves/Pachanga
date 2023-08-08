//
//  AuthenticationManager.swift
//  Pachanga
//
//  Created by Javier Alaves on 8/8/23.
//

import FirebaseAuth
import Foundation

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoURL: String?
    
    // User coming from Firebase SDK
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        // .absoluteString converts URL to string
        self.photoURL = user.photoURL?.absoluteString
    }
}

final class AuthenticationManager {
    
    // Avoid singleton design pattern at scale
    static let shared = AuthenticationManager()
    private init() { }
    
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
}
