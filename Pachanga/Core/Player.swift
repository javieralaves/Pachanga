//
//  Player.swift
//  Pachanga
//
//  Created by Javier Alaves on 29/6/23.
//

import Foundation

struct Player: Identifiable, Codable {
    
    var id: UUID
    var firstName: String
    var lastName: String
    var emailAddress: String
    var sessions: [Session]
    
    static var samplePlayers: [Player] = [Player(id: UUID(),
                                                 firstName: "Javier",
                                                 lastName: "Alaves",
                                                 emailAddress: "javi@email.com",
                                                 sessions: [Session]()),
                                          Player(id: UUID(),
                                                 firstName: "María",
                                                 lastName: "Torregrosa",
                                                 emailAddress: "maria@email.com",
                                                 sessions: [Session]()),
                                          Player(id: UUID(),
                                                 firstName: "Jorge",
                                                 lastName: "Yoldi",
                                                 emailAddress: "jorge@email.com",
                                                 sessions: [Session]()),
                                          Player(id: UUID(),
                                                 firstName: "Danielle",
                                                 lastName: "Humphreys",
                                                 emailAddress: "dani@email.com",
                                                 sessions: [Session]()),
    ]
    
    // var profileImage: String
    // var wins: Int = 0
    // var losses: Int = 0
    
}
