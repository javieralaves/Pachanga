//
//  SessionView.swift
//  Pachanga
//
//  Created by Javier Alaves on 18/8/23.
//

import SwiftUI

struct SessionView: View {
    
    @State var session: Session
    
    // bool to display sheet that appears after tapping on join button
    @State private var joinSheet: Bool = false
    
    var body: some View {
        
        NavigationStack {
            VStack {
                List {
                    // details section
                    Section ("Detalles") {
                        Text(session.location)
                        Text(session.sessionDate.formatted(date: .abbreviated, time: .shortened))
                    }
                    
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
        } catch {
            print(error)
        }
    }
    
    // function to remove myself from session
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
