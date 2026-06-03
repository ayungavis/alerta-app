//
//  RootView.swift
//  AlertaApp
//
//  Created by Wahyu Kurniawan on 20/05/26.
//

import SwiftUI

struct RootView: View {
    var viewModel: AwarenessViewModel

    var body: some View {
        MainRunningTabView()
        // NavigationStack {
        //     WelcomeView()
        // }
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
