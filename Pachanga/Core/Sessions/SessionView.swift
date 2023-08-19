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
                            Text(player)
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
                    
                    Button("Unirme") {
                        addPlayer()
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
        }
    }
    
    func addPlayer() {
        Task {
            try await SessionManager.shared.addPlayer(session: session)
            self.session = try await SessionManager.shared.getSession(sessionId: session.sessionId)
            print("Completed!")
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
