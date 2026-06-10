//
//  TotalAlertsHistoryDetail.swift
//  AlertaApp
//
//  Created by Dimas Nugraha on 08/06/26.
//

import SwiftUI

struct TotalAlertsHistoryDetail: View {
    let session: AwarenessSessionRecord

    var body: some View {
        VStack(alignment: .center, spacing: AppSpacing.small) {
            HStack(alignment: .center, spacing: AppSpacing.small) {
                VStack(
                    alignment: .center,
                    spacing: AppSpacing.small
                ) {
                    Image(systemName: "waveform")
                        .foregroundStyle(AppColors.secondary)
                }
                .padding(AppSpacing.small)
                .frame(alignment: .center)
                .background(AppColors.surfaceElevated)
                .cornerRadius(.infinity)

                VStack(alignment: .leading) {
                    Text("\(session.alertCount)")
                        .soraFont(.headline, emphasized: true)
                    Text("Total Alerts")
                        .soraFont(.caption2)
                }
                .frame(alignment: .topLeading)
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 24)
        .frame(alignment: .center)
        .background(AppColors.surfacePrimary)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
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
