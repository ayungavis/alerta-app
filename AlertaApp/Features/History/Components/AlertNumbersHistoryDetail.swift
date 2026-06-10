//
//  AlertNumbersHistoryDetail.swift
//  AlertaApp
//
//  Created by Dimas Nugraha on 08/06/26.
//

import SwiftUI

struct AlertNumbersHistoryDetail: View {
    let session: AwarenessSessionRecord

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            HStack(alignment: .center, spacing: 8) {
                HStack(alignment: .center) {
                    let priorities: [(AppSymbol, String, Int)] = [
                        (.critical, "Critical", session.alertCount(for: .critical)),
                        (.high, "High", session.alertCount(for: .high)),
                        (.medium, "Medium", session.alertCount(for: .medium)),
                        (.low, "Low", session.alertCount(for: .low))
                    ]

                    ForEach(priorities, id: \.1) {
                        symbol,
                        label,
                        count in
                        VStack(alignment: .center) {
                            AppSymbols(symbol)
                        }
                        .padding(AppSpacing.small)
                        .frame(alignment: .center)
                        .background(AppColors.surfaceElevated)
                        .cornerRadius(.infinity)

                        VStack(alignment: .center) {
                            Text("\(count)")
                                .soraFont(.headline, emphasized: true)
                            Text(label)
                                .soraFont(.caption2)
                        }
                        .fixedSize()
                        .frame(alignment: .center)

                        if label != "Low" {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 1)
                                .background(AppColors.surfaceElevated)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(8)
        .frame(
            maxWidth: .infinity,
            minHeight: 71,
            maxHeight: 71,
            alignment: .center
        )
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
