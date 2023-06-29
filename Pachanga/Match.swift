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
    
    mutating func setWinner(teamNumber: Int) {

        if teamNumber == 1 {
            winner = teamOne
            teamOne.0.wins += 1
            teamOne.1.wins += 1
            teamTwo.0.losses += 1
            teamTwo.1.losses += 1
        } else {
            winner = teamTwo
            teamOne.0.losses += 1
            teamOne.1.losses += 1
            teamTwo.0.wins += 1
            teamTwo.1.wins += 1
        }
        
    }
    
}
