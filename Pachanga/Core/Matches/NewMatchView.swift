//
//  NewMatchView.swift
//  Pachanga
//
//  Created by Javier Alaves on 6/9/23.
//

import SwiftUI

struct NewMatchView: View {
    
    let session: Session
    let sessionMembers: [(sessionMember: SessionMember, user: DBUser)]
    
    @State private var t1p1: String = ""
    @State private var t1p2: String = ""
    @State private var t2p1: String = ""
    @State private var t2p2: String = ""
    
    @State private var score1: Int = 0
    @State private var score2: Int = 0
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section("Primer equipo") {
                        Picker("Primer jugador", selection: $t1p1) {
                            if t1p1 == "" {
                                Text("").tag("Placeholder")
                            }
                            ForEach(sessionMembers, id: \.sessionMember.id) { member in
                                if let name = member.user.name {
                                    Text(name)
                                }
                            }
                        }
                        Picker("Segundo jugador", selection: $t1p2) {
                            if t1p2 == "" {
                                Text("").tag("Placeholder")
                            }
                            ForEach(sessionMembers, id: \.sessionMember.id) { member in
                                if let name = member.user.name {
                                    Text(name)
                                }
                            }
                        }
                    }
                    
                    Section("Segundo equipo") {
                        Picker("Primer jugador", selection: $t2p1) {
                            if t2p1 == "" {
                                Text("").tag("Placeholder")
                            }
                            ForEach(sessionMembers, id: \.sessionMember.id) { member in
                                if let name = member.user.name {
                                    Text(name)
                                }
                            }
                        }
                        Picker("Segundo jugador", selection: $t2p2) {
                            if t2p2 == "" {
                                Text("").tag("Placeholder")
                            }
                            ForEach(sessionMembers, id: \.sessionMember.id) { member in
                                if let name = member.user.name {
                                    Text(name)
                                }
                            }
                        }
                    }
                    
                    Section("Resultado") {
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
                    
                    Button("Guardar") {
                        Task {
                            try await SessionManager.shared.addSessionMatch(session: session,
                                                                  t1p1: t1p1,
                                                                  t1p2: t1p2,
                                                                  t2p1: t2p1,
                                                                  t2p2: t2p2,
                                                                  score1: score1,
                                                                  score2: score2)
                        }
                        
                        dismiss()
                    }
                }
            }
        }
    }
}

//struct NewMatchView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewMatchView()
//    }
//}
