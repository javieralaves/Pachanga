//
//  NewMatch.swift
//  Pachanga
//
//  Created by Javier Alaves on 29/8/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct NewMatch: View {
    
    // dismiss view on save
    @Environment(\.dismiss) var dismiss
    
    // session associated to match that gets passed in
    let session: Session
    
    // player values initialized as empty strings
    @State private var t1p1: String = ""
    @State private var t1p2: String = ""
    @State private var t2p1: String = ""
    @State private var t2p2: String = ""
    
    // score values initialized at zero
    @State private var score1: Int = 0
    @State private var score2: Int = 0
    
    var body: some View {
        
        NavigationStack {
            VStack {
                Form {
                    // team one
                    Section ("Primer equipo") {
                        Picker("Primer jugador", selection: $t1p1) {
                            
                            // placeholder
                            if t1p1 == "" {
                                Text("Selecciona...").tag("Placeholder")
                            }
                            
                            ForEach(session.players, id: \.self) {
                                Text($0)
                            }
                        }
                        Picker("Segundo jugador", selection: $t1p2) {
                            
                            // placeholder
                            if t1p2 == "" {
                                Text("Selecciona...").tag("Placeholder")
                            }
                            
                            ForEach(session.players, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                    
                    // team two
                    Section ("Segundo equipo") {
                        Picker("Primer jugador", selection: $t2p1) {
                            
                            // placeholder
                            if t2p1 == "" {
                                Text("Selecciona...").tag("Placeholder")
                            }
                            
                            ForEach(session.players, id: \.self) {
                                Text($0)
                            }
                        }
                        Picker("Segundo jugador", selection: $t2p2) {
                            
                            // placeholder
                            if t2p2 == "" {
                                Text("Selecciona...").tag("Placeholder")
                            }
                            
                            ForEach(session.players, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                    
                    // score
                    Section ("Resultado") {
                        HStack {
                            Text("Primer equipo:")
                            TextField("Primer equipo", value: $score1, format: .number)
                                .keyboardType(.decimalPad)
                        }
                        HStack {
                            Text("Segundo equipo:")
                            TextField("Segundo equipo", value: $score2, format: .number)
                                .keyboardType(.decimalPad)
                        }
                    }
                }
            }
            .navigationTitle("Nuevo partido")
            .toolbar {
                Button("Crear") {
                    
                    let newMatch = Match(session: session,
                                         players: session.players,
                                         teamOne: [t1p1, t1p2],
                                         teamTwo: [t2p1, t2p2],
                                         teamOneScore: score1,
                                         teamTwoScore: score2,
                                         isRanked: false)
                    
                    
                    Task {
                        do {
                            // create match in database
                            try await MatchManager.shared.createNewMatch(match: newMatch)
                            
                            // add match id to session
                            
                            
                        } catch {
                            print(error)
                        }
                    }
                    
                }
            }
        }
    }
    
}

struct NewMatch_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NewMatch(session: Session(sessionId: "001",
                                      dateCreated: Date.now,
                                      location: "Restaurante Niza",
                                      sessionDate: Date.now.advanced(by: 86400),
                                      players: ["Javier Alaves",
                                               "Alvaro Perez",
                                               "Diego Cortes",
                                               "Nacho Alaves"],
                                      matches: [],
                                      bringsBall: [],
                                      bringsLines: []))
        }
    }
}
