//
//  PachangaApp.swift
//  Pachanga
//
//  Created by Javier Alaves on 28/6/23.
//

import Firebase
import SwiftUI

@main
struct PachangaApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainView()
            }
        }
    }
}
