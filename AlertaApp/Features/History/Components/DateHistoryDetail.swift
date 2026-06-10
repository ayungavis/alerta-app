//
//  DateHistoryDetail.swift
//  AlertaApp
//
//  Created by Dimas Nugraha on 08/06/26.
//

import SwiftUI

struct DateHistoryDetail: View {
    let session: AwarenessSessionRecord
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text("\(session.startedAt.longDate)")
                .soraFont(.headline)
            HStack(spacing: AppSpacing.small) {
                Text("\(session.startedAt.timeRange(to: .now))")
                Text("•")
                Text("\(session.startedAt.duration(to: .now))")
            }
            .soraFont(.caption1, color: AppColors.textSecondary)
        }
    }
}

#Preview {
    NavigationStack {
        HistoryDetailView(session: .mockLive)
            .preferredColorScheme(.dark)
    }
}

