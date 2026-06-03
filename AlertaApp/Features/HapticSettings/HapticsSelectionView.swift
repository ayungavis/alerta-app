//
//  HapticsSelectionView.swift
//  AlertaApp
//
//  Created by Kyky on 04/06/26.
//

import SwiftUI

struct HapticsSelectionView: View {
    let level: Urgency
    var viewModel: HapticsSettingsViewModel
    var manager: HapticRecorderManager

    @State private var isShowingNewVibrationSheet = false

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        HStack {
                            Text("Alert Level:")
                                .soraFont(size: 16, weight: .regular)
                                .foregroundColor(.white)

                            Text(level.displayName)
                                .soraFont(size: 14, weight: .bold)
                                .foregroundColor(level.color)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .background(AppColors.card)
                                .cornerRadius(20)
                        }
                        .padding(.top, 10)

                        Text("Choose how your device vibrates")
                            .soraFont(size: 16, weight: .regular)
                            .foregroundColor(.white)

                        VStack(alignment: .leading, spacing: 16) {
                            Text("VIBRATION PATTERNS")
                                .soraFont(size: 12, weight: .bold)
                                .foregroundColor(AppColors.cyan)

                            VStack(spacing: 12) {
                                ForEach(viewModel.availablePatterns, id: \.self) { pattern in
                                    SettRowView(
                                        title: pattern,
                                        isSelected: viewModel.selections[level] == pattern,
                                        onSelect: {
                                            viewModel.selectPattern(pattern, for: level)
                                            manager.playPreview(for: pattern)
                                        },
                                        onPlay: { manager.playPreview(for: pattern) }
                                    )
                                }

                                ForEach(viewModel.customPatterns) { pattern in
                                    SettRowView(
                                        title: pattern.name,
                                        isSelected: viewModel.selections[level] == pattern.name,
                                        onSelect: {
                                            viewModel.selectPattern(pattern.name, for: level)
                                            manager.playCustomPattern(steps: pattern.steps)
                                        },
                                        onPlay: { manager.playCustomPattern(steps: pattern.steps) }
                                    )
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }

                VStack(alignment: .leading, spacing: 16) {
                    Button(action: {
                        manager.stopPreview()
                        isShowingNewVibrationSheet = true
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Create New Pattern")
                                .soraFont(size: 16, weight: .medium)
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(AppColors.cyan)
                        .cornerRadius(30)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 24)
                .background(AppColors.background)
            }
        }
        .navigationTitle("Select Haptics")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingNewVibrationSheet) {
            NewVibrationSheet(
                manager: manager,
                viewModel: viewModel
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
}
