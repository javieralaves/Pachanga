//
//  NewSession.swift
//  Pachanga
//
//  Created by Javier Alaves on 21/7/23.
//

import SwiftUI

struct NewSession: View {
    
    @ObservedObject var sessions: Sessions
    
    @Environment(\.dismiss) var dismiss
    
    @State var date: Date = Date.now
    @State var location: String = ""
    @State var ballAvailable: Bool = false
    
    var body: some View {
        
        NavigationView {
            Form {
                // When and where
                Section {
                    DatePicker("Fecha", selection: $date)
                    TextField("Dónde", text: $location)
                }
                
                // Ball availability
                Toggle("Bola disponible", isOn: $ballAvailable)
            }
            .navigationTitle("Nueva pachanga")
            .toolbar {
                Button("Crear") {
                    let session = Session(participants: [Player](), date: date, location: location)
                    // need to append user who creates session to this new participants array
                    sessions.sessions.append(session)
                    dismiss()
                }
            }
        }
        
    }
}

struct NewSession_Previews: PreviewProvider {
    static var previews: some View {
        NewSession(sessions: Sessions())
    }
}
