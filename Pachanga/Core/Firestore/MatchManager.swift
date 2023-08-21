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

struct Match: Codable {
    
    // props
    let matchId: String
    let dateCreated: Date
    var location: String
    var matchDate: Date
    var players: [String] // combo of teamOne and teamTwo
    var teamOne: [String] // tuple instead?
    var teamTwo: [String]
    var teamOneScore: Int
    var teamTwoScore: Int
    var isRanked: Bool // whether match should contribute to rankings or not
    
    // base init
    init(
        location: String,
        matchDate: Date,
        players: [String],
        teamOne: [String],
        teamTwo: [String],
        teamOneScore: Int,
        teamTwoScore: Int,
        isRanked: Bool
    ) {
        self.matchId = UUID().uuidString
        self.dateCreated = Date.now
        self.location = location
        self.matchDate = matchDate
        self.players = players
        self.teamOne = teamOne
        self.teamTwo = teamTwo
        self.teamOneScore = teamOneScore
        self.teamTwoScore = teamTwoScore
        self.isRanked = isRanked
    }
    
    // init from session
    init(
        session: Session,
        players: [String],
        teamOne: [String],
        teamTwo: [String],
        teamOneScore: Int,
        teamTwoScore: Int,
        isRanked: Bool
    ) {
        self.matchId = UUID().uuidString
        self.dateCreated = session.dateCreated
        self.location = session.location
        self.matchDate = session.sessionDate
        self.players = players
        self.teamOne = teamOne
        self.teamTwo = teamTwo
        self.teamOneScore = teamOneScore
        self.teamTwoScore = teamTwoScore
        self.isRanked = isRanked
    }
    
    // custom coding strategy
    enum CodingKeys: String, CodingKey {
        case matchId = "match_id"
        case dateCreated = "date_created"
        case location = "location"
        case matchDate = "match_date"
        case players = "players"
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
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        self.location = try container.decode(String.self, forKey: .location)
        self.matchDate = try container.decode(Date.self, forKey: .matchDate)
        self.players = try container.decode([String].self, forKey: .players)
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
        try container.encode(self.dateCreated, forKey: .dateCreated)
        try container.encode(self.location, forKey: .location)
        try container.encode(self.matchDate, forKey: .matchDate)
        try container.encode(self.players, forKey: .players)
        try container.encode(self.teamOne, forKey: .teamOne)
        try container.encode(self.teamTwo, forKey: .teamTwo)
        try container.encode(self.teamOneScore, forKey: .teamTwoScore)
        try container.encode(self.isRanked, forKey: .isRanked)
    }
    
}
