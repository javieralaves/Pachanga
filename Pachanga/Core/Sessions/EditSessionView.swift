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
    
    // to dismiss view on save
    @Environment(\.dismiss) var dismiss
    
    let session: Session
    
    // session details
    @State private var location: String = ""
    @State private var sessionDate: Date = Date()
    
    // available fields, stored in form for now
    let fields = ["Club Muchavista", "Restaurante Xaloc", "Restaurante Niza", "Seis Perlas Campello"]
    
    var body: some View {
        
        Form {
            // session details
            Section ("Detalles") {
                Picker("Lugar", selection: $location) {
                    ForEach(fields, id: \.self) {
                        Text($0)
                    }
                }
                DatePicker("Fecha", selection: $sessionDate)
            }
        }
        .navigationTitle("Detalles")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                // save button
                Button("Guardar") {
                    let data: [AnyHashable : Any] = [
                        Session.CodingKeys.location.rawValue : location,
                        Session.CodingKeys.sessionDate.rawValue : sessionDate,
                    ]
                    Task {
                        let sessionCollection = Firestore.firestore().collection("sessions")
                        try await sessionCollection.document(session.sessionId).updateData(data)
                    }
                    dismiss()
                }
            }
        }
        .onAppear {
            updateSession()
        }
    }
    
    // update session data every time the view appears
    func updateSession() {
        location = session.location
        sessionDate = session.sessionDate
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
                                         matches: [],
                                         bringsBall: [],
                                         bringsLines: []))
        }
    }
}
