//
//  Match.swift
//  Pachanga
//
//  Created by Javier Alaves on 29/6/23.
//

import Foundation

struct Match: Identifiable {
    
    var id = UUID()
    
    var teamOne: (Player, Player)
    var teamTwo: (Player, Player)
    var winner: (Player, Player)? = nil
    
    var scoreOne: Int = 0
    var scoreTwo: Int = 0
    
    var location: String
    var date: Date
    var timeHour: Int
    var timeMinute: Int
    
    var isBallAvailable: Bool = false
    var areLinesAvailable: Bool = false
    
}
