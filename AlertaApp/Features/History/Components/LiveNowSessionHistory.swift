//
//  LiveNowSessionHistory.swift
//  AlertaApp
//
//  Created by Dimas Nugraha on 08/06/26.
//

import SwiftUI

struct LiveNowSessionHistory: View {
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
                        Text("Started \(session.startedAt.shortTime)")
                    }
                    .soraFont(
                        .caption1,
                        color: AppColors.textSecondary
                    )

                    HStack(
                        alignment: .top,
                        spacing: AppSpacing.extraSmall
                    ) {
                        VStack(
                            alignment: .leading,
                            spacing: AppSpacing.extraSmall
                        ) {
                            HStack(spacing: AppSpacing.extraSmall) {
                                Image(.critical)
                                    .foregroundStyle(
                                        Color(AppColors.alertCritical)
                                    )
                                Text("\(session.alertCount(for: .critical))")
                                Text("Critical")
                            }
                            HStack(spacing: AppSpacing.extraSmall) {
                                Image(.high)
                                    .foregroundStyle(
                                        Color(AppColors.alertHigh)
                                    )
                                Text("\(session.alertCount(for: .critical))")
                                Text("High")
                            }
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
                    VStack(spacing: AppSpacing.small) {
                        HStack(spacing: AppSpacing.extraSmall) {
                            Image(.record)
                                .foregroundStyle(.buttonDestructiveDefault)
                                .font(.footnote)

                            Text("LIVE")
                                .soraFont(
                                    .footnote,
                                    emphasized: true,
                                    color: .buttonDestructiveDefault
                                )
                        }
                        HStack(spacing: AppSpacing.medium) {
                            VStack(alignment: .center) {
                                TimelineView(.periodic(from: .now, by: 1)) {
                                    _ in
                                    Text(session.startedAt.duration(to: .now, live: true))
                                        .soraFont(
                                            .title1,
                                            emphasized: true
                                        )
                                }
                                Text("Ongoing")
                                    .soraFont(
                                        .caption1,
                                        color: AppColors.textSecondary
                                    )
                            }
                            .fixedSize()

                            VStack(alignment: .center) {
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
                            .fixedSize()
                        }
                    }
                    .layoutPriority(2)
                    .lineLimit(1)

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
                    .stroke(AppColors.primary, lineWidth: 1)
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
