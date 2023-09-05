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
    
    // session getting passed into view
    @State var session: Session
    
    // empty array of players to be populated in view
    // includes reference to both the session player and the underlying user
    @State private var sessionPlayers: [(sessionPlayer: SessionPlayer, user: DBUser)] = []
    
    // bool to display sheet that appears after tapping on join button
    @State private var joinSheet: Bool = false
    
    // empty array of matches to be populated
    @State private var sessionMatches: [Match] = []
    
    // whether user is part of session or not
    @State private var isPlayer: Bool = false
    
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
                        if !sessionPlayers.isEmpty {
                            Section {
                                ForEach(sessionPlayers, id: \.sessionPlayer.id.self) { player in
                                    HStack {
                                        Text(player.user.name ?? "Juan Doe")
                                        
                                        Spacer()
                                        if session.bringsBall.contains(player.user.userId) {
                                            Text("🏐")
                                        }
                                        if session.bringsLines.contains(player.user.userId) {
                                            Text("🪢")
                                        }
                                    }
                                }
                            } header: {
                                Text("Jugadores")
                            } footer: {
                                if sessionPlayers.count < 4 {
                                    Text("Faltan \(4 - sessionPlayers.count) jugadores más")
                                }
                            }
                        }
                        
                        // matches
                        Section ("Partidos") {
                            ForEach(sessionMatches, id: \.self) { match in
                                NavigationLink {
                                    EditMatchView(match: match)
                                } label: {
                                    MatchCell(match: match)
                                }
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
                        
                        Text("Is user in this session? \(isPlayer.description)")
                        
                        // join/unjoin button
                        
                        if !isPlayer {
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
                        
                        
                        
                        // join/unjoin button
//                        if(!session.players.contains(currentUser())) {
//                            Button("Unirme") {
//                                joinSheet.toggle()
//                            }
//                            .sheet(isPresented: $joinSheet) {
//                                JoinSheet(session: session)
//                                    .presentationDetents([.medium])
//                            }
//                        } else {
//                            Button(role: .destructive) {
//                                removePlayer()
//                            } label: {
//                                Text("Salirme")
//                            }
//                        }
                                                
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
                    // check if user is player
                    isPlayer = try await hasJoined()
                    
                    // get players
                    getSessionPlayers()
                    
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
    
    // returns an array of SessionPlayer containing all players added to session players subcollection
    func getSessionPlayers() {
        Task {
            let sessionPlayers = try await SessionManager.shared.getAllSessionPlayers(sessionId: session.sessionId)
            
            var localArray: [(sessionPlayer: SessionPlayer, user: DBUser)] = []
            for sessionPlayer in sessionPlayers {
                if let player = try? await UserManager.shared.getUser(userId: sessionPlayer.userId) {
                    localArray.append((sessionPlayer, player))
                }
            }
            
            self.sessionPlayers = localArray
        }
    }
    
    // function to refresh session data every time the view appears
    func updateSession() async throws {
        do {
            let updatedSession = try await SessionManager.shared.getSession(sessionId: session.sessionId)
            session.status = updatedSession.status
            session.location = updatedSession.location
            session.sessionDate = updatedSession.sessionDate
            session.players = updatedSession.players
            session.bringsBall = updatedSession.bringsBall
            session.bringsLines = updatedSession.bringsLines
            
            sessionMatches = try await SessionManager.shared.getMatches(session: session)
            getSessionPlayers()
        } catch {
            print(error)
        }
    }
    
    func hasJoined() async throws -> Bool {
        try await SessionManager.shared.hasUserJoined(sessionId: session.sessionId)
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
            
            // get the sessionPlayerId for the authenticated userId
            var sessionPlayerId = ""
            
            for player in sessionPlayers {
                if player.user.userId == authDataResult.uid {
                    sessionPlayerId = player.sessionPlayer.id
                    break
                }
            }
            
            // remove player from session players subcollection with the sessionPlayerId associated to userId
            try await SessionManager.shared.removeSessionPlayer(sessionId: session.sessionId, sessionPlayerId: sessionPlayerId)
            
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
                                         status: "active",
                                         location: "Restaurante Niza",
                                         sessionDate: Date.now.advanced(by: 86400),
                                         players: [],
                                         matches: [],
                                         bringsBall: [],
                                         bringsLines: []))
        }
    }
}
