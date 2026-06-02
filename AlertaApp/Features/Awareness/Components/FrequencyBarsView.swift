import SwiftUI

enum FrequencyBarsStyle {
    case live
    case baseline
}

struct FrequencyBarsView: View {
    let bands: [FrequencyBand]
    var style: FrequencyBarsStyle = .live

    private let maxBarHeight: CGFloat = 48

    var body: some View {
        HStack(spacing: 6) {
            ForEach(bands, id: \.name) { band in
                VStack(spacing: 4) {
                    Rectangle()
                        .fill(barColor(for: band.normalizedEnergy))
                        .frame(width: 10, height: barHeight(for: band))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .frame(height: maxBarHeight, alignment: .bottom)
                        .animation(.easeInOut(duration: 0.25), value: band.energy)

                    Text(band.label)
                        .font(.system(size: 9, weight: .medium))
                        .foregroundStyle(Color("textSecondary"))
                        .animation(.easeInOut(duration: 0.25), value: band.energy)
                }
            }
        }
        .opacity(style == .baseline ? 0.4 : 1.0)
    }

    private func barHeight(for band: FrequencyBand) -> CGFloat {
        let minHeight: CGFloat = 4
        let scaled = CGFloat(band.normalizedEnergy) * (maxBarHeight - minHeight)
        return max(scaled + minHeight, minHeight)
    }

    private func barColor(for normalizedEnergy: Float) -> Color {
        if normalizedEnergy > 0.7 { return Color("alertMedium") }
        if normalizedEnergy > 0.4 { return Color("alertLow") }
        if normalizedEnergy > 0.15 { return Color("primary") }
        return Color("primaryDark")
    }
}

#Preview("Zero energy") {
    FrequencyBarsView(bands: FrequencySpectrum.zero.bands)
        .padding()
        .background(Color("backgroundPrimary"))
}

#Preview("Active energy") {
    let activeBands = FrequencyBand.defaultBands.enumerated().map { index, template in
        FrequencyBand(
            name: template.name,
            range: template.range,
            energy: [0.003, 0.01, 0.008, 0.035, 0.012, 0.005][index]
        )
    }
    return FrequencyBarsView(bands: activeBands)
        .padding()
        .background(Color("backgroundPrimary"))
}
