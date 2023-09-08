//
//  ContentView.swift
//  Pachanga
//
//  Created by Javier Alaves on 28/6/23.
//

import SwiftUI

struct MainView: View {
    
    @State private var showSignInView: Bool = false
    
    var body: some View {
        
        ZStack {
            // if user has authenticated
            if !showSignInView {
                TabView {
                    // Sessions tab
                    NavigationView {
                        SessionsView()
                            .navigationTitle("Próximas sesiones")
                    }
                    .tabItem {
                        Label("Sesiones", systemImage: "volleyball.fill")
                    }
                    
                    // Profile tab
                    NavigationView {
                        ProfileView(showSignInView: $showSignInView)
                    }
                    .tabItem {
                        Label("Perfil", systemImage: "person.crop.circle")
                    }
                }
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
        
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AuthenticationView(showSignInView: .constant(false))
        }
    }
}
