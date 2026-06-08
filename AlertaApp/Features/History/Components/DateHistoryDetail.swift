//
//  DateHistoryDetail.swift
//  AlertaApp
//
//  Created by Dimas Nugraha on 08/06/26.
//

import SwiftUI

struct DateHistoryDetail: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text("Today, 29 May 2026")
                .soraFont(.headline)
            HStack(spacing: AppSpacing.small) {
                Text("7:30 – 8:02 AM ")
                Text("•")
                Text("32 min")
            }
            .soraFont(.caption1, color: AppColors.textSecondary)
        }
    }
}

#Preview {
    DateHistoryDetail()
}
