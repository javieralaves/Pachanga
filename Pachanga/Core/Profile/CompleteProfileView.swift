//
//  CompleteProfileView.swift
//  Pachanga
//
//  Created by Javier Alaves on 3/10/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct CompleteProfileView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Nombre", text: $firstName)
                    TextField("Apellido", text: $lastName)
                }
            }
            .navigationTitle("Tu perfil")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                Button("Continuar") {
                    let data: [AnyHashable : Any] = [
                        DBUser.CodingKeys.firstName.rawValue : firstName,
                        DBUser.CodingKeys.lastName.rawValue : lastName,
                        DBUser.CodingKeys.firstLogin.rawValue : false
                    ]
                    Task {
                        let userCollection = Firestore.firestore().collection("users")
                        let authId = try AuthenticationManager.shared.getAuthenticatedUser().uid
                        try await userCollection.document(authId).updateData(data)
                    }
                    
                    dismiss()
                    
                    // go to sessions view
                }
            }
        }
        .onAppear {
            updateInfo()
        }
    }
    
    func updateInfo() {
        Task {
            // get authenticated user id
            let authId = try AuthenticationManager.shared.getAuthenticatedUser().uid
            
            // get user from id
            let user = try await UserManager.shared.getUser(userId: authId)
            
            // update view props with user info
            self.firstName = user.firstName
            self.lastName = user.lastName
        }
        
    }
}
