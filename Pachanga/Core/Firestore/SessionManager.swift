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
    
    // custom init
    init(
        sessionId: String,
        dateCreated: Date,
        status: String,
        location: String,
        sessionDate: Date
    ) {
        self.sessionId = sessionId
        self.dateCreated = dateCreated
        self.status = status
        self.location = location
        self.sessionDate = sessionDate
    }
    
    // custom coding strategy
    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
        case dateCreated = "date_created"
        case status = "status"
        case location = "location"
        case sessionDate = "session_date"
    }
    
    // to load a session from db with decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sessionId = try container.decode(String.self, forKey: .sessionId)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        self.status = try container.decode(String.self, forKey: .status)
        self.location = try container.decode(String.self, forKey: .location)
        self.sessionDate = try container.decode(Date.self, forKey: .sessionDate)
    }
    
    // to encode session instance into db with encoder
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.sessionId, forKey: .sessionId)
        try container.encode(self.dateCreated, forKey: .dateCreated)
        try container.encode(self.status, forKey: .status)
        try container.encode(self.location, forKey: .location)
        try container.encode(self.sessionDate, forKey: .sessionDate)
    }
    
}

final class SessionManager {
    
    static let shared = SessionManager()
    private init() { }
    
    // MARK: collection functions
    
    // reference to the sessions collection in the db
    let sessionCollection = Firestore.firestore().collection("sessions")
    
    // reference to a specific session in the sessions db by session id
    func sessionDocument(sessionId: String) -> DocumentReference {
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
        try await sessionCollection
            .whereField("session_date", isGreaterThan: Date.now)
            .whereField("status", isEqualTo: "active")
            .getDocuments(as: Session.self)
    }
    
    // MARK: session_members subcollection
    
    //  subcollection reference
    func sessionMembersCollection(sessionId: String) -> CollectionReference {
        sessionDocument(sessionId: sessionId).collection("session_members")
    }
    
    // session member document reference
    func sessionMemberDocument(sessionId: String, sessionMemberId: String) -> DocumentReference {
        sessionMembersCollection(sessionId: sessionId).document(sessionMemberId)
    }
    
    // add user to session as session member
    func addSessionMember(sessionId: String, userId: String, bringsBall: Bool, bringsLines: Bool) async throws {
        
        // generate an empty document inside subcollection
        let document = sessionMembersCollection(sessionId: sessionId).document()
        let documentId = document.documentID
        
        // create data that gets passed into session player document
        let data: [String:Any] = [
            SessionMember.CodingKeys.id.rawValue : documentId,
            SessionMember.CodingKeys.userId.rawValue : userId,
            SessionMember.CodingKeys.bringsBall.rawValue : bringsBall,
            SessionMember.CodingKeys.bringsLines.rawValue : bringsLines,
            SessionMember.CodingKeys.dateAdded.rawValue : Timestamp()
        ]
        
        // set data
        try await document.setData(data, merge: false)
    }
    
    // remove member from session
    func removeSessionMember(sessionId: String, sessionMemberId: String) async throws {
        try await sessionMemberDocument(sessionId: sessionId, sessionMemberId: sessionMemberId).delete()
    }
    
    // return session member given the session id and document id
    func getSessionMember(sessionId: String, sessionMemberId: String) async throws -> SessionMember {
        try await sessionMemberDocument(sessionId: sessionId, sessionMemberId: sessionMemberId).getDocument(as: SessionMember.self)
    }
    
    // return an array of session members for a given session
    func getAllSessionMembers(sessionId: String) async throws -> [SessionMember] {
        try await sessionMembersCollection(sessionId: sessionId).getDocuments(as: SessionMember.self)
    }
    
    // check if authenticated user has joined for any given session
    func hasUserJoined(sessionId: String) async throws -> Bool {
        // variable to control the boolean
        var hasJoined = false
        
        // authenticated user id
        let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
        
        // array of session players from session
        let sessionMembers = try await getAllSessionMembers(sessionId: sessionId)
        
        // check through array to see if userId is contained
        for player in sessionMembers {
            if player.userId == userId {
                hasJoined = true
                break
            }
        }
        
        // return the bool, true if user is a session player
        return hasJoined
    }
    
    // MARK: session_matches subcollection
    
    // reference to session matches subcollection in the db
    func sessionMatchesCollection(sessionId: String) -> CollectionReference {
        sessionDocument(sessionId: sessionId).collection("session_matches")
    }
    
    // reference to a specific match in the session matches subcollection by session id
    func sessionMatchDocument(sessionId: String, sessionMatchId: String) -> DocumentReference {
        sessionMatchesCollection(sessionId: sessionId).document(sessionMatchId)
    }
    
    // adds a match to a session subcollection
    func addSessionMatch(session: Session, t1p1: String, t1p2: String, t2p1: String, t2p2: String, score1: Int, score2: Int) async throws {
        
        // generate an empty document inside subcollection
        let document = sessionMatchesCollection(sessionId: session.sessionId).document()
        let documentId = document.documentID
        
        // create data that gets passed into session match document
        let data: [String:Any] = [
            SessionMatch.CodingKeys.id.rawValue : documentId,
            SessionMatch.CodingKeys.sessionId.rawValue : session.sessionId,
            SessionMatch.CodingKeys.dateCreated.rawValue : Timestamp(),
            SessionMatch.CodingKeys.location.rawValue : session.location,
            SessionMatch.CodingKeys.matchDate.rawValue : session.sessionDate,
            SessionMatch.CodingKeys.t1p1.rawValue : t1p1,
            SessionMatch.CodingKeys.t1p2.rawValue : t1p2,
            SessionMatch.CodingKeys.t2p1.rawValue : t2p1,
            SessionMatch.CodingKeys.t2p2.rawValue : t2p2,
            SessionMatch.CodingKeys.scoreOne.rawValue : score1,
            SessionMatch.CodingKeys.scoreTwo.rawValue : score2
        ]
        
        // set data
        try await document.setData(data, merge: false)
    }
    
    // removes a session match from the session subcollection
    func removeSessionMatch(sessionId: String, sessionMatchId: String) async throws {
        try await sessionMatchDocument(sessionId: sessionId, sessionMatchId: sessionMatchId).delete()
    }
    
    // return an array of session matches for a given session
    func getAllSessionMatches(sessionId: String) async throws -> [SessionMatch] {
        try await sessionMatchesCollection(sessionId: sessionId).getDocuments(as: SessionMatch.self)
    }
    
}

struct SessionMember: Codable, Identifiable {
    let id: String
    let userId: String
    var bringsBall: Bool
    var bringsLines: Bool
    let dateAdded: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case bringsBall = "brings_ball"
        case bringsLines = "brings_lines"
        case dateAdded = "date_added"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.bringsBall = try container.decode(Bool.self, forKey: .bringsBall)
        self.bringsLines = try container.decode(Bool.self, forKey: .bringsLines)
        self.dateAdded = try container.decode(Date.self, forKey: .dateAdded)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.bringsBall, forKey: .bringsBall)
        try container.encode(self.bringsLines, forKey: .bringsLines)
        try container.encode(self.dateAdded, forKey: .dateAdded)
    }
}

struct SessionMatch: Codable, Identifiable {
    let id: String
    let sessionId: String
    let dateCreated: Date
    var location: String
    var matchDate: Date
    var t1p1: String
    var t1p2: String
    var t2p1: String
    var t2p2: String
    var scoreOne: Int
    var scoreTwo: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case sessionId = "session_id"
        case dateCreated = "date_created"
        case location = "location"
        case matchDate = "match_date"
        case t1p1 = "t1p1"
        case t1p2 = "t1p2"
        case t2p1 = "t2p1"
        case t2p2 = "t2p2"
        case scoreOne = "score_one"
        case scoreTwo = "score_two"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.sessionId = try container.decode(String.self, forKey: .sessionId)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        self.location = try container.decode(String.self, forKey: .location)
        self.matchDate = try container.decode(Date.self, forKey: .matchDate)
        self.t1p1 = try container.decode(String.self, forKey: .t1p1)
        self.t1p2 = try container.decode(String.self, forKey: .t1p2)
        self.t2p1 = try container.decode(String.self, forKey: .t2p1)
        self.t2p2 = try container.decode(String.self, forKey: .t2p2)
        self.scoreOne = try container.decode(Int.self, forKey: .scoreOne)
        self.scoreTwo = try container.decode(Int.self, forKey: .scoreTwo)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.sessionId, forKey: .sessionId)
        try container.encode(self.dateCreated, forKey: .dateCreated)
        try container.encode(self.location, forKey: .location)
        try container.encode(self.matchDate, forKey: .matchDate)
        try container.encode(self.t1p1, forKey: .t1p1)
        try container.encode(self.t1p2, forKey: .t1p2)
        try container.encode(self.t2p1, forKey: .t2p1)
        try container.encode(self.t2p2, forKey: .t2p2)
        try container.encode(self.scoreOne, forKey: .scoreOne)
        try container.encode(self.scoreTwo, forKey: .scoreTwo)
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
