//
//  NewMatch.swift
//  Pachanga
//
//  Created by Javier Alaves on 1/7/23.
//

import SwiftUI

struct NewMatch: View {
    
    var players: [String] = ["Javier Alaves", "Dani Humphreys", "Jorge Yoldi", "Maria Torregrosa"]
    
    @State var playerOne: String = "Javier Alaves"
    @State var playerTwo: String = "Dani Humphreys"
    @State var playerThree: String = "Jorge Yoldi"
    @State var playerFour: String = "Maria Torregrosa"
    
    @State var teamOneScore: Int = 0
    @State var teamTwoScore: Int = 0
    
    var body: some View {
        
        Form {
            Section("Equipo 1") {
                Picker("Jugador 1", selection: $playerOne) {
                    ForEach(players, id: \.self) {
                        Text($0)
                    }
                }
                Picker("Jugador 2", selection: $playerTwo) {
                    ForEach(players, id: \.self) {
                        Text($0)
                    }
                }
            }
            Section("Equipo 2") {
                Picker("Jugador 1", selection: $playerThree) {
                    ForEach(players, id: \.self) {
                        Text($0)
                    }
                }
                Picker("Jugador 2", selection: $playerFour) {
                    ForEach(players, id: \.self) {
                        Text($0)
                    }
                }
            }
            
            Section("Resultado") {
                TextField("Equipo 1", value: $teamOneScore, format: .number)
                TextField("Equipo 2", value: $teamTwoScore, format: .number)
            }
            
            Button("Guardar partida") {
                print("\(playerOne) y \(playerTwo) han jugado contra \(playerThree) y \(playerFour). El resultado ha sido de \(teamOneScore)-\(teamTwoScore).")
            }
            
        }
        
    }
}

struct NewMatch_Previews: PreviewProvider {
    static var previews: some View {
        NewMatch()
    }
}
