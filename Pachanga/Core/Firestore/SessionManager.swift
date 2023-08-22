//
//  SessionManager.swift
//  Pachanga
//
//  Created by Javier Alaves on 14/8/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation
import SwiftUI

struct Session: Codable {
    
    // props
    let sessionId: String
    let dateCreated: Date
    var location: String
    var sessionDate: Date
    var players: [String]
    var matches: [String]
    var isBallAvailable: Bool = false
    var areLinesAvailable: Bool = false
    
    // custom init
    init(
        sessionId: String,
        dateCreated: Date,
        location: String,
        sessionDate: Date,
        players: [String],
        matches: [String],
        isBallAvailable: Bool,
        areLinesAvailable: Bool
    ) {
        self.sessionId = sessionId
        self.dateCreated = dateCreated
        self.location = location
        self.sessionDate = sessionDate
        self.players = players
        self.matches = matches
        self.isBallAvailable = isBallAvailable
        self.areLinesAvailable = areLinesAvailable
    }
    
    // custom coding strategy
    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
        case dateCreated = "date_created"
        case location = "location"
        case sessionDate = "session_date"
        case players = "players"
        case matches = "matches"
        case isBallAvailable = "is_ball_available"
        case areLinesAvailable = "are_lines_available"
    }
    
    // to load a session from db with decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sessionId = try container.decode(String.self, forKey: .sessionId)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        self.location = try container.decode(String.self, forKey: .location)
        self.sessionDate = try container.decode(Date.self, forKey: .sessionDate)
        self.players = try container.decode([String].self, forKey: .players)
        self.matches = try container.decode([String].self, forKey: .matches)
        self.isBallAvailable = try container.decode(Bool.self, forKey: .isBallAvailable)
        self.areLinesAvailable = try container.decode(Bool.self, forKey: .areLinesAvailable)
    }
    
    // to encode session instance into db with encoder
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.sessionId, forKey: .sessionId)
        try container.encode(self.dateCreated, forKey: .dateCreated)
        try container.encode(self.location, forKey: .location)
        try container.encode(self.sessionDate, forKey: .sessionDate)
        try container.encode(self.players, forKey: .players)
        try container.encode(self.matches, forKey: .matches)
        try container.encode(self.isBallAvailable, forKey: .isBallAvailable)
        try container.encode(self.areLinesAvailable, forKey: .areLinesAvailable)
    }
    
}

final class SessionManager {
    
    static let shared = SessionManager()
    private init() { }
    
    // reference to the sessions collection in the db
    private let sessionCollection = Firestore.firestore().collection("sessions")
    
    // reference to a specific session in the sessions db by session id
    private func sessionDocument(sessionId: String) -> DocumentReference {
        sessionCollection.document(sessionId)
    }
    
    // push new session to db
    func createNewSession(session: Session) async throws {
        try sessionDocument(sessionId: session.sessionId).setData(from: session, merge: false)
    }
    
    // get session by id
    func getSession(sessionId: String) async throws -> Session {
        try await sessionDocument(sessionId: sessionId).getDocument(as: Session.self)
    }
    
    // get all sessions from db
    func getAllSessions() async throws -> [Session] {
        try await sessionCollection.getDocuments(as: Session.self)
    }
    
    // returns array of sessions sorted by the session date
    func getAllSessionsSortedByDate() async throws -> [Session] {
        try await sessionCollection.order(by: "session_date", descending: false).getDocuments(as: Session.self)
    }
    
    // get all sessions in the future
    func getAllUpcomingSessions() async throws -> [Session] {
        try await sessionCollection.whereField("session_date", isGreaterThan: Date.now).getDocuments(as: Session.self)
    }
    
    // add authenticated user to session players
    func addPlayer(session: Session) async throws {
        // get authenticated user from auth model
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        print("Received id: \(authDataResult.uid)")
        
        // set data I want to change in db
        let data: [String : Any] = [
            Session.CodingKeys.players.rawValue : FieldValue.arrayUnion([authDataResult.uid])
        ]
        
        // update data in session
        print("Updating data in session: \(session.sessionId)... there are currently \(session.players.count) players")
        try await sessionDocument(sessionId: session.sessionId).updateData(data)
        print("And now, there are \(session.players.count) players")
    }
    
    // remove authenticated user from session players
    func removePlayer(session: Session) async throws {
        // get authenticated user from auth model
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        
        // set data I want to change in db
        let data: [String : Any] = [
            Session.CodingKeys.players.rawValue : FieldValue.arrayRemove([authDataResult.uid])
        ]
        
        // update data in session
        try await sessionDocument(sessionId: session.sessionId).updateData(data)
    }
    
    
}

extension Query {
    
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        let snapshot = try await self.getDocuments()
        
        return try snapshot.documents.map({ document in
            try document.data(as: T.self)
        })
    }
    
}
