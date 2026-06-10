import SwiftUI

struct HistoryDetailView: View {
    @Environment(\.dismiss) private var dismiss

    let session: AwarenessSessionRecord

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: AppSpacing.medium) {
                    if session.isLive { DateHistoryDetail(session: session) }

                    HStack(alignment: .center) {
                        if session.isLive {
                            LiveNowHistoryDetail(session: session)
                        } else {
                            DateHistoryDetail(session: session)
                        }
                        Spacer()
                        TotalAlertsHistoryDetail(session: session)
                    }
                    .frame(maxWidth: .infinity)

                    AlertNumbersHistoryDetail(session: session)

                    Text("Alert Timeline")
                        .soraFont(.headline)

                    AlertTimeLine(session: session)
                }
                .padding(.horizontal, AppSpacing.medium)
            }

            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
            .listSectionSeparator(.hidden)
        }
        .listStyle(.plain).navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Morning Run")
                    .soraFont(.title2, emphasized: true)
            }
        }
    }
}

#Preview {
    NavigationStack {
        HistoryDetailView(session: .mockLive)
            .preferredColorScheme(.dark)
    }
}
