//
//  NewSession.swift
//  Pachanga
//
//  Created by Javier Alaves on 15/8/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation // to generate UUID
import SwiftUI

struct NewSession: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var location: String = "Club Muchavista"
    @State private var sessionDate: Date = Date()
    
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
                
                DatePicker("Fecha", selection: $sessionDate)
            }
        }
        .navigationTitle("Nueva sesión")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Crear") {
                Task {
                    // generate an empty document inside sessions collection
                    let document = SessionManager.shared.sessionCollection.document()
                    let documentId = document.documentID
                    
                    // create data that gets passed into new session document
                    let data: [String:Any] = [
                        Session.CodingKeys.sessionId.rawValue : documentId,
                        Session.CodingKeys.dateCreated.rawValue : Timestamp(),
                        Session.CodingKeys.status.rawValue : "active",
                        Session.CodingKeys.location.rawValue : location,
                        Session.CodingKeys.sessionDate.rawValue : sessionDate,
                        Session.CodingKeys.members.rawValue : [String]()
                    ]
                    
                    // set data
                    try await document.setData(data, merge: false)
                    
                    // add myself to session
                    joinSession(sessionId: documentId)
                }
                
                dismiss()
            }
        }
    }
    
    private func joinSession(sessionId: String) {
        Task {
            // get authenticated user id
            let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
            
            // add user id to members array in session
            let data: [String:Any] = [
                Session.CodingKeys.members.rawValue : FieldValue.arrayUnion([userId])
            ]
            
            try await SessionManager.shared.sessionDocument(sessionId: sessionId).updateData(data)
                        
            // add user to session_members subcollection
            try await SessionManager.shared.addSessionMember(sessionId: sessionId,
                                                             userId: userId,
                                                             bringsBall: false,
                                                             bringsLines: false)
            
            dismiss()
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
