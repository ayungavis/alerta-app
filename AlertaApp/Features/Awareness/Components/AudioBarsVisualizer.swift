import SwiftUI

struct AudioBarsVisualizer: View {
    enum Mode {
        case idle
        case monitoring
        case processing
        case stopping
    }

    let bands: [FrequencyBand]
    let mode: Mode

    private let barCount = 12
    private let barWidth: CGFloat = 10
    private let spacing: CGFloat = 7
    private let maxHeight: CGFloat = 77

    var body: some View {
        VStack(spacing: 0) {
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
            .frame(height: maxHeight)

            Text(statusText)
                .font(AppFont.soraSemiBold(17))
                .foregroundStyle(statusColor)
                .tracking(-0.43)
                .padding(.top, statusTopPadding)
                .animation(.easeInOut(duration: 0.3), value: statusText)
        }
        .frame(width: 296, height: visualizerHeight)
    }

    private func barHeight(at index: Int) -> CGFloat {
        switch mode {
        case .idle, .stopping:
            31
        case .monitoring, .processing:
            activeBarHeight(at: index)
        }
    }

    private func activeBarHeight(at index: Int) -> CGFloat {
        if bands.contains(where: { $0.normalizedEnergy > 0 }) {
            let bandIndex = index / 2
            guard bandIndex < bands.count else { return 31 }

            let band = bands[bandIndex]
            let normalized = CGFloat(band.normalizedEnergy)
            let base: CGFloat = 4 + normalized * (maxHeight - 4)
            return max(base, 4)
        }

        let fallbackHeights: [CGFloat] = [31, 61, 47, 77, 39, 31, 61, 47, 31, 77, 39, 31]
        return fallbackHeights[index]
    }

    private func barColor(at index: Int) -> Color {
        switch mode {
        case .idle, .stopping:
            AppColors.primaryDark
        case .monitoring, .processing:
            activeBarColor(at: index)
        }
    }

    private func activeBarColor(at index: Int) -> Color {
        let fallbackColors: [Color] = [
            AppColors.primaryDark,
            AppColors.secondary,
            AppColors.primaryDark.opacity(0.88),
            AppColors.primary,
            AppColors.primaryDark.opacity(0.92),
            AppColors.primaryDark,
            AppColors.secondary,
            AppColors.primaryDark.opacity(0.88),
            AppColors.primaryDark,
            AppColors.primary,
            AppColors.primaryDark.opacity(0.92),
            AppColors.primaryDark
        ]

        let bandIndex = index / 2
        guard bandIndex < bands.count else { return fallbackColors[index] }

        if !bands.contains(where: { $0.normalizedEnergy > 0 }) {
            return fallbackColors[index]
        }

        let energy = bands[bandIndex].normalizedEnergy
        if energy > 0.7 { return AppColors.alertMedium }
        if energy > 0.4 { return AppColors.alertLow }
        if energy > 0.15 { return AppColors.primary }
        return AppColors.primaryDark
    }

    private var statusText: String {
        switch mode {
        case .idle:
            "Idle mode"
        case .monitoring:
            "Calibrating.."
        case .processing:
            "Processing.."
        case .stopping:
            "Stop Monitoring.."
        }
    }

    private var statusColor: Color {
        switch mode {
        case .idle:
            AppColors.secondary
        case .monitoring, .processing, .stopping:
            AppColors.primary
        }
    }

    private var statusTopPadding: CGFloat {
        switch mode {
        case .idle:
            3
        case .monitoring, .processing:
            18
        case .stopping:
            3
        }
    }

    private var visualizerHeight: CGFloat {
        switch mode {
        case .idle:
            92
        case .monitoring, .processing:
            149
        case .stopping:
            114
        }
    }
}

#Preview("Idle") {
    AudioBarsVisualizer(bands: FrequencySpectrum.zero.bands, mode: .idle)
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
    return AudioBarsVisualizer(bands: bands, mode: .monitoring)
        .padding()
        .background(AppColors.backgroundPrimary)
}
