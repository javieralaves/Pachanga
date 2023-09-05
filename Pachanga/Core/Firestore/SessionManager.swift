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
    var status: String
    var location: String
    var sessionDate: Date
    var players: [String]
    var matches: [String]
    var bringsBall: [String]
    var bringsLines: [String]
    
    // custom init
    init(
        sessionId: String,
        dateCreated: Date,
        status: String,
        location: String,
        sessionDate: Date,
        players: [String],
        matches: [String],
        bringsBall: [String],
        bringsLines: [String]
    ) {
        self.sessionId = sessionId
        self.dateCreated = dateCreated
        self.status = status
        self.location = location
        self.sessionDate = sessionDate
        self.players = players
        self.matches = matches
        self.bringsBall = bringsBall
        self.bringsLines = bringsLines
    }
    
    // custom coding strategy
    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
        case dateCreated = "date_created"
        case status = "status"
        case location = "location"
        case sessionDate = "session_date"
        case players = "players"
        case matches = "matches"
        case bringsBall = "bringsBall"
        case bringsLines = "bringsLines"
    }
    
    // to load a session from db with decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sessionId = try container.decode(String.self, forKey: .sessionId)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        self.status = try container.decode(String.self, forKey: .status)
        self.location = try container.decode(String.self, forKey: .location)
        self.sessionDate = try container.decode(Date.self, forKey: .sessionDate)
        self.players = try container.decode([String].self, forKey: .players)
        self.matches = try container.decode([String].self, forKey: .matches)
        self.bringsBall = try container.decode([String].self, forKey: .bringsBall)
        self.bringsLines = try container.decode([String].self, forKey: .bringsLines)
    }
    
    // to encode session instance into db with encoder
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.sessionId, forKey: .sessionId)
        try container.encode(self.dateCreated, forKey: .dateCreated)
        try container.encode(self.status, forKey: .status)
        try container.encode(self.location, forKey: .location)
        try container.encode(self.sessionDate, forKey: .sessionDate)
        try container.encode(self.players, forKey: .players)
        try container.encode(self.matches, forKey: .matches)
        try container.encode(self.bringsBall, forKey: .bringsBall)
        try container.encode(self.bringsLines, forKey: .bringsLines)
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
    
    // reference to session players subcollection in the db
    private func sessionPlayersCollection(sessionId: String) -> CollectionReference {
        sessionDocument(sessionId: sessionId).collection("session_players")
    }
    
    // reference to a specific player in the session players subcollection by session id
    private func sessionPlayerDocument(sessionId: String, sessionPlayerId: String) -> DocumentReference {
        sessionPlayersCollection(sessionId: sessionId).document(sessionPlayerId)
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
        try await sessionCollection
            .whereField("session_date", isGreaterThan: Date.now)
            .whereField("status", isEqualTo: "active")
            .getDocuments(as: Session.self)
    }
    
    // add authenticated user to session players
    func addPlayer(session: Session) async throws {
        // get authenticated user from auth model
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        
        // set data I want to change in db
        let data: [String : Any] = [
            Session.CodingKeys.players.rawValue : FieldValue.arrayUnion([authDataResult.uid])
        ]
        
        // update data in session
        try await sessionDocument(sessionId: session.sessionId).updateData(data)
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
    
    func getMatches(session: Session) async throws -> [Match] {
        // reference for matches collection
        let matchesCollection = Firestore.firestore().collection("matches")
        
        // return an array of matches that have been created in session
        return try await matchesCollection.whereField("session_id", isEqualTo: session.sessionId).getDocuments(as: Match.self)
    }
    
    // add player to session of a specific id to subcollection
    func addSessionPlayer(sessionId: String, userId: String) async throws {
        
        // generate an empty document inside subcollection
        let document = sessionPlayersCollection(sessionId: sessionId).document()
        let documentId = document.documentID
        
        // create data that gets passed into session player document
        let data: [String:Any] = [
            SessionPlayer.CodingKeys.id.rawValue : documentId,
            SessionPlayer.CodingKeys.userId.rawValue : userId,
            SessionPlayer.CodingKeys.dateAdded.rawValue : Timestamp()
        ]
        
        // set data
        try await document.setData(data, merge: false)
    }
    
    func removeSessionPlayer(sessionId: String, sessionPlayerId: String) async throws {
        try await sessionPlayerDocument(sessionId: sessionId, sessionPlayerId: sessionPlayerId).delete()
    }
    
    func getAllSessionPlayers(sessionId: String) async throws -> [SessionPlayer] {
        try await sessionPlayersCollection(sessionId: sessionId).getDocuments(as: SessionPlayer.self)
    }
    
    func hasUserJoined(sessionId: String) async throws -> Bool {
        
        // variable to control the boolean
        var hasJoined = false
        
        // authenticated user id
        let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
        
        // array of session players from session
        let sessionPlayers = try await getAllSessionPlayers(sessionId: sessionId)
        
        // check through array to see if userId is contained
        for player in sessionPlayers {
            if player.userId == userId {
                hasJoined = true
                break
            }
        }
        
        // return the bool, true if user is a session player
        return hasJoined
    }
    
}

struct SessionPlayer: Codable {
    let id: String
    let userId: String
    let dateAdded: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case dateAdded = "date_added"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.dateAdded = try container.decode(Date.self, forKey: .dateAdded)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.dateAdded, forKey: .dateAdded)
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
