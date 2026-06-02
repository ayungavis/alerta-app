import Foundation

struct FrequencySpectrum: Equatable {
    let bands: [FrequencyBand]
    let dominantFrequency: Float
    let spectralCentroid: Float

    static let zero = FrequencySpectrum(
        bands: FrequencyBand.defaultBands.map { FrequencyBand(name: $0.name, range: $0.range, energy: 0) },
        dominantFrequency: 0,
        spectralCentroid: 0
    )
}

struct FrequencyBand: Equatable {
    let name: String
    let range: ClosedRange<Float>
    var energy: Float

    var label: String {
        switch name {
        case "Sub-bass": "SB"
        case "Bass": "B"
        case "Low-mid": "LM"
        case "Mid": "M"
        case "High-mid": "HM"
        case "High": "H"
        default: String(name.prefix(2))
        }
    }

    var normalizedEnergy: Float {
        let max: Float = 0.05
        return min(energy / max, 1.0)
    }

    static let defaultBands: [(name: String, range: ClosedRange<Float>)] = [
        ("Sub-bass", 20 ... 60),
        ("Bass", 60 ... 250),
        ("Low-mid", 250 ... 500),
        ("Mid", 500 ... 2000),
        ("High-mid", 2000 ... 4000),
        ("High", 4000 ... 8000)
    ]
}
