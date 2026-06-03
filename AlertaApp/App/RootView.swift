import SwiftUI

struct RootView: View {
    var viewModel: AwarenessViewModel

    var body: some View {
        MainRunningTabView()
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
