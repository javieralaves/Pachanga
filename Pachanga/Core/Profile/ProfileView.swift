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
    
    @State var firstLoad: Bool = false
    @State var userRating: Double = 1.0
    @State var matchesPlayed: Int = 0
    @State var matchesWon: Int = 0
    @State var matchesLost: Int = 0
    @State var winLossRatio: Double = 1.0
    
    var body: some View {
        VStack {
            List {
                if let user = viewModel.user {
                    
                    Section ("Info") {
                        Text("ID: \(user.userId)")
                        
                        if let name = user.name {
                            Text("Nombre: \(name)")
                        }
                        
                        if let email = user.email {
                            Text("Email: \(email)")
                        }
                    }
                    
                    Section("Rendimiento") {
                        HStack {
                            Text("Nivel de jugador")
                            Spacer()
                            Text("\(userRating, specifier: "%.2f")/5.0")
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Text("Partidos jugados")
                            Spacer()
                            Text("\(matchesPlayed)")
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Text("Partidos ganados")
                            Spacer()
                            Text("\(matchesWon)")
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Text("Partidos perdidos")
                            Spacer()
                            Text("\(matchesLost)")
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Text("Ratio de victorias")
                            Spacer()
                            Text("\(winLossRatio, specifier: "%.2f")")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
        .onAppear {
            if !firstLoad {
                updateProfile()
                firstLoad = true
            }
        }
        .navigationTitle("\(viewModel.user?.name ?? " ")")
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
    
    func updateProfile() {
        Task {
            // get user id
            let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
            
            // generate user rating
            userRating = try await UserManager.shared.getUserRating(userId: userId)
            
            // get user sessions
            let userSessions = try await SessionManager.shared.getUserSessions(userId: userId)
            
            // loop through matches within sessions
            for session in userSessions {
                
                let sessionMatches = try await SessionManager.shared.getAllSessionMatches(sessionId: session.sessionId)
                
                for match in sessionMatches {
                    // check for matches played
                    if match.t1p1 == userId || match.t1p2 == userId || match.t2p1 == userId || match.t2p2 == userId {
                        matchesPlayed += 1
                    }
                    
                    // check for matches won
                    if (match.t1p1 == userId || match.t1p2 == userId) && match.scoreOne > match.scoreTwo {
                        matchesWon += 1
                    }
                    if (match.t2p1 == userId || match.t2p2 == userId) && match.scoreOne < match.scoreTwo {
                        matchesWon += 1
                    }
                }
            }
            
            // calculate the remaining profile stat variables
            matchesLost = matchesPlayed - matchesWon
            winLossRatio = Double(matchesWon) / Double(matchesLost)
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
