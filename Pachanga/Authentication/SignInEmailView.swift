//
//  SignInEmailView.swift
//  Pachanga
//
//  Created by Javier Alaves on 8/8/23.
//

import SwiftUI

@MainActor
final class SignInEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    func signIn() {
        
        // Do proper validation down the line
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            return
        }
        
        Task {
            do {
                let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
                print("Success")
                print(returnedUserData)
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
}

struct SignInEmailView: View {
    
    @StateObject private var viewModel = SignInEmailViewModel()
    
    var body: some View {
        VStack {
            TextField("Correo electrónico", text: $viewModel.email)
                .padding()
                .background(.gray.opacity(0.2))
                .cornerRadius(10)
            
            SecureField("Contraseña", text: $viewModel.password)
                .padding()
                .background(.gray.opacity(0.2))
                .cornerRadius(10)
            
            Button {
                viewModel.signIn()
            } label: {
                Text("Iniciar sesión")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(10)
            }
            
            Spacer()

        }
        .padding()
        .navigationTitle("Introduce tu correo")
    }
}

struct SignInEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignInEmailView()
        }
    }
}
