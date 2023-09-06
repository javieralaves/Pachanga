////
////  MatchCell.swift
////  Pachanga
////
////  Created by Javier Alaves on 3/9/23.
////
//
//import SwiftUI
//
//struct MatchCell: View {
//
//    let match: Match
//
//    let matchPlayers: [String] = []
//
//    // array for team one
//    let teamOne = [String]()
//    let teamTwo = [String]()
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 4) {
//            HStack {
//                Text("\(match.teamOne[0]) y \(match.teamOne[1])")
//                Spacer()
//                Text("\(match.teamOneScore)")
//                    .foregroundColor(.secondary)
//            }
//            HStack {
//                Text("\(match.teamTwo[0]) y \(match.teamTwo[1])")
//                Spacer()
//                Text("\(match.teamTwoScore)")
//                    .foregroundColor(.secondary)
//            }
//        }
//    }
//
//    func nameFromUserId(userId: String) async throws -> String {
//        try await UserManager.shared.getUser(userId: userId).name ?? "Juan Doe"
//    }
//
//    func loadTeams() async throws {
//        try await SessionManager.shared
//    }
//}
//
//struct MatchCell_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            MatchCell(match: Match(location: "El Campello",
//                                   matchDate: Date.now,
//                                   teamOne: ["Javier Alaves", "Nacho Alaves"],
//                                   teamTwo: ["Diego Cortes", "Alvaro Perez"],
//                                   teamOneScore: 21,
//                                   teamTwoScore: 19,
//                                   isRanked: false))
//            .padding()
//        }
//    }
//}
