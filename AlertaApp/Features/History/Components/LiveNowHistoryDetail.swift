//
//  LiveNowHistoryDetail.swift
//  AlertaApp
//
//  Created by Dimas Nugraha on 08/06/26.
//

import SwiftUI

struct LiveNowHistoryDetail: View {
    let session: AwarenessSessionRecord
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            HStack(alignment: .center, spacing: AppSpacing.medium) {
                HStack(spacing: AppSpacing.extraSmall) {
                    Image(.record)
                        .foregroundStyle(.buttonDestructiveDefault)
                        .font(.headline)

                    Text("LIVE")
                        .soraFont(
                            .headline,
                            emphasized: true,
                            color: .buttonDestructiveDefault
                        )
                }

                VStack(alignment: .center) {
                    Text("Ongoing")
                        .soraFont(.caption2, color: .textSecondary)

                    TimelineView(.periodic(from: .now, by: 1)) { _ in
                        Text("\(session.startedAt.duration(to: .now, live: true))")
                            .soraFont(.title2, emphasized: true)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(AppSpacing.extraSmall)
        }
        .padding(.horizontal, AppSpacing.medium)
        .padding(.vertical, AppSpacing.small)
        .background(AppColors.surfacePrimary)
        .cornerRadius(AppSpacing.medium)
        .shadow(color: .black.opacity(0.16), radius: 9, x: 0, y: 8)
        .overlay(
            RoundedRectangle(cornerRadius: AppSpacing.medium)
                .inset(by: 0.5)
                .stroke(.white.opacity(0.06), lineWidth: 1)
        )
    }
}

#Preview {
    NavigationStack {
        HistoryDetailView(session: .mockLive)
            .preferredColorScheme(.dark)
    }
}
