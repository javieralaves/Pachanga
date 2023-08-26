//
//  NewSession.swift
//  Pachanga
//
//  Created by Javier Alaves on 15/8/23.
//

import Foundation // to generate UUID
import SwiftUI

struct NewSession: View {
    
    // to dismiss view on save
    @Environment(\.dismiss) var dismiss
    
    // session details
    @State private var location: String = "Club Muchavista"
    @State private var sessionDate: Date = Date()
    
    // equipment
    @State private var isBallAvailable: Bool = false
    @State private var areLinesAvailable: Bool = false
    
    // available fields, stored in form for now
    let fields = ["Club Muchavista", "Restaurante Xaloc", "Restaurante Niza", "Seis Perlas Campello"]
    
    var body: some View {
        
        Form {
            Section ("Detalles") {
                Picker("Lugar", selection: $location) {
                    ForEach(fields, id: \.self) {
                        Text($0)
                    }
                }
                .onChange(of: location) { newValue in
                    print("Location changed to \(newValue)" )
                }

                DatePicker("Fecha", selection: $sessionDate)
                    .onChange(of: sessionDate) { newValue in
                    }
            }
            Section ("Equipamiento") {
                Toggle("Bola disponible", isOn: $isBallAvailable)
                Toggle("Líneas disponibles", isOn: $areLinesAvailable)
            }
        }
        .navigationTitle("Nueva sesión")
        .toolbar {
            Button("Crear") {
                let newSession = Session(sessionId: UUID().uuidString,
                                         dateCreated: Date.now,
                                         location: location,
                                         sessionDate: sessionDate,
                                         players: [String](),
                                         matches: [Match](),
                                         isBallAvailable: isBallAvailable,
                                         areLinesAvailable: areLinesAvailable)
                
                print("The session date that's getting passed is \(sessionDate)")
                
                Task {
                    do {
                        try await SessionManager.shared.createNewSession(session: newSession)
                    } catch {
                        print(error)
                    }
                }
                dismiss()
            }
        }
        
    }
}

struct NewSession_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NewSession()
        }
    }
}
