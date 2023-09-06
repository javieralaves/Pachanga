//
//  ProfileView.swift
//  Pachanga
//
//  Created by Javier Alaves on 7/7/23.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func togglePlan() {
        guard let user else { return }
        let currentValue = user.isPremium ?? false
        Task {
            try await UserManager.shared.updateUserPlan(userId: user.userId, isPremium: !currentValue)
            self.user = try await UserManager.shared.getUser(userId: user.userId) // get user from db once user plan was updated to be safe
        }
    }
    
}

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    
    @State var userRating: Double = 1.0
    
    var body: some View {
        VStack {
            List {
                if let user = viewModel.user {
                    Text("ID: \(user.userId)")
                    
                    if let name = user.name {
                        Text("Nombre: \(name)")
                    }
                    
                    if let email = user.email {
                        Text("Email: \(email)")
                    }
                    
                    Text("Nivel: \(userRating, specifier: "%.2f")/5.0")
                    
                    Text("Tu plan: \(user.isPremium ?? false ? "Pro" : "Básico")")
                }
            }
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
        .onAppear {
            generateRating()
        }
        .navigationTitle("Perfil")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                
                NavigationLink {
                    SettingsView(showSignInView: $showSignInView)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }
            }
        }
    }
    
    func generateRating() {
        Task {
            let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
            userRating = try await UserManager.shared.getUserRating(userId: userId)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProfileView(showSignInView: .constant(false))
        }
    }
}
