//
//  SessionView.swift
//  Pachanga
//
//  Created by Javier Alaves on 18/8/23.
//

import SwiftUI

struct SessionView: View {
    
    let session: Session
    
    var body: some View {
        
        NavigationStack {
            VStack {
                Text(session.location)
                Text(session.sessionDate.formatted(date: .abbreviated, time: .shortened))
                
                if !session.isBallAvailable {
                    Text("Falta bola")
                }
                
                if !session.areLinesAvailable {
                    Text("Faltan líneas")
                }
                
                Button("Unirme") {
                    // get userid with auth, pass to get dbuser, and add db user to session [players]
                    // if i'm already in, this would be an option to leave
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
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SessionView(session: Session(sessionId: "001",
                                         dateCreated: Date.now,
                                         location: "Restaurante Niza",
                                         sessionDate: Date.now.advanced(by: 86400),
                                         players: [],
                                         isBallAvailable: false,
                                         areLinesAvailable: false))
        }
    }
}
