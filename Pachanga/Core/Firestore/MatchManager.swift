//
//  MatchManager.swift
//  Pachanga
//
//  Created by Javier Alaves on 21/8/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation
import SwiftUI

struct Match: Codable, Hashable {
    
    // props
    let matchId: String
    let sessionId: String
    let dateCreated: Date
    var location: String
    var matchDate: Date
    var teamOne: [String]
    var teamTwo: [String]
    var teamOneScore: Int
    var teamTwoScore: Int
    var isRanked: Bool
    
    // base init
    init(
        location: String,
        matchDate: Date,
        teamOne: [String],
        teamTwo: [String],
        teamOneScore: Int,
        teamTwoScore: Int,
        isRanked: Bool
    ) {
        self.matchId = UUID().uuidString
        self.sessionId = UUID().uuidString
        self.dateCreated = Date.now
        self.location = location
        self.matchDate = matchDate
        self.teamOne = teamOne
        self.teamTwo = teamTwo
        self.teamOneScore = teamOneScore
        self.teamTwoScore = teamTwoScore
        self.isRanked = isRanked
    }
    
    // init from session
    init(
        session: Session,
        teamOne: [String],
        teamTwo: [String],
        teamOneScore: Int,
        teamTwoScore: Int,
        isRanked: Bool
    ) {
        self.matchId = UUID().uuidString
        self.sessionId = session.sessionId
        self.dateCreated = session.dateCreated
        self.location = session.location
        self.matchDate = session.sessionDate
        self.teamOne = teamOne
        self.teamTwo = teamTwo
        self.teamOneScore = teamOneScore
        self.teamTwoScore = teamTwoScore
        self.isRanked = isRanked
    }
    
    // custom coding strategy
    enum CodingKeys: String, CodingKey {
        case matchId = "match_id"
        case sessionId = "session_id"
        case dateCreated = "date_created"
        case location = "location"
        case matchDate = "match_date"
        case teamOne = "team_one"
        case teamTwo = "team_two"
        case teamOneScore = "team_one_score"
        case teamTwoScore = "team_two_score"
        case isRanked = "is_ranked"
    }
    
    // init from decoder to load match from db
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.matchId = try container.decode(String.self, forKey: .matchId)
        self.sessionId = try container.decode(String.self, forKey: .sessionId)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        self.location = try container.decode(String.self, forKey: .location)
        self.matchDate = try container.decode(Date.self, forKey: .matchDate)
        self.teamOne = try container.decode([String].self, forKey: .teamOne)
        self.teamTwo = try container.decode([String].self, forKey: .teamTwo)
        self.teamOneScore = try container.decode(Int.self, forKey: .teamOneScore)
        self.teamTwoScore = try container.decode(Int.self, forKey: .teamTwoScore)
        self.isRanked = try container.decode(Bool.self, forKey: .isRanked)
    }
    
    // encode match into db with encoder
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.matchId, forKey: .matchId)
        try container.encode(self.sessionId, forKey: .sessionId)
        try container.encode(self.dateCreated, forKey: .dateCreated)
        try container.encode(self.location, forKey: .location)
        try container.encode(self.matchDate, forKey: .matchDate)
        try container.encode(self.teamOne, forKey: .teamOne)
        try container.encode(self.teamTwo, forKey: .teamTwo)
        try container.encode(self.teamOneScore, forKey: .teamOneScore)
        try container.encode(self.teamTwoScore, forKey: .teamTwoScore)
        try container.encode(self.isRanked, forKey: .isRanked)
    }
    
}

final class MatchManager {
    
    static let shared = MatchManager()
    private init() { }
    
    // MARK: collection functions
    
    // reference to matches collection in the db
    private let matchesCollection = Firestore.firestore().collection("matches")
    
    // reference to specific match in matches db by match id
    private func matchDocument(matchId: String) -> DocumentReference {
        matchesCollection.document(matchId)
    }
    
    // push new match to db
    func createNewMatch(match: Match) async throws {
        try matchDocument(matchId: match.matchId).setData(from: match, merge: false)
    }
    
    // get match by id
    func getMatch(matchId: String) async throws -> Match {
        try await matchDocument(matchId: matchId).getDocument(as: Match.self)
    }
    
    // get match winner by checking who has largest score
    func getWinner(match: Match) async throws -> [String] {
        match.teamOneScore > match.teamTwoScore ? match.teamOne : match.teamTwo
    }
    
    // MARK: players subcollection functions
    
    // reference to match players subcollection
    private func matchPlayersCollection(matchId: String) -> CollectionReference {
        matchDocument(matchId: matchId).collection("match_players")
    }
    
    // reference to a specific player in the match players subcollection by match id
    private func matchPlayerDocument(matchId: String, matchPlayerId: String) -> DocumentReference {
        matchPlayersCollection(matchId: matchId).document(matchPlayerId)
    }
    
    // add a player to match players subcollection
    func addMatchPlayer(matchId: String, userId: String, team: Int) async throws {
        // generate an empty document inside subcollection
        let document = matchPlayersCollection(matchId: matchId).document()
        let documentId = document.documentID
        
        // create data that gets passed into match player document
        let data: [String:Any] = [
            MatchPlayer.CodingKeys.id.rawValue : documentId,
            MatchPlayer.CodingKeys.userId.rawValue : userId,
            MatchPlayer.CodingKeys.dateAdded.rawValue : Timestamp(),
            MatchPlayer.CodingKeys.team.rawValue : team
        ]
        
        // set data
        try await document.setData(data, merge: false)
    }
    
    // return an array of MatchPlayers for a given match
    func getAllMatchPlayers(matchId: String) async throws -> [MatchPlayer] {
        try await matchPlayersCollection(matchId: matchId).getDocuments(as: MatchPlayer.self)
    }
    
    // return array of MatchPlayers for a given team within a match
    func getMatchTeamPlayers(matchId: String, team: Int) async throws -> [MatchPlayer] {
        try await matchPlayersCollection(matchId: matchId).whereField("team", isEqualTo: team).getDocuments(as: MatchPlayer.self)
    }
    
}

struct MatchPlayer: Codable, Hashable {
    let id: String
    let userId: String
    let dateAdded: Date
    let team: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case dateAdded = "date_added"
        case team = "team"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.dateAdded = try container.decode(Date.self, forKey: .dateAdded)
        self.team = try container.decode(Int.self, forKey: .team)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.dateAdded, forKey: .dateAdded)
        try container.encode(self.team, forKey: .team)
    }
}
