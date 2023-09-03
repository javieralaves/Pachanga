//
//  MatchCell.swift
//  Pachanga
//
//  Created by Javier Alaves on 3/9/23.
//

import SwiftUI

struct MatchCell: View {
    
    let match: Match
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("\(match.teamOne[0]) y \(match.teamOne[1])")
                Spacer()
                Text("\(match.teamOneScore)")
                    .foregroundColor(.secondary)
            }
            HStack {
                Text("\(match.teamTwo[0]) y \(match.teamTwo[1])")
                Spacer()
                Text("\(match.teamTwoScore)")
                    .foregroundColor(.secondary)
            }
        }
    }
}
