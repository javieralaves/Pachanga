//
//  SettingsView.swift
//  Pachanga
//
//  Created by Javier Alaves on 8/8/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct SettingsView: View {
    
    // to dismiss view on save
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    @State private var showAlert = false
    @State private var username: String = ""
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    
    var body: some View {
        Form {
            Section ("Info") {
                TextField("Nombre", text: $firstName)
                TextField("Apellido", text: $lastName)
            }
            Section ("Acciones") {
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
        }
        .onAppear {
            viewModel.loadAuthProviders()
        }
        .task {
            try? await viewModel.loadCurrentUser()
            firstName = viewModel.user?.firstName ?? "Juan"
            lastName = viewModel.user?.lastName ?? "Doe"
        }
        .navigationTitle("Ajustes")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Guardar") {
                let data: [AnyHashable : Any] = [
                    DBUser.CodingKeys.firstName.rawValue : firstName,
                    DBUser.CodingKeys.lastName.rawValue : lastName
                ]
                Task {
                    let userCollection = Firestore.firestore().collection("users")
                    let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
                    try await userCollection.document(authDataResult.uid).updateData(data)
                }
                dismiss()
            }
        }
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
                Text("Confirmar")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView(showSignInView: .constant(false))
        }
    }
}
