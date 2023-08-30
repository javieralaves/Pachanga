//
//  MatchCell.swift
//  Pachanga
//
//  Created by Nacho Alaves on 22/8/23.
//

import SwiftUI

/*struct myMatch {
    var matchId = UUID().uuidString
    var players: [String]
    var team: ((String, String), (String, String))
    var score: (Int, Int)
    var isRanked: Bool
}*/

struct MatchCell: View {
    
    let match: Match
    
    var body: some View {
        
        // Scores
        HStack {
            Spacer()
            VStack {
                Text(String(match.teamOneScore))
                    .font(.title)
                Text("\(match.teamOne[0]) y \(match.teamOne[1])")
                    .font(.system(size: 14))
            }
            Spacer()
            VStack {
                if(match.isRanked) {
                    Image(systemName: "crown.fill")
                }
                Text("-")
                    .font(.title2)
            }
            Spacer()
            VStack {
                Text(String(match.teamTwoScore))
                    .font(.title)
                Text("\(match.teamTwo[0]) y \(match.teamTwo[1])")
                    .font(.system(size: 14))
            }
            Spacer()
        }
    }
}

struct MatchCell_Previews: PreviewProvider {
    static var previews: some View {
        MatchCell(match: Match(location: "campello", matchDate: Date.now, players: ["Javi", "Nacho", "Diego", "Adam"], teamOne: ["Javi", "Diego"], teamTwo: ["Nacho", "Adam"], teamOneScore: 20, teamTwoScore: 21, isRanked: true))
    }
}
