import SwiftUI

struct DetectionAlertView: View {
    let event: DetectionEvent

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: alertIcon)
                .font(.system(size: 40))
                .foregroundStyle(urgencyColor)

            HStack(spacing: 0) {
                sideBars(reversed: false)

                Spacer()

                Text(headingText)
                    .font(AppFont.soraBold(34))
                    .foregroundStyle(urgencyColor)

                Spacer()

                sideBars(reversed: true)
            }
            .frame(height: 73)

            VStack(spacing: 4) {
                Image(systemName: eventTypeIcon)
                    .font(.system(size: 24))
                    .foregroundStyle(AppColors.secondary)

                Text(event.rawIdentifier)
                    .font(AppFont.soraRegular(17))
                    .foregroundStyle(AppColors.secondary)
            }
        }
    }

    private var alertIcon: String {
        switch event.urgency {
        case .low: "exclamationmark.triangle"
        case .medium: "exclamationmark.shield"
        case .high: "exclamationmark.octagon"
        case .critical: "light.beacon.max"
        }
    }

    private var headingText: String {
        switch event.urgency {
        case .low: "Stay Aware"
        case .medium: "Look Around"
        case .high: "Move Away"
        case .critical: "Danger!"
        }
    }

    private var urgencyColor: Color {
        switch event.urgency {
        case .low: AppColors.alertInfo
        case .medium: AppColors.alertLow
        case .high: AppColors.alertMedium
        case .critical: AppColors.alertCritical
        }
    }

    private var barHeights: [CGFloat] {
        switch event.urgency {
        case .low: [15]
        case .medium: [33, 15]
        case .high: [51, 33, 15]
        case .critical: [73, 51, 33, 15]
        }
    }

    private var eventTypeIcon: String {
        switch event.soundEvent {
        case .approachingVehicle: "car"
        case .bicycleOrScooter: "bicycle"
        case .horn: "megaphone"
        case .siren: "light.beacon.max"
        case .nearbyPersonMovement: "figure.walk"
        case .generalLoudSound: "speaker.wave.3"
        }
    }

    @ViewBuilder
    private func sideBars(reversed: Bool) -> some View {
        let heights = reversed ? barHeights.reversed() : Array(barHeights)
        HStack(spacing: 5) {
            ForEach(0 ..< heights.count, id: \.self) { index in
                Rectangle()
                    .fill(urgencyColor)
                    .frame(width: 8, height: heights[index])
                    .clipShape(RoundedRectangle(cornerRadius: 9999))
            }
        }
    }
}

#Preview("Low") {
    DetectionAlertView(event: DetectionEvent(
        id: UUID(),
        soundEvent: .approachingVehicle,
        direction: .nearby,
        confidence: 0.3,
        urgency: .low,
        topCandidates: [],
        rawIdentifier: "Traffic Sound Detected",
        timestamp: Date(),
        frequencyInfo: nil,
        soundName: nil
    ))
    .padding()
    .background(AppColors.backgroundPrimary)
}

#Preview("Medium") {
    DetectionAlertView(event: DetectionEvent(
        id: UUID(),
        soundEvent: .bicycleOrScooter,
        direction: .nearby,
        confidence: 0.5,
        urgency: .medium,
        topCandidates: [],
        rawIdentifier: "Bicycle Bell Detected",
        timestamp: Date(),
        frequencyInfo: nil,
        soundName: nil
    ))
    .padding()
    .background(AppColors.backgroundPrimary)
}

#Preview("Critical") {
    DetectionAlertView(event: DetectionEvent(
        id: UUID(),
        soundEvent: .siren,
        direction: .nearby,
        confidence: 0.9,
        urgency: .critical,
        topCandidates: [],
        rawIdentifier: "Siren Detected",
        timestamp: Date(),
        frequencyInfo: nil,
        soundName: nil
    ))
    .padding()
    .background(AppColors.backgroundPrimary)
}
