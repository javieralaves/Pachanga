//
//  SettingsViewModel.swift
//  Pachanga
//
//  Created by Javier Alaves on 12/8/23.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published var user: DBUser? = nil
    
    @Published var authProviders: [AuthProviderOption] = []
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func loadAuthProviders() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProviders = providers
        }
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func deleteAccount() async throws {
        try await UserManager.shared.deleteUser()
    }
    
}
