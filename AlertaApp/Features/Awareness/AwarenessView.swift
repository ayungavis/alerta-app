import SwiftUI

struct AwarenessView: View {
    @State private var viewModel: AwarenessViewModel

    init(viewModel: AwarenessViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.large) {
                    AwarenessStatusHeader(status: viewModel.state.status)

                    AwarenessEmptyStateView(
                        eventKinds: viewModel.availableEventKinds
                    )
                }
                .padding(AppSpacing.large)
            }
            .background(AppColors.background)
            .navigationTitle(AppConstants.appName)
        }
    }
}

#Preview {
    AwarenessView(
        viewModel: AwarenessViewModel(
            initialState: AwarenessSessionState.initial
        )
    )
}
