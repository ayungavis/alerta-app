import SwiftUI

struct DetectionAlertView: View {
    let event: DetectionEvent
    let isHapticAlertEnabled: Bool
    let isAudioAlertEnabled: Bool
    let toggleHapticAlert: () -> Void
    let toggleAudioAlert: () -> Void

    var body: some View {
        Stack(direction: .vertical, align: .center, spacing: 43, width: .fill, height: .fixed(319)) {
            alertHeader
            eventSummary
            compactCueRow
        }
    }

    private var alertHeader: some View {
        VStack(spacing: 0) {
            Image(systemName: alertIcon)
                .font(.system(size: 40))
                .foregroundStyle(urgencyColor)
                .frame(height: 48)

            HStack(spacing: 0) {
                sideBars(reversed: true)

                Spacer()

                Text(headingText)
                    .font(AppFont.soraBold(34))
                    .foregroundStyle(urgencyColor)

                Spacer()

                sideBars(reversed: false)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 73)
            .padding(.top, 6)
        }
        .frame(height: 127)
    }

    private var eventSummary: some View {
        VStack(spacing: 5) {
            Image(systemName: eventTypeIcon)
                .font(.system(size: eventTypeIconSize))
                .foregroundStyle(AppColors.secondary)
                .frame(height: 27)

            Text(eventDisplayName)
                .font(AppFont.soraRegular(17))
                .foregroundStyle(AppColors.secondary)
                .tracking(-0.43)
                .lineLimit(1)
                .minimumScaleFactor(0.85)
        }
        .frame(width: 190, height: 56)
    }

    private var compactCueRow: some View {
        HStack(spacing: 15) {
            CueBadgeView(
                icon: "iphone.radiowaves.left.and.right",
                label: "Haptics",
                style: .compact,
                isActive: isHapticAlertEnabled,
                action: toggleHapticAlert
            )
            CueBadgeView(
                icon: "airpods.max",
                label: "Sound",
                style: .compact,
                isActive: isAudioAlertEnabled,
                action: toggleAudioAlert
            )
        }
        .frame(height: 47)
    }

    private var alertIcon: String {
        switch event.urgency {
        case .low: "exclamationmark.circle.fill"
        case .medium: "exclamationmark.square.fill"
        case .high: "exclamationmark.triangle.fill"
        case .critical: "exclamationmark.shield.fill"
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
        case .approachingVehicle: "car.fill"
        case .bicycleOrScooter: "bicycle"
        case .horn: "horn.fill"
        case .siren: "light.beacon.max.fill"
        case .nearbyPersonMovement: "figure.walk.motion"
        case .generalLoudSound: "speaker.wave.3.fill"
        }
    }

    private var eventTypeIconSize: CGFloat {
        switch event.soundEvent {
        case .siren:
            25
        default:
            24
        }
    }

    private var eventDisplayName: String {
        if let soundName = event.soundName, !soundName.isEmpty, event.soundName != "Unknown" {
            return soundName
        }

        switch event.soundEvent {
        case .approachingVehicle:
            return "Traffic Sound Detected"
        case .bicycleOrScooter:
            return "Bicycle Bell Detected"
        case .horn:
            return "Car Horn Detected"
        case .siren:
            return "Siren Detected"
        case .nearbyPersonMovement:
            return "Movement Detected"
        case .generalLoudSound:
            return "Loud Sound Detected"
        default:
            !event.rawIdentifier.isEmpty ? event.rawIdentifier : "Unknown Sound"
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
    DetectionAlertView(
        event: DetectionEvent(
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
        ),
        isHapticAlertEnabled: true,
        isAudioAlertEnabled: true,
        toggleHapticAlert: {},
        toggleAudioAlert: {}
    )
    .padding()
    .background(AppColors.backgroundPrimary)
}

#Preview("Medium") {
    DetectionAlertView(
        event: DetectionEvent(
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
        ),
        isHapticAlertEnabled: true,
        isAudioAlertEnabled: false,
        toggleHapticAlert: {},
        toggleAudioAlert: {}
    )
    .padding()
    .background(AppColors.backgroundPrimary)
}

#Preview("Critical") {
    DetectionAlertView(
        event: DetectionEvent(
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
        ),
        isHapticAlertEnabled: false,
        isAudioAlertEnabled: true,
        toggleHapticAlert: {},
        toggleAudioAlert: {}
    )
    .padding()
    .background(AppColors.backgroundPrimary)
}
