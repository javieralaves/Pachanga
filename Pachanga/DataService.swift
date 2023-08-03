//
//  DataService.swift
//  Pachanga
//
//  Created by Javier Alaves on 30/6/23.
//

import Foundation

struct DataService {
    
    func getPlayers() -> [Player] {
        return Player.samplePlayers
    }
    
    func getPachangas() -> [Match] {
        return [Match(teamOne: (getPlayers()[0], getPlayers()[1]),
                      teamTwo: (getPlayers()[2], getPlayers()[3]),
                      location: "Club Playa Muchavista",
                      date: Date(),
                      timeHour: 8,
                      timeMinute: 30)]
    }
    
}
