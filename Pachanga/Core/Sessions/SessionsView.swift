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
    @Published private(set) var myUpcomingSessions: [Session] = []
    
    func getUpcomingSessions() async throws {
        self.upcomingSessions = try await SessionManager.shared.getAllUpcomingSessions()
    }
    
    func getMyUpcomingSessions() async throws {
        self.myUpcomingSessions = try await SessionManager.shared.getMyUpcomingSessions()
    }
}

struct SessionsView: View {
    @StateObject private var viewModel = SessionsViewModel()
    
    var body: some View {
        VStack {
            List {
                if viewModel.myUpcomingSessions.count > 0 {
                    Section ("Mis sesiones") {
                        ForEach(viewModel.myUpcomingSessions, id: \.sessionId) { session in
                            NavigationLink {
                                SessionView(session: session)
                            } label: {
                                SessionCell(session: session)
                            }
                        }
                    }
                }
                Section ("Todas las sesiones") {
                    ForEach(viewModel.upcomingSessions, id: \.sessionId) { session in
                        NavigationLink {
                            SessionView(session: session)
                        } label: {
                            SessionCell(session: session)
                        }
                    }
                }
            }
        }
        .navigationTitle("Próximas sesiones")
        .toolbar {
            NavigationLink {
                NewSession()
            } label: {
                Image(systemName: "plus")
                    .font(.headline)
            }
        }
        .task {
            try? await viewModel.getMyUpcomingSessions()
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
