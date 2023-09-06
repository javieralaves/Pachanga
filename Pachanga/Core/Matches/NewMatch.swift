////
////  NewSessionMatch.swift
////  Pachanga
////
////  Created by Javier Alaves on 5/9/23.
////
//
//import SwiftUI
//
//struct NewMatch: View {
//
//    let session: Session
//
//    @Environment(\.dismiss) var dismiss
//
//    @State var sessionPlayers: [DBUser] = []
//
//    @State var teamOnePlayerOne: String = ""
//    @State var teamOnePlayerTwo: String = ""
//
//    @State var teamTwoPlayerOne: String = ""
//    @State var teamTwoPlayerTwo: String = ""
//
//    @State var scoreOne: Int = 0
//    @State var scoreTwo: Int = 0
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                Form {
//                    Section("Primer equipo") {
//                        Picker("Primer jugador", selection: $teamOnePlayerOne) {
//                            // placeholder
//                            if teamOnePlayerOne == "" {
//                                Text("").tag("Placeholder")
//                            }
//
//                            ForEach(sessionPlayers, id: \.userId) { player in
//                                Text(player.name ?? "Juan Doe")
//                            }
//                        }
//                        Picker("Segundo jugador", selection: $teamOnePlayerTwo) {
//                            // placeholder
//                            if teamOnePlayerTwo == "" {
//                                Text("").tag("Placeholder")
//                            }
//
//                            ForEach(sessionPlayers, id: \.userId) { player in
//                                Text(player.name ?? "Juan Doe")
//                            }
//                        }
//                    }
//
//                    Section("Segundo equipo") {
//                        Picker("Primer jugador", selection: $teamTwoPlayerOne) {
//                            // placeholder
//                            if teamTwoPlayerOne == "" {
//                                Text("").tag("Placeholder")
//                            }
//
//                            ForEach(sessionPlayers, id: \.userId) { player in
//                                Text(player.name ?? "Juan Doe")
//                            }
//                        }
//                        Picker("Segundo jugador", selection: $teamTwoPlayerTwo) {
//                            // placeholder
//                            if teamTwoPlayerTwo == "" {
//                                Text("").tag("Placeholder")
//                            }
//
//                            ForEach(sessionPlayers, id: \.userId) { player in
//                                Text(player.name ?? "Juan Doe")
//                            }
//                        }
//                    }
//
//                    Section("Resultado") {
//                        HStack {
//                            Text("Primer equipo:")
//                            TextField("Primer equipo", value: $scoreOne, format: .number)
//                                .keyboardType(.decimalPad)
//                        }
//                        HStack {
//                            Text("Segundo equipo:")
//                            TextField("Segundo equipo", value: $scoreTwo, format: .number)
//                                .keyboardType(.decimalPad)
//                        }
//                    }
//
//                    Button("Guardar") {
//
//                        print("Team 1: \(teamOnePlayerOne) and \(teamOnePlayerTwo)")
//                        print("Team 2: \(teamTwoPlayerOne) and \(teamTwoPlayerTwo)")
//
//                        // initialize new match
//                        let newMatch = Match(session: session,
//                                             teamOne: [teamOnePlayerOne, teamOnePlayerTwo],
//                                             teamTwo: [teamTwoPlayerOne, teamTwoPlayerTwo],
//                                             teamOneScore: scoreOne,
//                                             teamTwoScore: scoreTwo,
//                                             isRanked: false)
//
//                        // store match in db
//                        Task {
//                            try await MatchManager.shared.createNewMatch(match: newMatch)
//                        }
//
//                        // add match to session_matches
//
//                        Task {
//                            try await SessionManager.shared.addSessionMatch(sessionId: session.sessionId, matchId: newMatch.matchId)
//                        }
//
//                        // store players in match players subcollection
//                        Task {
//                            try await MatchManager.shared.addMatchPlayer(matchId: newMatch.matchId, userId: teamOnePlayerOne, team: 1)
//                            try await MatchManager.shared.addMatchPlayer(matchId: newMatch.matchId, userId: teamOnePlayerTwo, team: 1)
//                            try await MatchManager.shared.addMatchPlayer(matchId: newMatch.matchId, userId: teamTwoPlayerOne, team: 2)
//                            try await MatchManager.shared.addMatchPlayer(matchId: newMatch.matchId, userId: teamTwoPlayerTwo, team: 2)
//                        }
//
//                        // dismiss
//                        dismiss()
//
//                    }
//                }
//            }
//        }
//        .task {
//            getSessionPlayers()
//        }
//    }
//
//    func getSessionPlayers() {
//        Task {
//            let sessionPlayers = try await SessionManager.shared.getAllSessionPlayers(sessionId: session.sessionId)
//            for sessionPlayer in sessionPlayers {
//                let user = try await UserManager.shared.getUser(userId: sessionPlayer.userId)
//                self.sessionPlayers.append(user)
//            }
//        }
//    }
//}
//
