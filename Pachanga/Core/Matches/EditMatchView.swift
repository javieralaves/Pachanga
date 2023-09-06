////
////  EditMatchView.swift
////  Pachanga
////
////  Created by Javier Alaves on 3/9/23.
////
//
//import FirebaseFirestore
//import FirebaseFirestoreSwift
//import SwiftUI
//
//struct EditMatchView: View {
//
//    // dismiss view on save
//    @Environment(\.dismiss) var dismiss
//
//    // match that gets passed in
//    let match: Match
//
//    // player values initialized as empty strings, loaded onAppear
//    @State private var t1p1: String = ""
//    @State private var t1p2: String = ""
//    @State private var t2p1: String = ""
//    @State private var t2p2: String = ""
//
//    // score values initialized at zero, loaded onAppear
//    @State private var score1: Int = 0
//    @State private var score2: Int = 0
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                Form {
//                    // team one
//                    Section ("Primer equipo") {
//                        Picker("Primer jugador", selection: $t1p1) {
//                            ForEach(match.players, id: \.self) {
//                                Text($0)
//                            }
//                        }
//                        Picker("Segundo jugador", selection: $t1p2) {
//                            ForEach(match.players, id: \.self) {
//                                Text($0)
//                            }
//                        }
//                    }
//
//                    // team two
//                    Section ("Primer equipo") {
//                        Picker("Primer jugador", selection: $t2p1) {
//                            ForEach(match.players, id: \.self) {
//                                Text($0)
//                            }
//                        }
//                        Picker("Segundo jugador", selection: $t2p2) {
//                            ForEach(match.players, id: \.self) {
//                                Text($0)
//                            }
//                        }
//                    }
//
//                    // score
//                    Section ("Resultado") {
//                        HStack {
//                            Text("Primer equipo:")
//                            TextField("Primer equipo", value: $score1, format: .number)
//                                .keyboardType(.decimalPad)
//                        }
//                        HStack {
//                            Text("Segundo equipo:")
//                            TextField("Segundo equipo", value: $score2, format: .number)
//                                .keyboardType(.decimalPad)
//                        }
//                    }
//                    
//                    // actions
//                    Section ("Acciones") {
//                        Button(role: .destructive) {
//                            Task {
//                                let matchCollection = Firestore.firestore().collection("matches")
//                                try await matchCollection.document(match.matchId).delete()
//                            }
//                            dismiss()
//                        } label: {
//                            Text("Eliminar partido")
//                        }
//
//                    }
//                }
//            }
//        }
//        .navigationTitle("Editar partido")
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            Button {
//                // data that needs to be updated
//                let data: [AnyHashable : Any] = [
//                    Match.CodingKeys.teamOne.rawValue : [t1p1, t1p2],
//                    Match.CodingKeys.teamTwo.rawValue : [t2p1, t2p2],
//                    Match.CodingKeys.teamOneScore.rawValue : score1,
//                    Match.CodingKeys.teamTwoScore.rawValue : score2
//                ]
//
//                // perform async task
//                Task {
//                    let matchCollection = Firestore.firestore().collection("matches")
//                    try await matchCollection.document(match.matchId).updateData(data)
//                }
//
//                // dismiss view
//                dismiss()
//
//            } label: {
//                Text("Guardar")
//            }
//
//        }
//        .onAppear {
//            updateMatch()
//        }
//    }
//
//    private func updateMatch() {
//        t1p1 = match.teamOne[0]
//        t1p2 = match.teamOne[1]
//        t2p1 = match.teamTwo[0]
//        t2p2 = match.teamTwo[1]
//
//        score1 = match.teamOneScore
//        score2 = match.teamTwoScore
//    }
//}
//
//struct EditMatchView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            EditMatchView(match: Match(location: "El Campello",
//                                       matchDate: Date.now,
//                                       players: ["Javier Alaves", "Diego Cortes", "Alvaro Perez", "Nacho Alaves"],
//                                       teamOne: ["Javier Alaves", "Nacho Alaves"],
//                                       teamTwo: ["Diego Cortes", "Alvaro Perez"],
//                                       teamOneScore: 21,
//                                       teamTwoScore: 19,
//                                       isRanked: false))
//        }
//    }
//}
