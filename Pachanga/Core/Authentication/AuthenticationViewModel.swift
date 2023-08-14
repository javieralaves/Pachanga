//
//  AuthenticationViewModel.swift
//  Pachanga
//
//  Created by Javier Alaves on 12/8/23.
//

import Foundation

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    let signInAppleHelper = SignInAppleHelper()
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        try await UserManager.shared.createNewUser(auth: authDataResult)
    }
    
    func signInApple() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        let authDataResult = try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
        let user = DBUser(userId: authDataResult.uid, email: authDataResult.email, photoUrl: authDataResult.photoURL, dateCreated: Date())
        
        try await UserManager.shared.createNewUser(user: user)
//        try await UserManager.shared.createNewUser(auth: authDataResult)
    }
}
