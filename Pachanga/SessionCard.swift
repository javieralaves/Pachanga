//
//  SessionCard.swift
//  Pachanga
//
//  Created by Javier Alaves on 10/7/23.
//

import SwiftUI

struct SessionCard: View {
    
    @State var players: [Player] = Player.samplePlayers
    
    @State var playersTitle: String
    @State var startTime: String
    @State var endTime: String
    @State var location: String
    
    var body: some View {
        
        VStack (alignment: .leading, spacing: 12) {
            HStack (spacing: -8){
                ForEach(0..<3) { player in
                    Image(players[player].profileImage)
                        .frame(width: 32, height: 32)
                }
            }
            
            Text(setCardTitle()) // to be defined by function based on # of players
                .fontWeight(.semibold)
            
            HStack {
                Image(systemName: "clock.fill")
                Text("\(startTime) - \(endTime)")
            }
            .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: "location.fill")
                Text(location)
            }
            .foregroundColor(.secondary)
            
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 4)
    }
    
    func setCardTitle() -> String {
        
        // If array of players >= 3, do as "X, Y, Z & array.count - 3 more
        // else, just "X, Y, Z"
        
        if players.count >= 4 {
            return "\(players[0].firstName), \(players[1].firstName), \(players[2].firstName) & \(players.count - 3) más"
        } else {
            // Need to set this dynamically based on number of players, concatenating with a ForEach
            return "..."
        }
        
    }
}

struct SessionCard_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea().opacity(0.05)
            SessionCard(playersTitle: "Javi, Danielle, Jorge & 2 más", startTime: "8:00", endTime: "9:30", location: "Club Vóley Playa Muchavista")
                .padding()
        }
    }
}
