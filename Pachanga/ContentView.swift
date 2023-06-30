//
//  ContentView.swift
//  Pachanga
//
//  Created by Javier Alaves on 28/6/23.
//

import SwiftUI

struct ContentView: View {
    
    var playerOne = DataService().getPlayers()[0]
    var playerTwo = DataService().getPlayers()[1]
    var playerThree = DataService().getPlayers()[2]
    var playerFour = DataService().getPlayers()[3]
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Próxima pachanga")
                .font(.headline)
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .frame(height: 120)
                    .foregroundColor(.gray.opacity(0.20))
                VStack {
                    Text("\(playerOne.firstName) y \(playerTwo.firstName)")
                    Text("vs")
                    Text("\(playerThree.firstName) y \(playerFour.firstName)")
                }
            }
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
