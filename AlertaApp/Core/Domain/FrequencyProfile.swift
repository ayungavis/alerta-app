import Foundation

struct FrequencyProfile: Equatable {
    let baseline: FrequencySpectrum
    let capturedAt: Date

    init(baseline: FrequencySpectrum, capturedAt: Date = Date()) {
        self.baseline = baseline
        self.capturedAt = capturedAt
    }
}
