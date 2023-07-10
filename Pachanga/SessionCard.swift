//
//  SessionCard.swift
//  Pachanga
//
//  Created by Javier Alaves on 10/7/23.
//

import SwiftUI

struct SessionCard: View {
    
    @State var players = [String]() // to be replaced with [Player]()
    
    @State var playersTitle: String
    @State var startTime: String
    @State var endTime: String
    @State var location: String
    
    var body: some View {
        
        // Avatars will be obtained from players array imageProfile property with a ForEach
        VStack (alignment: .leading, spacing: 12) {
            HStack (spacing: -8){
                Image("javi")
                    .frame(width: 32, height: 32)
                Image("danielle")
                    .frame(width: 32, height: 32)
                Image("jorge")
                    .frame(width: 32, height: 32)
            }
            
            Text(playersTitle) // to be defined by function based on # of players
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
