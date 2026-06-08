//
//  AlertTimeline.swift
//  AlertaApp
//
//  Created by Dimas Nugraha on 08/06/26.
//

import SwiftUI

struct AlertTimeLine: View {
    
    let timestampWidth: CGFloat = 60
    
    struct AlertItem: Identifiable {
        let id = UUID()
        let time: String
        let timeAgo: String
        let title: String
        let severity: String
        let decibels: String
    }

    let alerts: [AlertItem] = [
        AlertItem(time: "7:59 AM", timeAgo: "3 min ago", title: "Siren Detected", severity: "Critical", decibels: "78 dB"),
        AlertItem(time: "8:02 AM", timeAgo: "Just now",  title: "Siren Detected", severity: "Critical", decibels: "82 dB"),
        AlertItem(time: "7:59 AM", timeAgo: "3 min ago", title: "Siren Detected", severity: "Critical", decibels: "78 dB"),
        AlertItem(time: "8:02 AM", timeAgo: "Just now",  title: "Siren Detected", severity: "Critical", decibels: "82 dB"),
    ]
    
    var body: some View {

        VStack(spacing: 0) {
            ForEach(Array(alerts.enumerated()), id: \.element.id) { index, alert in
                HStack(alignment: .center, spacing: AppSpacing.medium) {

                    // Timestamp
                    VStack(alignment: .leading) {
                        Text(alert.time)
                        Text(alert.timeAgo)
                    }
                    .soraFont(.caption1, color: .textSecondary)
                    .frame(width: timestampWidth, alignment: .leading)

                    // Dot and line
                    ZStack(alignment: .center) {
                        VStack(spacing: 0) {
                            
                            Rectangle()
                                .fill(index == 0 ? Color.clear : AppColors.textSecondary)
                                .frame(width: 2)
                                .frame(maxHeight: .infinity)

                            Rectangle()
                                .fill(index == alerts.count - 1 ? Color.clear : AppColors.textSecondary)
                                .frame(width: 2)
                                .frame(maxHeight: .infinity)
                        }

                        Circle()
                            .foregroundStyle(AppColors.alertCritical)
                            .frame(width: 8, height: 8)
                    }
                    .frame(width: 8)

                    // Card
                    HStack(alignment: .center, spacing: 8) {
                        Image(systemName: "light.beacon.max.fill")
                            .soraFont(.headline, color: AppColors.alertCritical)
                            .padding(8)
                            .background(AppColors.surfaceElevated)
                            .cornerRadius(.infinity)

                        VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                            Text(alert.title)
                                .soraFont(.subheadline)

                            HStack(alignment: .center, spacing: AppSpacing.small) {
                                HStack(spacing: AppSpacing.extraSmall) {
                                    Image(.critical)
                                        .foregroundStyle(AppColors.alertCritical)
                                    Text(alert.severity)
                                }
                                Text("•")
                                Text(alert.decibels)
                            }
                            .soraFont(.caption2, color: AppColors.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(AppColors.surfacePrimary)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.16), radius: 9, x: 0, y: 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .inset(by: 0.5)
                            .stroke(.white.opacity(0.06), lineWidth: 1)
                    )
                    .padding(.vertical, AppSpacing.medium / 2)
                }
            }
        }
    }
}
