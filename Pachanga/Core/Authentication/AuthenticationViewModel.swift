//
//  AuthenticationViewModel.swift
//  Pachanga
//
//  Created by Javier Alaves on 12/8/23.
//

import FirebaseMessaging
import Foundation

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    let signInAppleHelper = SignInAppleHelper()
    
    func getMessagingToken() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            Messaging.messaging().token { token, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let token = token {
                    continuation.resume(returning: token)
                } else {
                    continuation.resume(throwing: NSError(domain: "FirebaseToken", code: -1, userInfo: nil))
                }
            }
        }
    }
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        var user = DBUser(auth: authDataResult)
        
        // fetch FCM token for notifications
        let fcmToken = try await getMessagingToken()
        user.fcmToken = fcmToken
        
        try await UserManager.shared.createNewUser(user: user)
    }
    
    func signInApple() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        let authDataResult = try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
        var user = DBUser(auth: authDataResult)
        
        // fetch FCM token for notifications
        let fcmToken = try await getMessagingToken()
        user.fcmToken = fcmToken
        
        try await UserManager.shared.createNewUser(user: user)
    }
}
