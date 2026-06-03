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
}

extension View {
    func soraFont(size: CGFloat, weight: Font.Weight = .regular) -> some View {
        font(AppFont.sora(size, weight: weight))
    }
}
