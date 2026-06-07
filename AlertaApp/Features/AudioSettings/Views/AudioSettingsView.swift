import SwiftUI

struct AudioSettingsView: View {
    @State private var viewModel = AudioSettingsViewModel()
    var manager: AudioOutputService // Untuk mengetes suara
    
    var body: some View {
        ZStack {
            AppColors.backgroundPrimary.ignoresSafeArea()
            
            VStack(spacing: 32) {
                
                // MARK: - Volume Slider
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Voice Volume")
                            .soraFont(size: 16, weight: .bold)
                            .foregroundColor(AppColors.cyan)
                        Spacer()
                        Text("\(Int(viewModel.voiceVolume * 100))%")
                            .soraFont(size: 14, weight: .regular)
                            .foregroundColor(.gray)
                    }
                    
                    Slider(value: $viewModel.voiceVolume, in: 0.0...1.0)
                        .tint(AppColors.primary)
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                
                // MARK: - Speed Slider
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Voice Speed")
                            .soraFont(size: 16, weight: .bold)
                            .foregroundColor(AppColors.cyan)
                        Spacer()
                        Text(speedLabel(viewModel.voiceSpeed))
                            .soraFont(size: 14, weight: .regular)
                            .foregroundColor(.gray)
                    }
                    
                    Slider(value: $viewModel.voiceSpeed, in: 0.2...0.8) // Dibatasi agar tidak terlalu lambat/cepat
                        .tint(AppColors.primary)
                }
                .padding(.horizontal, 20)
                
                // MARK: - Test Button
                Button(action: {
                    testVoice()
                }) {
                    Text("Test Voice Settings")
                        .soraFont(size: 16, weight: .semiBold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(AppColors.primary)
                        .cornerRadius(30)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                Spacer()
            }
        }
        .navigationTitle("Audio Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Label teks bantu untuk kecepatan
    private func speedLabel(_ value: Float) -> String {
        if value < 0.4 { return "Slow" }
        if value > 0.6 { return "Fast" }
        return "Normal"
    }
    
    // Memutar suara sementara untuk ngetes
    private func testVoice() {
        manager.stopSpeaking() // Hentikan suara sebelumnya jika ada
        manager.playTestVoice(speed: viewModel.voiceSpeed, volume: viewModel.voiceVolume)
    }
}

#Preview {
    NavigationStack {
        AudioSettingsView(manager: AudioOutputService())
            .preferredColorScheme(.dark)
    }
}