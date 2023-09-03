//
//  SessionView.swift
//  Pachanga
//
//  Created by Javier Alaves on 18/8/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct SessionView: View {
    
    @State var session: Session
    
    // bool to display sheet that appears after tapping on join button
    @State private var joinSheet: Bool = false
    
    // empty array of matches to be populated
    @State private var sessionMatches: [Match] = []
    
    var body: some View {
        
        NavigationStack {
            VStack {
                List {
                    // details section
                    Section {
                        Text(session.location)
                        Text(session.sessionDate.formatted(date: .abbreviated, time: .shortened))
                    }
                    
                    if session.status == "active" {
                        
                        // list of registered players
                        if !session.players.isEmpty {
                            Section {
                                ForEach(session.players, id: \.self) { player in
                                    HStack {
                                        // for testing purposes
                                        if currentUser() == "NwIseDznbPNs5KmZlsHBTsxcsFl2" {
                                            Text("Javier Alaves")
                                        } else {
                                            Text(player)
                                        }
                                        
                                        Spacer()
                                        if session.bringsBall.contains(player) {
                                            Text("🏐")
                                        }
                                        if session.bringsLines.contains(player) {
                                            Text("🪢")
                                        }
                                    }
                                }
                            } header: {
                                Text("Jugadores")
                            } footer: {
                                if session.players.count < 4 {
                                    Text("Faltan \(4 - session.players.count) jugadores más")
                                }
                            }
                        }
                        
                        // matches
                        Section ("Partidos") {
                            ForEach(sessionMatches, id: \.self) { match in
                                Text(match.matchId)
                            }
                            NavigationLink("Añadir partido") {
                                NewMatch(session: session)
                            }
                        }
                        
                        // match alerts
                        if(session.bringsBall.isEmpty || session.bringsLines.isEmpty) {
                            Section ("Atención") {
                                if session.bringsBall.isEmpty {
                                    Text("Falta bola")
                                }
                                if session.bringsLines.isEmpty {
                                    Text("Faltan líneas")
                                }
                            }
                        }
                        
                        // join/unjoin button
                        if(!session.players.contains(currentUser())) {
                            Button("Unirme") {
                                joinSheet.toggle()
                            }
                            .sheet(isPresented: $joinSheet) {
                                JoinSheet(session: session)
                                    .presentationDetents([.medium])
                            }
                        } else {
                            Button(role: .destructive) {
                                removePlayer()
                            } label: {
                                Text("Salirme")
                            }
                        }
                                                
                    }
                    
                    if session.status == "cancelled" {
                        Text("Esta sesión ha sido cancelada")
                    }

                }
                
            }
            .navigationTitle("Sesión")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if session.status == "active" {
                    NavigationLink {
                        EditSession(session: session)
                    } label: {
                        Text("Editar")
                    }                    
                }
            }
            .onAppear {
                Task {
                    // update session data
                    try await updateSession()
                }
            }
            .onChange(of: joinSheet) { _ in
                Task {
                    try await updateSession()
                }
            }
        }
    }
    
    // function that returns userId for authenticated user, for join button state
    func currentUser() -> String {
        // bser is always going to be verified so throw will never happen
        // but we still have to handle it anyway ¯\_(ツ)_/¯
        do {
            return try AuthenticationManager.shared.getAuthenticatedUser().uid
        } catch {
            print(error)
        }
        return ""
    }
    
    // function to refresh session data every time the view appears
    func updateSession() async throws {
        do {
            let updatedSession = try await SessionManager.shared.getSession(sessionId: session.sessionId)
            session.location = updatedSession.location
            session.sessionDate = updatedSession.sessionDate
            session.players = updatedSession.players
            session.bringsBall = updatedSession.bringsBall
            session.bringsLines = updatedSession.bringsLines
            
            sessionMatches = try await SessionManager.shared.getMatches(session: session)
        } catch {
            print(error)
        }
    }
    
    // function to remove myself from session
    func removePlayer() {
        Task {
            
            // get authenticated user
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            
            // check if user was bringing ball to remove reference
            if session.bringsBall.contains(authDataResult.uid) {
                let data: [String : Any] = [
                    Session.CodingKeys.bringsBall.rawValue : FieldValue.arrayRemove([authDataResult.uid])
                ]
                
                let sessionCollection = Firestore.firestore().collection("sessions")
                try await sessionCollection.document(session.sessionId).updateData(data)
            }
            
            // check if user was bringing lines to remove reference
            if session.bringsLines.contains(authDataResult.uid) {
                let data: [String : Any] = [
                    Session.CodingKeys.bringsLines.rawValue : FieldValue.arrayRemove([authDataResult.uid])
                ]
                
                let sessionCollection = Firestore.firestore().collection("sessions")
                try await sessionCollection.document(session.sessionId).updateData(data)
            }
            
            // remove player from session players array
            try await SessionManager.shared.removePlayer(session: session)
            
            // reload session by its id
            self.session = try await SessionManager.shared.getSession(sessionId: session.sessionId)
        }
    }
    
}

struct SessionView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationStack {
            SessionView(session: Session(sessionId: "001",
                                         dateCreated: Date.now,
                                         status: "cancelled",
                                         location: "Restaurante Niza",
                                         sessionDate: Date.now.advanced(by: 86400),
                                         players: [],
                                         matches: [],
                                         bringsBall: [],
                                         bringsLines: []))
        }
    }
}
