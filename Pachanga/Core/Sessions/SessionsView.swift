//
//  SessionsView.swift
//  Pachanga
//
//  Created by Javier Alaves on 15/8/23.
//

import SwiftUI

@MainActor
final class SessionsViewModel: ObservableObject {
    
    @Published private(set) var upcomingSessions: [Session] = []
    
    func getUpcomingSessions() async throws {
        self.upcomingSessions = try await SessionManager.shared.getAllUpcomingSessions()
    }
    
}

struct SessionsView: View {
    
    @StateObject private var viewModel = SessionsViewModel()
    
    var body: some View {
        
        VStack {
//            HStack {
//                Text("Sesiones")
//                    .font(.system(size: 36,  weight: .semibold))
//                    .padding()
//                Spacer()
//            }
//            List {
//                ForEach(viewModel.sessions, id: \.sessionId) { session in
//                    SessionCell(session: session)
//                }
//            }
        
            List {
                ForEach(viewModel.upcomingSessions, id: \.sessionId) { session in
                    SessionCell(session: session)
                }
            }
            
        }
        .navigationTitle("Próximas sesiones")
        .task {
            try? await viewModel.getUpcomingSessions()
        }
    }
}

struct SessionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SessionsView()
        }
    }
}
