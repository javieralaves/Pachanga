//
//  PachangaApp.swift
//  Pachanga
//
//  Created by Javier Alaves on 28/6/23.
//

import SwiftUI
import Firebase

@main
struct PachangaApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
