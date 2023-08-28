//
//  JoinSheet.swift
//  Pachanga
//
//  Created by Javier Alaves on 28/8/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct JoinSheet: View {
    
    @State var session: Session
    
    // form binding variables
    @State private var bringingBall: Bool = false
    @State private var bringingLines: Bool = false
    
    // to dismiss view on joining
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
                            do {
                                try await joinSession()
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        Text("Unirme")
                    }

                }
            }
        }
    }
    
    // function to add myself to session
    private func addPlayer() {
        Task {
            try await SessionManager.shared.addPlayer(session: session)
            self.session = try await SessionManager.shared.getSession(sessionId: session.sessionId)
        }
    }
    
    // function that gets triggered when tapping on join session button
    private func joinSession() async throws {
        // get authenticated user from auth model
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        
        // if user brings ball, add userId to bringsBall value in session
        if bringingBall {
            let data: [String : Any] = [
                Session.CodingKeys.bringsBall.rawValue : FieldValue.arrayUnion([authDataResult.uid])
            ]
            
            Task {
                let sessionCollection = Firestore.firestore().collection("sessions")
                try await sessionCollection.document(session.sessionId).updateData(data)
            }
        }
        
        // if user brings lines, add userId to bringsLines value in session
        if bringingLines {
            let data: [String : Any] = [
                Session.CodingKeys.bringsLines.rawValue : FieldValue.arrayUnion([authDataResult.uid])
            ]
            
            Task {
                let sessionCollection = Firestore.firestore().collection("sessions")
                try await sessionCollection.document(session.sessionId).updateData(data)
            }
        }
        
        // add player to session players array
        addPlayer()
        
        dismiss()
    }
}

struct JoinSheet_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            JoinSheet(session: Session(sessionId: "001",
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
