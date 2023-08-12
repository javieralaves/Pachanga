//
//  SignInEmailView.swift
//  Pachanga
//
//  Created by Javier Alaves on 8/8/23.
//

import SwiftUI

struct SignInEmailView: View {
    
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    
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
            
            // one button to keep things simple for now, should have sign up and sign in as separate actions
            Button {
                Task {
                    do {
                        try await viewModel.signUp()
                        showSignInView = false
                        return // if it hits this return, it means we signed up a user, otherwise try to sign in
                    } catch {
                        print(error)
                    }
                    
                    do {
                        try await viewModel.signIn()
                        showSignInView = false
                        return // if it hits this return, it means we signed up a user, otherwise try to sign in
                    } catch {
                        print(error)
                    }
                }
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
            SignInEmailView(showSignInView: .constant(false))
        }
    }
}
