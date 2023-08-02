//
//  Session.swift
//  Pachanga
//
//  Created by Javier Alaves on 21/7/23.
//

import Foundation

struct Session: Identifiable, Codable {
    var id = UUID()
    var participants: [Player]
    var date: Date
    var location: String
    var ballAvailable: Bool = false
    var linesAvailable: Bool = false
    
    // Hardcoded field options directly in the session struct instead of defined elsewhere
    static var availableFields: [String] = ["Club Muchavista", "Xaloc", "Niza"]
}
