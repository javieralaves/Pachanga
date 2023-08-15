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
        VStack (alignment: .leading) {
            Text("Cuándo: \(session.sessionDate.formatted(date: .abbreviated, time: .shortened))")
            Text("Dónde: \(session.location)")
        }
    }
}

struct SessionCell_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SessionCell(session: Session(sessionId: "test",
                                         dateCreated: Date.now,
                                         location: "Club Muchavista",
                                         sessionDate: Date.now,
                                         players: [DBUser](),
                                         isBallAvailable: true,
                                         areLinesAvailable: false))
        }
    }
}
