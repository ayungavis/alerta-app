import SwiftUI

struct HistoryView: View {
    @State  var viewModel: HistoryViewModel

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppSpacing.medium) {
                    Text("LIVE NOW")
                        .soraFont(
                            .body,
                            emphasized: true,
                            color: AppColors.primary
                        )

                    LiveNowSessionHistory()

                    Text("Today")
                        .soraFont(
                            .body,
                            emphasized: true,
                            color: AppColors.textSecondary
                        )

                    ForEach(viewModel.sessions) { session in
                        NavigationLink(destination: HistoryDetailView()) {
                            SessionHistoryCard(session: session)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Session History")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                let attrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont(name: "Sora-Bold", size: 34)
                        ?? .systemFont(ofSize: 34, weight: .bold)
                ]
                UINavigationBar.appearance().largeTitleTextAttributes = attrs
            }
        }

    }
}

#Preview {
    HistoryView()
        .preferredColorScheme(.dark)
}
