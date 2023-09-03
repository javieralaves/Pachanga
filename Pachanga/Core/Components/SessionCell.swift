//
//  SessionCell.swift
//  Pachanga
//
//  Created by Javier Alaves on 15/8/23.
//

import SwiftUI

struct SessionCell: View {
    
    let session: Session
    
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                Text("\(session.location)")
                    .fontWeight(.medium)
                Text("\(session.sessionDate.formatted(date: .abbreviated, time: .shortened))")
                    .foregroundColor(.secondary)
            }
            Spacer()
            HStack {
                Text("\(session.players.count)")
                Image(systemName: "person.crop.circle")
            }
            .fontWeight(.medium)
            .foregroundColor(.secondary)
        }
    }
}

struct SessionCell_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SessionCell(session: Session(sessionId: "test",
                                         dateCreated: Date.now,
                                         status: "active",
                                         location: "Club Muchavista",
                                         sessionDate: Date.now,
                                         players: ["javi"],
                                         matches: [],
                                         bringsBall: [],
                                         bringsLines: []))
            .padding()
        }
    }
}
