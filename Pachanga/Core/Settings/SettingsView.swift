//
//  SettingsView.swift
//  Pachanga
//
//  Created by Javier Alaves on 8/8/23.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    @State private var showAlert = false
    
    var body: some View {
        List {
            Button("Cerrar sesión") {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        // need better error handling here
                        print(error)
                    }
                }
            }
            
            Button(role: .destructive) {
                showAlert = true
            } label: {
                Text("Borrar cuenta")
            }
        }
        .onAppear {
            viewModel.loadAuthProviders()
        }
        .navigationTitle("Ajustes")
        .alert("¿Estás seguro de que quieres borrar tu cuenta?", isPresented: $showAlert) {
            Button(role: .destructive) {
                Task {
                    do {
                        try await viewModel.deleteAccount()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Sí")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showSignInView: .constant(false))
    }
}
