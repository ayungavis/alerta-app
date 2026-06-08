import SwiftUI

enum SoraWeight {
    case thin
    case extraLight
    case light
    case regular
    case medium
    case semiBold
    case bold
    case extraBold

    var fontName: String {
        switch self {
        case .thin: "Sora-Regular_Thin"
        case .extraLight: "Sora-Regular_ExtraLight"
        case .light: "Sora-Regular_Light"
        case .regular: "Sora-Regular"
        case .medium: "Sora-Regular_Medium"
        case .semiBold: "Sora-Regular_SemiBold"
        case .bold: "Sora-Regular_Bold"
        case .extraBold: "Sora-Regular_ExtraBold"
        }
    }
}

enum AppFont {
    static func sora(_ size: CGFloat, weight: SoraWeight = .regular) -> Font {
        Font.custom(weight.fontName, size: size)
    }

    static func soraBold(_ size: CGFloat) -> Font {
        sora(size, weight: .bold)
    }

    static func soraSemiBold(_ size: CGFloat) -> Font {
        sora(size, weight: .semiBold)
    }

    static func soraRegular(_ size: CGFloat) -> Font {
        sora(size, weight: .regular)
    }
}

extension View {
    func soraFont(size: CGFloat, weight: SoraWeight = .regular) -> some View {
        font(AppFont.sora(size, weight: weight))
    }
}
