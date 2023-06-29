//
//  Player.swift
//  Pachanga
//
//  Created by Javier Alaves on 29/6/23.
//

import Foundation

struct Player: Identifiable {
    
    var id = UUID()
    var firstName: String
    var lastName: String
    var profileImage: String
    
    var wins: Int = 0
    var losses: Int = 0
    
}
