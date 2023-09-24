//
//  JoinSheet.swift
//  Pachanga
//
//  Created by Javier Alaves on 28/8/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseMessaging
import SwiftUI

struct JoinSheet: View {
    
    @State var session: Session
    
    @State private var bringingBall: Bool = false
    @State private var bringingLines: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section("Equipamiento") {
                        Toggle("Traigo bola", isOn: $bringingBall)
                        Toggle("Traigo lineas", isOn: $bringingLines)
                    }
                    Button {
                        Task {
                            joinSession()
                        }
                    } label: {
                        Text("Unirme")
                    }
                }
            }
        }
    }
    
    private func joinSession() {
        Task {
            // get authenticated user id
            let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
            
            // add user id to members array in session
            let data: [String:Any] = [
                Session.CodingKeys.members.rawValue : FieldValue.arrayUnion([userId])
            ]
            
            try await SessionManager.shared.sessionDocument(sessionId: session.sessionId).updateData(data)
                        
            // add user to session_members subcollection
            try await SessionManager.shared.addSessionMember(sessionId: session.sessionId,
                                                             userId: userId,
                                                             bringsBall: bringingBall,
                                                             bringsLines: bringingLines)
            
            // subscribe user to session notifications
            try await Messaging.messaging().subscribe(toTopic: session.sessionId)
            
            dismiss()
        }
    }
    
}

struct JoinSheet_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            JoinSheet(session: Session(sessionId: "001",
                                       dateCreated: Date.now,
                                       status: "active",
                                       location: "El Campello",
                                       sessionDate: Date.now,
                                       members: []))
        }
    }
}
