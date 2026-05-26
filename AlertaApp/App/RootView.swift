import SwiftUI

struct RootView: View {
    var body: some View {
        AwarenessView(
            viewModel: AwarenessViewModel(
                initialState: AwarenessSessionState.initial
            )
        )
    }
}

#Preview {
    RootView()
}
