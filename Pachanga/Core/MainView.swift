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
        
        // need to replace this with the actual home view and recontextualize the code below
        ZStack {
            if !showSignInView {
                NavigationStack {
                    ProfileView(showSignInView: $showSignInView)
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
            MainView()
        }
    }
}
