//
//  SessionView.swift
//  Pachanga
//
//  Created by Javier Alaves on 18/8/23.
//

import SwiftUI

@MainActor
final class SessionViewModel: ObservableObject {
    
    @Published private var session: Session? = nil
    
    // fetch session given a session id and makes it the session in this view, for loading this screen
    func loadSession(session: Session) async throws {
        self.session = try await SessionManager.shared.getSession(sessionId: session.sessionId)
    }
    
    // adds player to session in db and reloads that player as the session in this view
    func addPlayer() {
        guard let session else { return }
        
        Task {
            try await SessionManager.shared.addPlayer(session: session)
            self.session = try await SessionManager.shared.getSession(sessionId: session.sessionId)
        }
    }
    
}

struct SessionView: View {
    
    @StateObject private var viewModel = SessionViewModel()
    var session: Session
    
    var body: some View {
        
        NavigationStack {
            VStack {
                List {
                    Section ("Detalles") {
                        Text(session.location)
                        Text(session.sessionDate.formatted(date: .abbreviated, time: .shortened))
                    }
                    
                    
                    if !session.players.isEmpty {
                        Section ("Jugadores") {
                            ForEach(session.players, id: \.userId) { player in
                                Text(player.userId)
                            }
                        }
                    }
                    
                    Section ("Atención") {
                        if session.players.count < 4 {
                            Text("Faltan \(4 - session.players.count) jugadores más")
                        }
                        if !session.isBallAvailable {
                            Text("Falta bola")
                        }
                        if !session.areLinesAvailable {
                            Text("Faltan líneas")
                        }
                    }
                    
                    
                    Button("Unirme") {
                        // need to update the players value in db with a new array with added player
                    }
                }
                
                // would be nice to show list of players who joined the session
                
            }
            .navigationTitle("Sesión")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                NavigationLink {
                    EditSession(session: session)
                } label: {
                    Text("Editar")
                }
            }
        }
    }
}

struct SessionView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        NavigationStack {
            SessionView(session: Session(sessionId: "001",
                                         dateCreated: Date.now,
                                         location: "Restaurante Niza",
                                         sessionDate: Date.now.advanced(by: 86400),
                                         players: [], // app is crashing when filling this up
                                         isBallAvailable: false,
                                         areLinesAvailable: false))
        }
    }
}
