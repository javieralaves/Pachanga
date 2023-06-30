//
//  ContentView.swift
//  Pachanga
//
//  Created by Javier Alaves on 28/6/23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Upcoming match")
                .font(.headline)
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .frame(height: 120)
                .foregroundColor(.gray.opacity(0.20))
            Spacer()
        }
        .padding()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
