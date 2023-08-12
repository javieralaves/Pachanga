//
//  Sessions.swift
//  Pachanga
//
//  Created by Javier Alaves on 21/7/23.
//

import Foundation

class Sessions: ObservableObject {
    
    @Published var sessions = [Session]() {
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(sessions) {
                UserDefaults.standard.set(encoded, forKey: "Sessions")
            }
        }
    }
    
    init() {
        if let savedSessions = UserDefaults.standard.data(forKey: "Sessions") {
            if let decodedSessions = try? JSONDecoder().decode([Session].self, from: savedSessions) {
                sessions = decodedSessions
                return
            }
        }
        
        sessions = []
    }
    
}
