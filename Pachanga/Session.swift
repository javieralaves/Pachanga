//
//  Session.swift
//  Pachanga
//
//  Created by Javier Alaves on 21/7/23.
//

import Foundation

struct Session: Identifiable, Codable {
    var id = UUID()
    var players: [Player]
    var date: Date
    var location: String
    var ballAvailable: Bool = false
}
