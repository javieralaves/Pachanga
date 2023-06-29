//
//  Match.swift
//  Pachanga
//
//  Created by Javier Alaves on 29/6/23.
//

import Foundation

struct Match: Identifiable {
    
    var id = UUID()
    
    var teamOne: Array = [Player]()
    var teamTwo: Array = [Player]()
    var winner: [Player]
    
    var scoreOne: Int = 0
    var scoreTwo: Int = 0
    
    var location: String
    var date: Date
    var timeHour: Int
    var timeMinute: Int
    
    var isBallAvailable: Bool = false
    var areLinesAvailable: Bool = false
    
    mutating func setWinner() {

        if scoreOne >= 21 && scoreOne > (scoreTwo + 1) {
            winner = teamOne
        }
        
        if scoreTwo >= 21 && scoreTwo > (scoreOne + 1) {
            winner = teamTwo
        }
        
    }
    
}
