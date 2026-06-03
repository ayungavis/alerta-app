import SwiftUI

struct AppFont {
    static func sora(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        // Panggil nama dasar font, lalu biarkan iOS mengatur ketebalannya
        // Jika "Sora" tidak terbaca, coba ganti menjadi "Sora-Regular"
        return Font.custom("Sora", size: size).weight(weight)
    }
}

extension View {
    func soraFont(size: CGFloat, weight: Font.Weight = .regular) -> some View {
        self.font(AppFont.sora(size, weight: weight))
    }
}