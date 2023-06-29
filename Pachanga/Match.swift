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
            
            teamOne[0].wins += 1
            teamOne[1].wins += 1
            
            teamTwo[0].losses += 1
            teamTwo[1].losses += 1
        }
        
        if scoreTwo >= 21 && scoreTwo > (scoreOne + 1) {
            winner = teamTwo
            
            teamTwo[0].wins += 1
            teamTwo[1].wins += 1
            
            teamOne[0].losses += 1
            teamOne[1].losses += 1
        }
        
    }
    
}
