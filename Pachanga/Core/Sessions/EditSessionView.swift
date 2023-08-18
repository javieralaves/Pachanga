//
//  EditSessionView.swift
//  Pachanga
//
//  Created by Javier Alaves on 17/8/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct EditSession: View {
    
    let session: Session
    
    // session details
    @State private var location: String = ""
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
        .navigationTitle("Detalles")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Button("Guardar") {
                    let data: [AnyHashable : Any] = [
                        Session.CodingKeys.location.rawValue : location,
                        Session.CodingKeys.sessionDate.rawValue : sessionDate,
                        Session.CodingKeys.isBallAvailable.rawValue : isBallAvailable,
                        Session.CodingKeys.areLinesAvailable.rawValue : areLinesAvailable
                    ]
                    
                    Task {
                        let sessionCollection = Firestore.firestore().collection("sessions")
                        try await sessionCollection.document(session.sessionId).updateData(data)
                    }
                }
            }
        }
        .onAppear {
            loadSession()
        }
    }
    
    func loadSession() {
        location = session.location
        sessionDate = session.sessionDate
        isBallAvailable = session.isBallAvailable
        areLinesAvailable = session.areLinesAvailable
    }
}

struct EditSession_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EditSession(session: Session(sessionId: "001",
                                         dateCreated: Date.now,
                                         location: "Restaurante Niza",
                                         sessionDate: Date.now.advanced(by: 86400),
                                         players: [],
                                         isBallAvailable: true,
                                         areLinesAvailable: false))
        }
    }
}
