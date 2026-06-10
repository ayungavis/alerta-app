import SwiftData
import SwiftUI

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @State var viewModel: HistoryViewModel = .init()

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                if viewModel.sessions.isEmpty {
                    PlaceholderView(style: .main)
                        .frame(width: UIScreen.main.bounds.width * 0.75)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(height: UIScreen.main.bounds.height * 0.5)
                } else {
                    VStack(alignment: .leading, spacing: AppSpacing.medium) {
                        if viewModel.isLive {
                            Text("LIVE NOW")
                                .soraFont(
                                    .body,
                                    emphasized: true,
                                    color: AppColors.primary
                                )
                        }
                        ForEach(viewModel.liveSessions) {
                            session in
                            NavigationLink(destination: HistoryDetailView(session: session)) {
                                LiveNowSessionHistory(session: session)
                            }
                        }

                        ForEach(viewModel.groupedSessions, id: \.0) {
                            header,
                            sessions in
                            Text(header)
                                .soraFont(
                                    .body,
                                    emphasized: true,
                                    color: AppColors.textSecondary
                                )

                            ForEach(sessions) { session in
                                NavigationLink(
                                    destination: HistoryDetailView(
                                        session: session
                                    )
                                ) {
                                    SessionHistoryCard(session: session)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Session History")
            .navigationBarTitleDisplayMode(.large)
            .task {
                viewModel.loadSessions(context: modelContext)
                UINavigationBar.appearance().largeTitleTextAttributes =
                    [
                        .font: UIFont(name: "Sora-Bold", size: 34)
                            ?? .systemFont(ofSize: 34, weight: .bold)
                    ] as [NSAttributedString.Key: Any]
            }
        }
    }
}

#Preview {
    HistoryView()
        .preferredColorScheme(.dark)
}
