//
//  AwarenessEmptyStateView.swift
//  AlertaApp
//
//  Created by Wahyu Kurniawan on 20/05/26.
//

import SwiftUI

struct AwarenessEmptyStateView: View {
    let eventKinds: [AwarenessEventKind]

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            Text("Detection categories")
                .font(.headline)
                .foregroundStyle(AppColors.textPrimary)

            Text("These placeholders define the product categories before real audio services are connected.")
                .font(.subheadline)
                .foregroundStyle(AppColors.textSecondary)

            VStack(alignment: .leading, spacing: AppSpacing.small) {
                ForEach(eventKinds) { eventKind in
                    Label(eventKind.title, systemImage: "waveform")
                        .font(.body)
                        .foregroundStyle(AppColors.textPrimary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.medium)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.small))
    }
}

#Preview {
    AwarenessEmptyStateView(eventKinds: AwarenessEventKind.allCases)
}
