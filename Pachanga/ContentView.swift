//
//  ContentView.swift
//  Pachanga
//
//  Created by Javier Alaves on 28/6/23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    NavigationLink {
                        NewMatch()
                    } label: {
                        Text("Nueva pachanga")
                    }
                }
                Section {
                    Text("No hay pachangas")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
