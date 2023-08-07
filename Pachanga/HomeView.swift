//
//  HomeView.swift
//  Pachanga
//
//  Created by Javier Alaves on 7/7/23.
//

import SwiftUI

struct HomeView: View {
    @State private var showingAddSession = false
    @State private var mySessions = Sessions()
    
    var body: some View {
        
        NavigationView {
            ZStack {
                // Background
                Color.black.ignoresSafeArea().opacity(0.05)
                
                VStack () {
                    Image(systemName: "volleyball.fill")
                        .foregroundStyle(.black)
                        .font(.title2)
                        .padding(.bottom, 24)
                    
                    ScrollView (showsIndicators: false) {
                        
                        // Sections, need to be replaced with dynamic session data and props
                        VStack (spacing: 40) {
                            
                            // Section
                            VStack (alignment: .leading, spacing: 24) {
                                Text("Tus pachangas")
                                    .font(.title.bold())
                                
                                // Session
                                NavigationLink {
                                    SessionView(participants: Player.samplePlayers, date: Date.now, location: "El Campello")
                                } label: {
                                    SessionCard(playersTitle: "Javi, Danielle, Jorge & 2 más", startTime: "8:00", endTime: "9:30", location: "Club Vóley Playa Muchavista")
                                }
                                .foregroundColor(.black)
                                
                            }
                            
                            // Section
                            VStack (alignment: .leading, spacing: 24) {
                                Text("Cerca de ti")
                                    .font(.title.bold())
                                
                                // Session
                                NavigationLink {
                                    SessionView(participants: Player.samplePlayers, date: Date.now, location: "Restaurante Xaloc")
                                } label: {
                                    SessionCard(playersTitle: "Marta, Diego, Paco & 3 más", startTime: "9:00", endTime: "10:30", location: "Restaurante Xaloc")
                                }
                                .foregroundColor(.black)
                                
                                NavigationLink {
                                    SessionView(participants: Player.samplePlayers, date: Date.now, location: "Niza")
                                } label: {
                                    SessionCard(playersTitle: "Jon, Manu & 1 más", startTime: "7:30", endTime: "9:30", location: "Restaurante Niza")
                                }
                                .foregroundColor(.black)
                            }
                        }
                    }
                }
                .padding(24)
                
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Button {
                            showingAddSession = true
                            
                        } label: {
                            Image(systemName: "plus")
                                .font(Font.title.weight(.medium))
                                .tint(Color.white)
                        }
                        .frame(width: 64, height: 64)
                        .background(Color.black)
                        .clipShape(Circle())
                        .padding(16)
                        .padding(.bottom, 24)
                    }
                }
            }
            .sheet(isPresented: $showingAddSession) {
                NewSession(sessions: mySessions)
            }
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
