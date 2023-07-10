//
//  HomeView.swift
//  Pachanga
//
//  Created by Javier Alaves on 7/7/23.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        
        ZStack {
            // Background
            Color.black.ignoresSafeArea().opacity(0.05)
            
            VStack () {
                Image(systemName: "volleyball.fill")
                    .foregroundStyle(.black)
                    .font(.title2)
                    .padding(.bottom, 24)
                
                ScrollView {
                    
                    // Sections
                    VStack (spacing: 40) {
                        
                        // Section
                        VStack (alignment: .leading, spacing: 24) {
                            Text("Tus pachangas")
                                .font(.title.bold())
                            
                            // Session
                            SessionCard(playersTitle: "Javi, Danielle, Jorge & 2 más", startTime: "8:00", endTime: "9:30", location: "Club Vóley Playa Muchavista")
                            
                        }
                        
                        // Section
                        VStack (alignment: .leading, spacing: 24) {
                            Text("Cerca de ti")
                                .font(.title.bold())
                                                        
                            SessionCard(playersTitle: "Marta, Diego, Paco & 3 más", startTime: "9:00", endTime: "10:30", location: "Restaurante Xaloc")

                            SessionCard(playersTitle: "Jon, Manu & 1 más", startTime: "7:30", endTime: "9:30", location: "Restaurante Niza")
                            
                        }
                        
                    }
                    
                }

            }
            .padding(24)
            
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
