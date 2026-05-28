import SwiftUI

struct RootView: View {
    var viewModel: AwarenessViewModel

    var body: some View {
        AwarenessView(viewModel: viewModel)
    }
}

#Preview {
    RootView(
        viewModel: AwarenessViewModel(
            initialState: AwarenessSessionState.initial,
            hapticService: FallbackHapticService()
        )
    )
}
