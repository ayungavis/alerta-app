//
//  AwarenessHelpDetailView.swift
//  AlertaApp
//
//  Created by Wahyu Kurniawan on 10/06/26.
//

import SwiftUI

struct AwarenessHelpDetailView: View {
    @Environment(\.dismiss) private var dismiss

    let content: AwarenessHelpContent

    var body: some View {
        NavigationStack {
            helpContent
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Close") {
                            dismiss()
                        }
                        .foregroundStyle(AppColors.primary)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
        }
    }

    @ViewBuilder
    private var helpContent: some View {
        switch content {
        case .disclaimer:
            WelcomeInfoBackground {
                VStack(spacing: 0) {
                    DisclaimerContentView()
                    Spacer(minLength: 0)
                }
            }
        case .bestPracticesEarphone:
            WelcomeInfoBackground {
                VStack(spacing: 0) {
                    BestPracticesEarphoneContentView()
                    Spacer(minLength: 0)
                }
            }
        case .bestPracticesPhonePlacement:
            WelcomeInfoBackground {
                BestPracticesPhoneContentView()
            }
        }
    }
}
