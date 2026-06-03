import SwiftUI

struct HapticsSettingsView: View {
    @State private var viewModel = HapticsSettingsViewModel()
    @State private var manager = HapticRecorderManager()
    @State private var isShowingNewVibrationSheet = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: AppSpacing.large) {
                            
                            Text("Choose how your device vibrates")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .padding(.top, 10)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("VIBRATION PATTERNS")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(AppColors.cyan)
                                
                                VStack(spacing: 12) {
                                    ForEach(viewModel.availablePatterns, id: \.self) { pattern in
                                        SettRowView(
                                            title: pattern,
                                            isSelected: viewModel.selectedPattern == pattern,
                                            onSelect: {
                                                viewModel.selectPattern(pattern)
                                                manager.playPreview(for: pattern)
                                            },
                                            onPlay: { manager.playPreview(for: pattern) }
                                        )
                                    }
                                    
                                    ForEach(viewModel.customPatterns) { pattern in
                                        SettRowView(
                                            title: pattern.name,
                                            isSelected: viewModel.selectedPattern == pattern.name,
                                            onSelect: {
                                                viewModel.selectPattern(pattern.name)
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
                        Text("Customize on how your device alerts you through touch.")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                        
                        Button(action: {
                            manager.stopPreview()
                            isShowingNewVibrationSheet = true
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("CREATE NEW PATTERN")
                                    .font(.system(size: 16, weight: .medium, design: .monospaced))
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(AppColors.cyan)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                    .background(AppColors.background)
                }
            }
            .navigationTitle("Haptics")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Haptics")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.cyan)
                }
            }
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
}

#Preview {
    HapticsSettingsView()
}

