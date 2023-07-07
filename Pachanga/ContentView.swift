//
//  ContentView.swift
//  Pachanga
//
//  Created by Javier Alaves on 28/6/23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        // Navigation tabs
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                }
            RankingView()
                .tabItem {
                    Image(systemName: "trophy")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
