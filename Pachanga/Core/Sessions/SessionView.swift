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
    
    // empty array of members to be populated onAppear
    @State private var sessionMembers: [(sessionMember: SessionMember, user: DBUser)] = []
    
    // empty array of matches to be populated onAppear
    @State private var sessionMatches: [(sessionMatch: SessionMatch, t1p1: DBUser, t1p2: DBUser, t2p1: DBUser, t2p2: DBUser)] = []
    
    // variable to load the average session rating
    @State private var sessionRating: Double = 0.0
    
    // equipment variables
    @State private var ballAvailable: Bool = false
    @State private var linesAvailable: Bool = false
    
    // bool to display sheet that appears after tapping on join button
    @State private var joinSheet: Bool = false
    
    // variable that controls whether user is a session member
    @State private var isMember: Bool = false
    
    var body: some View {
        
        NavigationStack {
            VStack {
                List {
                    // details
                    Section {
                        Text(session.location)
                        Text(session.sessionDate.formatted(date: .abbreviated, time: .shortened))
                        Text("Nivel: \(sessionRating, specifier: "%.2f")")
                    }
                    
                    if session.status == "active" {
                        
                        // session members
                        if !sessionMembers.isEmpty {
                            Section {
                                ForEach(sessionMembers, id: \.sessionMember.id) { member in
                                    HStack {
                                        if let name = member.user.name {
                                            Text(name)
                                        }
                                        Spacer()
                                        if member.sessionMember.bringsBall {
                                            Text("🏐")
                                        }
                                        if member.sessionMember.bringsLines {
                                            Text("🪢")
                                        }
                                    }
                                }
                            } header: {
                                Text("Jugadores")
                            } footer: {
                                if sessionMembers.count < 4 {
                                    Text("Faltan \(4 - sessionMembers.count) jugadores más")
                                }
                            }
                        }
                        
                        // matches
                        Section ("Partidos") {
                            ForEach(sessionMatches, id: \.sessionMatch.id) { match in
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        if let t1p1 = match.t1p1.name, let t1p2 = match.t1p2.name {
                                            Text("\(t1p1) y \(t1p2)")
                                        }
                                        Spacer()
                                        Text("\(match.sessionMatch.scoreOne)")
                                            .foregroundColor(.secondary)
                                    }
                                    HStack {
                                        if let t2p1 = match.t2p1.name, let t2p2 = match.t2p2.name {
                                            Text("\(t2p1) y \(t2p2)")
                                        }
                                        Spacer()
                                        Text("\(match.sessionMatch.scoreTwo)")
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }

                            NavigationLink("Añadir partido") {
                                NewMatchView(session: session,
                                             sessionMembers: sessionMembers)
                            }
                        }
                        
                        // match alerts
                        if(!ballAvailable || !linesAvailable) {
                            Section ("Atención") {
                                if !ballAvailable {
                                    Text("Falta bola")
                                }
                                if !linesAvailable {
                                    Text("Faltan líneas")
                                }
                            }
                        }
                        
                        // join/unjoin button
                        if !isMember {
                            Button("Unirme") {
                                joinSheet.toggle()
                            }
                            .sheet(isPresented: $joinSheet) {
                                JoinSheet(session: session)
                                    .presentationDetents([.medium])
                            }
                        } else {
                            Button(role: .destructive) {
                                removeMember()
                            } label: {
                                Text("Salirme")
                            }
                        }
                        
                    }
                    
                    if session.status == "cancelled" {
                        Text("Esta sesión ha sido cancelada.")
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
                    updateSession()
                }
            }
            .onChange(of: joinSheet) { _ in
                Task {
                    updateSession()
                }
            }
            .onChange(of: isMember) { _ in
                Task {
                    updateSession()
                }
            }
        }
    }
    
    func updateSession() {
        Task {
            // refresh variables
            let updatedSession = try await SessionManager.shared.getSession(sessionId: session.sessionId)
            session.location = updatedSession.location
            session.sessionDate = updatedSession.sessionDate
            session.status = updatedSession.status
            print("Session happening in \(session.location) on \(session.sessionDate).")
            
            // check if player is a member of the session
            let hasJoined = try await SessionManager.shared.hasUserJoined(sessionId: session.sessionId)
            self.isMember = hasJoined
            print("Is user a member of this session? \(hasJoined.description).")
            
            // get members
            let sessionMembers = try await SessionManager.shared.getAllSessionMembers(sessionId: session.sessionId)
            print("There are currently \(sessionMembers.count) members in the session_members subcollection.")
            
            var localMembers: [(sessionMember: SessionMember, user: DBUser)] = []
            for member in sessionMembers {
                if let user = try? await UserManager.shared.getUser(userId: member.userId) {
                    localMembers.append((member, user))
                }
            }
            
            self.sessionMembers = localMembers
            print("Members have been added to local array. Count is \(sessionMembers.count).")
            
            // calculate the average session rating
            sessionRating = try await SessionManager.shared.getSessionRating(session: session)
            
            // ball check
            for member in sessionMembers {
                if member.bringsBall {
                    self.ballAvailable = true
                    break
                }
            }
            
            // lines check
            for member in sessionMembers {
                if member.bringsLines {
                    self.linesAvailable = true
                    break
                }
            }
            
            // get matches
            let sessionMatches = try await SessionManager.shared.getAllSessionMatches(sessionId: session.sessionId)
            print("There are currently \(sessionMatches.count) matches in the session_matches subcollection.")
            
            var localMatches: [(sessionMatch: SessionMatch, t1p1: DBUser, t1p2: DBUser, t2p1: DBUser, t2p2: DBUser)] = []
            
            for match in sessionMatches {
                let t1p1 = try await UserManager.shared.getUser(userId: match.t1p1)
                let t1p2 = try await UserManager.shared.getUser(userId: match.t1p2)
                let t2p1 = try await UserManager.shared.getUser(userId: match.t2p1)
                let t2p2 = try await UserManager.shared.getUser(userId: match.t2p2)
                
                localMatches.append((match, t1p1, t1p2, t2p1, t2p2))
            }
            
            // update sessionMatches with localMatches
            self.sessionMatches = localMatches
            
        }
    }
    
    // function to remove myself from session
    func removeMember() {
        Task {
            // get my id
            let myId = try AuthenticationManager.shared.getAuthenticatedUser().uid
            
            // get all session members
            let sessionMembers = self.sessionMembers
            
            // initialize an empty sessionMemberId to be filled below
            var sessionMemberId = ""
            
            // check if session member userId matches my id & take the sessionMemberId and store it somewhere
            for member in sessionMembers {
                if (member.user.userId == myId) {
                    sessionMemberId = member.sessionMember.id
                    break
                }
            }
            
            try await SessionManager.shared.removeSessionMember(sessionId: session.sessionId,
                                                                sessionMemberId: sessionMemberId)
            
            // remove user id from members array in session
            let data: [String:Any] = [
                Session.CodingKeys.members.rawValue : FieldValue.arrayRemove([myId])
            ]
            
            try await SessionManager.shared.sessionDocument(sessionId: session.sessionId).updateData(data)
            
            updateSession()
        }
    }
    
}

struct SessionView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationStack {
            SessionView(session: Session(sessionId: "",
                                         dateCreated: Date.now,
                                         status: "active",
                                         location: "El Campello",
                                         sessionDate: Date.now,
                                         members: []))
        }
    }
}
