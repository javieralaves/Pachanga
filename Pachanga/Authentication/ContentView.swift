//
//  ContentView.swift
//  Pachanga
//
//  Created by Javier Alaves on 28/6/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showSignedInView: Bool = false
    
    var body: some View {
        
        ZStack {
            NavigationStack {
                SettingsView(showSignedInView: $showSignedInView)
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignedInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignedInView) {
            NavigationStack {
                AuthenticationView()
            }
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
