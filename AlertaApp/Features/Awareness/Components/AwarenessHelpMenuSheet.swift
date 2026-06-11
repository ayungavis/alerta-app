//
//  AwarenessHelpMenuSheet.swift
//  AlertaApp
//
//  Created by Wahyu Kurniawan on 10/06/26.
//

import SwiftUI

struct AwarenessHelpMenuSheet: View {
    let onSelect: (AwarenessHelpContent) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            Text("Learn more")
                .soraFont(.title2, emphasized: true, color: AppColors.textPrimary)

            VStack(spacing: AppSpacing.small) {
                ForEach(AwarenessHelpContent.allCases) { content in
                    Button {
                        onSelect(content)
                    } label: {
                        HStack(spacing: AppSpacing.medium) {
                            Text(content.title)
                                .soraFont(.body, color: AppColors.textPrimary)

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(AppColors.primary)
                        }
                        .padding(.horizontal, AppSpacing.medium)
                        .frame(height: 56)
                        .background(AppColors.surfacePrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(AppColors.backgroundPrimary.ignoresSafeArea())
    }
}
