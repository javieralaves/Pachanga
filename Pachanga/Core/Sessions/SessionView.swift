//
//  SessionView.swift
//  Pachanga
//
//  Created by Javier Alaves on 18/8/23.
//

import SwiftUI

struct SessionView: View {
    
    @State var session: Session
    
    var body: some View {
        
        NavigationStack {
            VStack {
                List {
                    Section ("Detalles") {
                        Text(session.location)
                        Text(session.sessionDate.formatted(date: .abbreviated, time: .shortened))
                    }
                    
                    Section {
                        ForEach(session.players, id: \.self) { player in
                            if(player == "NwIseDznbPNs5KmZlsHBTsxcsFl2") {
                                Text("Javier Alavés")
                            } else {
                                Text("Ignacio Alavés")
                            }
                        }
                        
                    } header: {
                        Text("Jugadores")
                    } footer: {
                        if session.players.count < 4 {
                            Text("Faltan \(4 - session.players.count) jugadores más")
                        }
                    }

                    if(!session.isBallAvailable || !session.areLinesAvailable) {
                        Section ("Atención") {
                            if !session.isBallAvailable {
                                Text("Falta bola")
                            }
                            if !session.areLinesAvailable {
                                Text("Faltan líneas")
                            }
                        }
                    }
                    
                    if(!session.players.contains(verifiedPlayerId())) {
                        Button("Unirme") {
                            addPlayer()
                        }
                    } else {
                        Button(role: .destructive) {
                            removePlayer()
                        } label: {
                            Text("Salirme")
                        }
                    }
                }
                                
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
            .onAppear {
                Task {
                    try await updateSession()
                }
            }
        }
    }
    
    func verifiedPlayerId() -> String {
        // User is always going to be verified so throw will never happen
        // But we still have to handle it anyway ¯\_(ツ)_/¯
        do {
            return try AuthenticationManager.shared.getAuthenticatedUser().uid
        } catch {
            print(error)
        }
        return ""
    }
    
    func updateSession() async throws {
        do {
            let updatedSession = try await SessionManager.shared.getSession(sessionId: session.sessionId)
            session.location = updatedSession.location
            session.sessionDate = updatedSession.sessionDate
            session.players = updatedSession.players
            session.isBallAvailable = updatedSession.isBallAvailable
            session.areLinesAvailable = updatedSession.areLinesAvailable
        } catch {
            print(error)
        }
    }

    func addPlayer() {
        Task {
            try await SessionManager.shared.addPlayer(session: session)
            self.session = try await SessionManager.shared.getSession(sessionId: session.sessionId)
            print("Completed!")
        }
    }
    
    func removePlayer() {
        Task {
            try await SessionManager.shared.removePlayer(session: session)
            self.session = try await SessionManager.shared.getSession(sessionId: session.sessionId)
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
                                         players: [],
                                         matches: [],
                                         bringsBall: [],
                                         bringsLines: []))
        }
    }
}
