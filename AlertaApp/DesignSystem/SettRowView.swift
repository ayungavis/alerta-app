//
//  SettRowView.swift
//  AlertaApp
//
//  Created by Kyky on 03/06/26.
//

import SwiftUI

struct SettRowView: View {
    let title: String
    let isSelected: Bool
    let onSelect: () -> Void
    let onPlay: () -> Void

    var body: some View {
        HStack {
            Rectangle()
                .fill(AppColors.cyan)
                .frame(width: 10)
                .opacity(isSelected ? 1 : 0)

            Text(title)
                .soraFont(size: 17)
                .foregroundColor(.white)
                .padding(.leading, 12)

            Spacer()

            ZStack {
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(AppColors.cyan)
                        .font(.system(size: 20))
                        .transition(.scale.combined(with: .opacity))
                } else {
                    Image(systemName: "play.circle")
                        .foregroundColor(AppColors.cyan)
                        .font(.system(size: 20))
                        .onTapGesture {
                            onPlay()
                        }
//                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.trailing, 16)
        }
        .frame(height: 48)
        .background(AppColors.card)
        .cornerRadius(12)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                onSelect()
            }
        }
    }
}

#Preview {
    HapticsSettingsView()
}
