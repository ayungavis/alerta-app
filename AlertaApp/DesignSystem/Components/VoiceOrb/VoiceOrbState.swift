import SwiftUI

enum VoiceOrbState: String, CaseIterable, Identifiable {
    case idle
    case connecting
    case listening
    case speaking
    case muted

    var id: String {
        rawValue
    }

    var label: String {
        switch self {
        case .idle: "Idle"
        case .connecting: "Connecting"
        case .listening: "Listening"
        case .speaking: "Speaking"
        case .muted: "Muted"
        }
    }
}

enum VoiceOrbVariant: String, CaseIterable, Identifiable {
    case `default`
    case blue
    case violet
    case emerald

    var id: String {
        rawValue
    }

    var label: String {
        switch self {
        case .default: "Default"
        case .blue: "Blue"
        case .violet: "Violet"
        case .emerald: "Emerald"
        }
    }
}

struct OrbParams {
    var speed: Float
    var amplitude: Float
    var glow: Float
    var brightness: Float
    var pulse: Float
    var saturation: Float

    static let stateMap: [VoiceOrbState: OrbParams] = [
        .idle: OrbParams(speed: 0.15, amplitude: 0.04, glow: 0.15, brightness: 0.55, pulse: 0.0, saturation: 0.7),
        .connecting: OrbParams(speed: 0.5, amplitude: 0.1, glow: 0.45, brightness: 0.75, pulse: 1.0, saturation: 0.9),
        .listening: OrbParams(speed: 0.4, amplitude: 0.14, glow: 0.5, brightness: 0.85, pulse: 0.0, saturation: 1.0),
        .speaking: OrbParams(speed: 1.4, amplitude: 0.35, glow: 0.9, brightness: 1.0, pulse: 0.0, saturation: 1.0),
        .muted: OrbParams(speed: 0.06, amplitude: 0.015, glow: 0.08, brightness: 0.35, pulse: 0.0, saturation: 0.2)
    ]
}

struct VariantColors {
    let color0: (Float, Float, Float)
    let color1: (Float, Float, Float)
    let color2: (Float, Float, Float)

    static let map: [VoiceOrbVariant: VariantColors] = [
        .default: VariantColors(
            color0: (0.55, 0.55, 0.6),
            color1: (0.7, 0.7, 0.75),
            color2: (0.4, 0.4, 0.45)
        ),
        .blue: VariantColors(
            color0: (0.2, 0.5, 1.0),
            color1: (0.4, 0.7, 1.0),
            color2: (0.1, 0.3, 0.8)
        ),
        .violet: VariantColors(
            color0: (0.6, 0.3, 1.0),
            color1: (0.8, 0.5, 1.0),
            color2: (0.4, 0.15, 0.8)
        ),
        .emerald: VariantColors(
            color0: (0.15, 0.75, 0.55),
            color1: (0.3, 0.9, 0.7),
            color2: (0.1, 0.55, 0.4)
        )
    ]

    static func primary(for colorScheme: ColorScheme) -> VariantColors {
        switch colorScheme {
        case .light:
            VariantColors(
                color0: hexToRGB("005562"),
                color1: hexToRGB("00CCD9"),
                color2: hexToRGB("FF8B43")
            )
        case .dark:
            VariantColors(
                color0: hexToRGB("005562"),
                color1: hexToRGB("00F0FF"),
                color2: hexToRGB("FF8B43")
            )
        @unknown default:
            VariantColors(
                color0: hexToRGB("005562"),
                color1: hexToRGB("00CCD9"),
                color2: hexToRGB("FF8B43")
            )
        }
    }
}

private func hexToRGB(_ hex: String) -> (Float, Float, Float) {
    let scanner = Scanner(string: hex)
    var value: UInt64 = 0
    scanner.scanHexInt64(&value)
    return (
        Float((value >> 16) & 0xFF) / 255.0,
        Float((value >> 8) & 0xFF) / 255.0,
        Float(value & 0xFF) / 255.0
    )
}
