//
//  AppSymbols.swift
//  AlertaApp
//
//  Created by Dimas Nugraha on 07/06/26.
//
import SwiftUI

enum AppSymbol: String {
    case critical = "exclamationmark.shield.fill"
    case high = "exclamationmark.triangle.fill"
    case medium = "exclamationmark.square.fill"
    case low = "exclamationmark.circle.fill"
    case record = "record.circle"

    // event symbols
    case car = "car.fill"
    case bicycle
    case siren = "light.beacon.max.fill"
    case horn = "horn.blast.fill"
    case vehicles = "car.2"
    case bicycleBell = "event.bicycle.bell"
    case carhorn = "event.car.horn"
    case traffic = "event.traffic"
    case nearbyPerson = "figure.walk"
    case unknown = "speaker.wave.2"

    var defaultColor: Color {
        switch self {
        case .critical: AppColors.alertCritical
        case .high: AppColors.alertHigh
        case .medium: AppColors.alertMedium
        case .low: AppColors.alertLow
        case .record: AppColors.ButtonDestructive.default
        // symbols
        case .car: AppColors.alertHigh
        case .bicycle: AppColors.alertLow
        case .siren: AppColors.alertCritical
        case .horn: AppColors.alertHigh
        case .vehicles: AppColors.alertHigh
        case .bicycleBell: AppColors.alertMedium
        case .carhorn: AppColors.alertHigh
        case .traffic: AppColors.alertLow
        case .nearbyPerson: AppColors.alertLow
        case .unknown: AppColors.alertLow
        }
    }
}

extension Image {
    /// Image(.critical)
    init(_ symbol: AppSymbol) {
        self.init(systemName: symbol.rawValue)
    }
}

/// SymbolImage(.critical)                  — uses default color
/// SymbolImage(.critical, color: .purple)  — override color
/// SymbolImage(.critical, size: 24)
struct AppSymbols: View {
    let symbol: AppSymbol
    var color: Color?
    var size: CGFloat?

    init(_ symbol: AppSymbol, color: Color? = nil, size: CGFloat? = nil) {
        self.symbol = symbol
        self.color = color
        self.size = size
    }

    var body: some View {
        Image(systemName: symbol.rawValue)
            .font(size.map { .system(size: $0) } ?? .body)
            .foregroundStyle(color ?? symbol.defaultColor)
    }
}
