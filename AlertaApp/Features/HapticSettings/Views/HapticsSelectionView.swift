//
//  HapticsSelectionView.swift
//  AlertaApp
//
//  Created by Kyky on 04/06/26.
//

import SwiftData
import SwiftUI

struct HapticsSelectionView: View {
    let level: Urgency
    var viewModel: HapticsSettingsViewModel
    var manager: CoreHapticService

    @State private var isShowingNewVibrationSheet = false

    var body: some View {
        ZStack {
            AppColors.backgroundPrimary.ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: AppSpacing.medium) {
                        HStack {
                            Text("Alert Level:")
                                .soraFont(.title3, color: .textPrimary)

                            Text(level.displayName)
                                .soraFont(.title3, emphasized: true, color: level.color)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .background(AppColors.surfacePrimary)
                                .cornerRadius(20)
                        }
                        .padding(.top, 10)

                        VStack(alignment: .leading, spacing: AppSpacing.small) {
                            Text("Choose how your device vibrates")
                                .soraFont(.body, color: .textPrimary)
                            Text("Vibration Patterns")
                                .soraFont(.body, emphasized: true, color: AppColors.secondary)

                            VStack(spacing: 12) {
                                ForEach(viewModel.availablePatterns, id: \.self) { pattern in
                                    SettRowView(
                                        title: pattern,
                                        isSelected: viewModel.selections[level] == pattern,
                                        onSelect: {
                                            viewModel.selectPattern(pattern, for: level)

                                            let events = manager.getEvents(forPreset: pattern)
                                            manager.playHaptic(events: events)
                                        },
                                        onPlay: {
                                            let events = manager.getEvents(forPreset: pattern)
                                            manager.playHaptic(events: events)
                                        }
                                    )
                                }

                                ForEach(viewModel.customPatterns, id: \.name) { pattern in
                                    SettRowView(
                                        title: pattern.name,
                                        isSelected: viewModel.selections[level] == pattern.name,
                                        onSelect: {
                                            viewModel.selectPattern(pattern.name, for: level)

                                            let events = manager.getEvents(fromSteps: pattern.steps)
                                            manager.playHaptic(events: events)
                                        },
                                        onPlay: {
                                            let events = manager.getEvents(fromSteps: pattern.steps)
                                            manager.playHaptic(events: events)
                                        }
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
                        manager.stopHaptic()
                        isShowingNewVibrationSheet = true
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Create New Pattern")
                        }
                        .soraFont(.body, color: AppColors.buttonText)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(AppColors.primary)
                        .cornerRadius(30)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 24)
                .background(AppColors.backgroundPrimary)
            }
        }
        .navigationTitle("Select Haptics")
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Select Haptics")
                    .soraFont(size: 22, weight: .bold)
            }
        }
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

#Preview {
    NavigationStack {
        HapticsSelectionView(
            level: .medium,
            viewModel: HapticsSettingsViewModel(modelContext: try! ModelContainer(
                for: UserSettingsModel.self,
                CustomPatternModel.self
            ).mainContext),
            manager: CoreHapticService()
        )
    }
    .preferredColorScheme(.dark)
}
