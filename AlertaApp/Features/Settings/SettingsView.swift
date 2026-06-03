//
//  SettingsView.swift
//  AlertaApp
//
//  Created by Kyky on 04/06/26.
//

import SwiftUI

struct SettingsView: View {
    @State private var viewModel = HapticsSettingsViewModel()
    @State private var hapticManager = HapticRecorderManager()

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 32) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Alert")
                                .soraFont(size: 16, weight: .bold)
                                .foregroundColor(AppColors.cyan)

                            VStack(spacing: 12) {
                                NavigationLink(destination: HapticsLevelView(
                                    viewModel: viewModel,
                                    manager: hapticManager
                                )) {
                                    SettingsMenuRow(icon: "iphone.radiowaves.left.and.right", title: "Haptics")
                                }

                                NavigationLink(destination: Text("Audio Settings (Coming Soon)")
                                    .foregroundColor(.white))
                                {
                                    SettingsMenuRow(icon: "headphones", title: "Audio")
                                }
                            }
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Display")
                                .soraFont(size: 16, weight: .bold)
                                .foregroundColor(AppColors.cyan)

                            HStack {
                                Image(systemName: "moon")
                                    .foregroundColor(AppColors.cyan)
                                    .font(.system(size: 20))
                                    .frame(width: 32)

                                Text("Theme")
                                    .soraFont(size: 16, weight: .regular)
                                    .foregroundColor(.white)

                                Spacer()

                                ZStack {
                                    Capsule()
                                        .stroke(AppColors.cyan, lineWidth: 1)
                                        .frame(width: 120, height: 32)

                                    HStack(spacing: 0) {
                                        Text("DARK")
                                            .soraFont(size: 12, weight: .bold)
                                            .foregroundColor(.black)
                                            .frame(width: 60, height: 32)
                                            .background(AppColors.cyan)
                                            .clipShape(Capsule())

                                        Text("LIGHT")
                                            .soraFont(size: 12, weight: .bold)
                                            .foregroundColor(.gray)
                                            .frame(width: 60, height: 32)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 64)
                            .background(AppColors.card)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
