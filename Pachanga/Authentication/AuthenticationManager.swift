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
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            // should do a custom error here
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
}

// MARK: SIGN IN EMAIL

extension AuthenticationManager {
    
    @discardableResult // means might not always use value, so no need to show alert in xcode
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
}

// MARK: SIGN IN SSO

extension AuthenticationManager {
    
    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signIn(credential: credential)
    }
    
}
