//
//  SessionView.swift
//  Pachanga
//
//  Created by Nacho Alaves on 3/8/23.
//

import SwiftUI

struct SessionView: View {
    @State private var enoughMembers = false
    @State private var enoughMaterials = false
    
    var participants: [Player]
    var date: Date
    var location: String
    
    var mySession = Session(participants: Player.samplePlayers, date: Date.now, location: "El Campello")
    
    var body: some View {
        NavigationView {
            List {
                Section("Basic info") {
                    HStack {
                        Text("Date")
                        Spacer()
                        Text(date, format: .dateTime.day().month())
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Time")
                        Spacer()
                        Text(date, format: .dateTime.hour().minute())
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Location")
                        Spacer()
                        Text(location)
                            .foregroundColor(.secondary)
                    }
                }
                
                // need to replace these with participants data
                Section("Players") {
                    HStack {
                        Text("Javier Alaves")
                        Spacer()
                        Image(systemName: "volleyball.fill")
                            .foregroundColor(.secondary)
                            .padding(.trailing, 4)
                    }
                    HStack {
                        Text("Nacho Alaves")
                        Spacer()
                        Image(systemName: "sportscourt.fill")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Antonio Marcos")
                    }
                    HStack {
                        Text("Adam Abram")
                    }
                }
                
                Section {
                    HStack {
                        Spacer()
                        VStack{
                            Button("Finish Session"){
                                
                            }
                            .buttonStyle(.borderedProminent)
                            .padding(4)
                            
                            if(!enoughMembers) {
                                Text("Not enough players to begin!")
                                    .foregroundColor(.red)
                                    .bold()
                                    .padding(4)
                            }
                            
                            if(!enoughMaterials) {
                                Text("Nobody is bringing a Volleyball!")
                                    .foregroundColor(.red)
                                    .bold()
                                    .padding(2)
                            }
                        }
                        Spacer()
                    }
                    .listRowBackground(Color(.systemGroupedBackground))
                }
            }
            .navigationTitle("My Session")
            .toolbar {
                Button {
                } label: {
                    Image(systemName: "pencil.line")
                        .padding()
                }
            }
        }
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView(participants: Player.samplePlayers, date: Date.now, location: "El Campello")
    }
}
