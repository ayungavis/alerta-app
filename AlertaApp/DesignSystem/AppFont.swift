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

enum AppTextStyle {
    case largeTitle // 34/42
    case title1 // 28/36
    case title2 // 22/30
    case title3 // 20/28
    case headline // 17/24
    case body // 17/24
    case callout // 16/23
    case subheadline // 15/22
    case footnote // 13/18
    case caption1 // 12/16
    case caption2 // 11/14

    var size: CGFloat {
        switch self {
        case .largeTitle: 34
        case .title1: 28
        case .title2: 22
        case .title3: 20
        case .headline: 17
        case .body: 17
        case .callout: 16
        case .subheadline: 15
        case .footnote: 13
        case .caption1: 12
        case .caption2: 11
        }
    }

    var lineHeight: CGFloat {
        switch self {
        case .largeTitle: 42
        case .title1: 36
        case .title2: 30
        case .title3: 28
        case .headline: 24
        case .body: 24
        case .callout: 23
        case .subheadline: 22
        case .footnote: 18
        case .caption1: 16
        case .caption2: 14
        }
    }

    var regularWeight: SoraWeight {
        switch self {
        case .largeTitle, .title1, .headline: .semiBold
        case .title2, .title3, .body, .callout,
             .subheadline, .footnote, .caption1, .caption2:
            .regular
        }
    }

    var emphasizedWeight: SoraWeight {
        switch self {
        case .largeTitle, .title1, .headline: .bold
        case .title2, .title3, .body, .callout,
             .subheadline, .footnote, .caption1, .caption2:
            .semiBold
        }
    }

    var lineSpacing: CGFloat {
        lineHeight - size
    }
}

struct SoraTextModifier: ViewModifier {
    let style: AppTextStyle
    let emphasized: Bool
    let color: Color

    private var resolvedWeight: SoraWeight {
        emphasized ? style.emphasizedWeight : style.regularWeight
    }

    func body(content: Content) -> some View {
        content
            .font(AppFont.sora(style.size, weight: resolvedWeight))
            .lineSpacing(style.lineSpacing)
            .foregroundStyle(color)
    }
}

enum AppFont {
    static func sora(
        _ size: CGFloat,
        weight: SoraWeight = .regular,
        color: Color = .primary
    ) -> Font {
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
    func soraFont(
        size: CGFloat,
        weight: SoraWeight = .regular,
        color: Color = .primary
    ) -> some View {
        font(AppFont.sora(size, weight: weight, color: color))
    }

    func soraFont(
        _ style: AppTextStyle,
        emphasized: Bool = false,
        color: Color = .primary
    ) -> some View {
        modifier(
            SoraTextModifier(style: style, emphasized: emphasized, color: color)
        )
    }
}
