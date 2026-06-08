import SwiftUI

struct HistoryDetailView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: AppSpacing.medium) {
                    DateHistoryDetail()

                    HStack(alignment: .center) {
                        LiveNowHistoryDetail()
                        Spacer()
                        TotalAlertsHistoryDetail()
                    }
                    .frame(maxWidth: .infinity)

                    AlertNumbersHistoryDetail()

                    Text("Alert Timeline")
                        .soraFont(.headline)

                    AlertTimeLine()
                    
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
        HistoryDetailView()
            .preferredColorScheme(.dark)
    }
}
