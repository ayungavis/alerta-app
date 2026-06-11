//
//  AlertTimeline.swift
//  AlertaApp
//
//  Created by Dimas Nugraha on 08/06/26.
//

import SwiftUI

struct AlertTimeLine: View {
    let session: AwarenessSessionRecord

    let timestampWidth: CGFloat = 60

    var body: some View {
        VStack(spacing: 0) {
            if session.alerts.isEmpty {
                PlaceholderView(style: .timeline)
                    .frame(width: UIScreen.main.bounds.width * 0.75)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: UIScreen.main.bounds.height * 0.5)
            } else {
                ForEach(Array(session.alerts.reversed().enumerated()), id: \.element.id) {
                    index,
                    alert in
                    HStack(alignment: .center, spacing: AppSpacing.medium) {
                        // Timestamp
                        VStack(alignment: .leading, spacing: 0) {
                            Text(alert.timestamp.shortTime)
                            TimelineView(.periodic(from: .now, by: 1)) { _ in
                                Text(alert.timestamp.duration(to: .now))
                            }
                        }
                        .soraFont(.caption1, color: .textSecondary)
                        .frame(width: timestampWidth, alignment: .leading)

                        // Dot and line
                        ZStack(alignment: .center) {
                            VStack(spacing: 0) {
                                Rectangle()
                                    .fill(
                                        index == 0
                                            ? Color.clear
                                            : AppColors.textDisabled
                                    )
                                    .frame(width: 2)
                                    .frame(maxHeight: .infinity)

                                Rectangle()
                                    .fill(
                                        index == session.alerts.count - 1
                                            ? Color.clear
                                            : AppColors.textDisabled
                                    )
                                    .frame(width: 2)
                                    .frame(maxHeight: .infinity)
                            }
                            .padding(.vertical, -8)

                            Circle()
                                .foregroundStyle(alert.urgency.color)
                                .frame(width: 8, height: 8)
                        }
                        .frame(width: 8)

                        // Card
                        HStack(alignment: .center, spacing: 8) {
                            Image(alert.soundEvent.symbol)
                                .soraFont(.headline, color: alert.urgency.color)
                                .padding(8)
                                .background(AppColors.surfaceElevated)
                                .clipShape(Circle())

                            VStack(
                                alignment: .leading,
                                spacing: AppSpacing.extraSmall
                            ) {
                                Text(alert.soundEvent.displayName)
                                    .soraFont(.subheadline)

                                HStack(
                                    alignment: .center,
                                    spacing: AppSpacing.small
                                ) {
                                    HStack(spacing: AppSpacing.extraSmall) {
                                        Image(alert.urgency.symbol)
                                            .foregroundStyle(
                                                alert.urgency.color
                                            )
                                        Text(alert.urgency.displayName)
                                    }
                                    Text("•")
                                    Text(soundLevelText(for: alert))
                                }
                                .soraFont(
                                    .caption2,
                                    color: AppColors.textSecondary
                                )
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(AppColors.surfacePrimary)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .inset(by: 0.5)
                                .stroke(.white.opacity(0.06), lineWidth: 1)
                        )
                        .padding(.vertical, AppSpacing.small)
                    }
                }
            }
        }
    }

    private func soundLevelText(for alert: AwarenessAlertRecord) -> String {
        guard let soundLevelDecibels = alert.soundLevelDecibels else {
            return "-- dBFS"
        }

        return "\(Int(soundLevelDecibels.rounded())) dBFS"
    }
}

#Preview {
    NavigationStack {
        HistoryDetailView(session: .mockLive)
            .preferredColorScheme(.dark)
    }
}
