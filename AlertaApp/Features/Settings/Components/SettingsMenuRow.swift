//
//  SettingsMenuRow.swift
//  AlertaApp
//
//  Created by Kyky on 04/06/26.
//

import SwiftUI

struct SettingsMenuRow: View {
    let icon: String
    let title: String

    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(AppColors.surfaceElevated)
                    .frame(width: 52, height: 52)
                Image(systemName: icon)
                    .foregroundColor(AppColors.primary)
                    .font(.system(size: 18))
            }
            .frame(width: 44)

            Text(title)
                .soraFont(size: 17, weight: .regular)
                .foregroundColor(.white)
                .padding(.leading, 16)

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(AppColors.primary)
                .font(.system(size: 14, weight: .bold))
        }
        .padding(16)
        .frame(height: 86)
        .background(AppColors.surfacePrimary)
        .cornerRadius(12)
    }
}

#Preview {
    SettingsView()
    .preferredColorScheme(.dark)
}
