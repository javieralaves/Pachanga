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
    
    // var profileImage: String
    // var wins: Int = 0
    // var losses: Int = 0
    
}
