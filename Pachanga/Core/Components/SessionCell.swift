//
//  SessionCell.swift
//  Pachanga
//
//  Created by Javier Alaves on 15/8/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct SessionCell: View {
    
    let session: Session
    
    // initialized amount of session players
    @State var playerCount: Int = 0
    
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
                Text("\(playerCount)")
                Image(systemName: "person.crop.circle")
            }
            .fontWeight(.medium)
            .foregroundColor(.secondary)
        }
        .task {
            getPlayerCount()
        }
    }
    
    func getPlayerCount() {
        
        Task {
            let sessionMembers = try await SessionManager.shared.getAllSessionMembers(sessionId: session.sessionId)
            playerCount = sessionMembers.count
        }
        
    }
}

struct SessionCell_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SessionCell(session: Session(sessionId: "1",
                                         dateCreated: Date.now,
                                         status: "active",
                                         location: "El Campello",
                                         sessionDate: Date.now,
                                         members: []))
            .padding()
        }
    }
}
