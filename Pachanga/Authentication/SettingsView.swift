//
//  SettingsView.swift
//  Pachanga
//
//  Created by Javier Alaves on 8/8/23.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
}

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignedInView: Bool
    
    var body: some View {
        List {
            Button("Cerrar sesión") {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignedInView = true
                    } catch {
                        // need better error handling here
                        print(error)
                    }
                }
            }
        }
        .navigationTitle("Ajustes")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showSignedInView: .constant(false))
    }
}
