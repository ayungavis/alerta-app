import SwiftUI

struct AudioBarsVisualizer: View {
    let bands: [FrequencyBand]
    let isActive: Bool

    private let barCount = 12
    private let barWidth: CGFloat = 10
    private let spacing: CGFloat = 7
    private let maxHeight: CGFloat = 77

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0 ..< barCount, id: \.self) { index in
                Rectangle()
                    .fill(barColor(at: index))
                    .frame(width: barWidth, height: barHeight(at: index))
                    .clipShape(RoundedRectangle(cornerRadius: 9999))
                    .frame(height: maxHeight, alignment: .bottom)
                    .animation(.easeInOut(duration: 0.3), value: barHeight(at: index))
            }
        }
    }

    private func barHeight(at index: Int) -> CGFloat {
        guard isActive else { return 31 }

        let bandIndex = index / 2
        guard bandIndex < bands.count else { return 31 }

        let band = bands[bandIndex]
        let normalized = CGFloat(band.normalizedEnergy)
        let base: CGFloat = 4 + normalized * (maxHeight - 4)
        return max(base, 4)
    }

    private func barColor(at index: Int) -> Color {
        guard isActive else { return AppColors.primaryDark }

        let bandIndex = index / 2
        guard bandIndex < bands.count else { return AppColors.primaryDark }

        let energy = bands[bandIndex].normalizedEnergy
        if energy > 0.7 { return AppColors.alertMedium }
        if energy > 0.4 { return AppColors.alertLow }
        if energy > 0.15 { return AppColors.primary }
        return AppColors.primaryDark
    }
}

#Preview("Idle") {
    AudioBarsVisualizer(bands: FrequencySpectrum.zero.bands, isActive: false)
        .padding()
        .background(AppColors.backgroundPrimary)
}

#Preview("Active") {
    let bands = FrequencyBand.defaultBands.enumerated().map { index, template in
        FrequencyBand(
            name: template.name,
            range: template.range,
            energy: [0.003, 0.01, 0.008, 0.035, 0.012, 0.005][index]
        )
    }
    return AudioBarsVisualizer(bands: bands, isActive: true)
        .padding()
        .background(AppColors.backgroundPrimary)
}
