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
    
}
