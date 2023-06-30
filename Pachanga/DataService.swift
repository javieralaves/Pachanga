//
//  DataService.swift
//  Pachanga
//
//  Created by Javier Alaves on 30/6/23.
//

import Foundation

struct DataService {
    
    func getPlayers() -> [Player] {
        return [Player(firstName: "Javier", lastName: "Alaves", profileImage: "javi"),
                Player(firstName: "Jorge", lastName: "Yoldi", profileImage: "jorge"),
                Player(firstName: "Diego", lastName: "Cortes", profileImage: "diego"),
                Player(firstName: "Alvaro", lastName: "Perez", profileImage: "alvaro")]
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
