//
//  AppFont.swift
//  AlertaApp
//
//  Created by Kyky on 03/06/26.
//

import SwiftUI

enum AppFont {
    static func sora(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        Font.custom("Sora", size: size).weight(weight)
    }

    static func soraBold(_ size: CGFloat) -> Font {
        sora(size, weight: .bold)
    }

    static func soraSemiBold(_ size: CGFloat) -> Font {
        sora(size, weight: .semibold)
    }

    static func soraRegular(_ size: CGFloat) -> Font {
        sora(size, weight: .regular)
    }
}

extension View {
    func soraFont(size: CGFloat, weight: Font.Weight = .regular) -> some View {
        font(AppFont.sora(size, weight: weight))
    }
}
