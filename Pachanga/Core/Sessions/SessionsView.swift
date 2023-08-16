//
//  SessionsView.swift
//  Pachanga
//
//  Created by Javier Alaves on 15/8/23.
//

import SwiftUI

@MainActor
final class SessionsViewModel: ObservableObject {
    
    @Published private(set) var sessions: [Session] = []
    
    func getAllSessions() async throws {
        self.sessions = try await SessionManager.shared.getAllSessionsSortedByDate()
    }
    
}

struct SessionsView: View {
    
    @StateObject private var viewModel = SessionsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.sessions, id: \.sessionId) { session in
                SessionCell(session: session)
            }
        }
        .navigationTitle("Sesiones")
        .task {
            try? await viewModel.getAllSessions()
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
