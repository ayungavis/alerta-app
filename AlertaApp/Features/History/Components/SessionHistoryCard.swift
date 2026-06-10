//
//  SessionHistoryCard.swift
//  AlertaApp
//
//  Created by Dimas Nugraha on 07/06/26.
//

import SwiftUI

struct SessionHistoryCard: View {
    let session: AwarenessSessionRecord

    var body: some View {
        ZStack(alignment: .trailing) {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: .infinity, height: .infinity)
                .background(AppColors.primary)
                .cornerRadius(AppSpacing.medium)

            HStack(
                alignment: .center,
                spacing: AppSpacing.medium
            ) {

                VStack(
                    alignment: .leading,
                    spacing: AppSpacing.small
                ) {
                    Text(session.title)
                        .soraFont(.headline, emphasized: true)
                    HStack(
                        alignment: .center,
                        spacing: AppSpacing.extraSmall
                    ) {
                        Text(
                            session.startedAt.timeRange(
                                to: session.endedAt ?? .now
                            )
                        )
                        Text("•")
                        Text(session.startedAt.duration(to: session.endedAt ?? .now))
                    }
                    .soraFont(
                        .caption1,
                        color: AppColors.textSecondary
                    )

                    HStack(
                        alignment: .top,
                        spacing: AppSpacing.extraSmall
                    ) {
                        HStack(
                            alignment: .center,
                            spacing: AppSpacing.extraSmall
                        ) {
                            Image(.critical)
                                .foregroundStyle(
                                    Color(AppColors.alertCritical)
                                )
                            Text("\(session.alertCount(for:.critical))")
                            Text("Critical")

                            Image(.high)
                                .foregroundStyle(
                                    Color(AppColors.alertHigh)
                                )
                            Text("\(session.alertCount(for:.critical))")
                            Text("High")
                        }
                        .soraFont(
                            .caption2,
                            color: AppColors.textTertiary
                        )
                    }
                }
                .layoutPriority(1)
                .lineLimit(1)
                .padding(10)

                Spacer()

                HStack(spacing: AppSpacing.large) {
                    VStack(alignment: .center, spacing: 0) {
                        Text("\(session.alertCount)")
                            .soraFont(
                                .title1,
                                emphasized: true,
                                color: AppColors.secondary
                            )
                        Text("Alerts")
                            .soraFont(
                                .caption1,
                                color: AppColors.textSecondary
                            )
                    }

                    Image(systemName: "chevron.right")
                        .soraFont(
                            .title3,
                            color: AppColors.textSecondary
                        )
                }

            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppColors.surfacePrimary)
            .cornerRadius(AppSpacing.medium)
            .shadow(
                color: .black.opacity(0.18),
                radius: 12,
                x: 0,
                y: 8
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppSpacing.medium)
                    .inset(by: 0.5)
                    .stroke(.white.opacity(0.06), lineWidth: 1)
            )
            .padding(.leading, 3)
        }
        .frame(maxWidth: .infinity)

    }
}

#Preview {
    HistoryView()
        .preferredColorScheme(.dark)
}
