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
            Color.black.ignoresSafeArea().opacity(0.1)
            
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
                            VStack (alignment: .leading, spacing: 12) {
                                HStack (spacing: -8){
                                    Image("javi")
                                        .frame(width: 32, height: 32)
                                    Image("danielle")
                                        .frame(width: 32, height: 32)
                                    Image("jorge")
                                        .frame(width: 32, height: 32)
                                }
                                
                                Text("Javi, Danielle, Jorge & 2 más")
                                    .fontWeight(.semibold)
                                
                                HStack {
                                    Image(systemName: "clock.fill")
                                    Text("8:00 - 9:30")
                                }
                                .foregroundColor(.secondary)
                                
                                HStack {
                                    Image(systemName: "location.fill")
                                    Text("Club Vóley Playa Muchavista")
                                }
                                .foregroundColor(.secondary)
                                
                            }
                            .padding(24)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 4)
                            
                        }
                        
                        // Section
                        VStack (alignment: .leading, spacing: 24) {
                            Text("Cerca de ti")
                                .font(.title.bold())
                            
                            // Session
                            VStack (alignment: .leading, spacing: 12) {
                                HStack (spacing: -8){
                                    Image("marta")
                                        .frame(width: 32, height: 32)
                                    Image("diego")
                                        .frame(width: 32, height: 32)
                                    Image("paco")
                                        .frame(width: 32, height: 32)
                                }
                                
                                Text("Marta, Diego, Paco & 3 más")
                                    .fontWeight(.semibold)
                                
                                HStack {
                                    Image(systemName: "clock.fill")
                                    Text("9:00 - 10:30")
                                }
                                .foregroundColor(.secondary)
                                
                                HStack {
                                    Image(systemName: "location.fill")
                                    Text("Pistas Xaloc")
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
