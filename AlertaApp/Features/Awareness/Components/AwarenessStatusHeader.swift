//
//  AwarenessStatusHeader.swift
//  AlertaApp
//
//  Created by Wahyu Kurniawan on 20/05/26.
//

import SwiftUI

struct AwarenessStatusHeader: View {
    let status: AwarenessStatus

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text(status.title)
                .font(.title2.weight(.semibold))
                .foregroundStyle(AppColors.textPrimary)

            Text(status.description)
                .font(.body)
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.medium)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.small))
    }
}

#Preview {
    AwarenessStatusHeader(status: .notStarted)
}
