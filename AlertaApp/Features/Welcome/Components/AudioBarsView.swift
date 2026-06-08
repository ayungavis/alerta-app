//
//  AudioBarsView.swift
//  AlertaApp
//
//  Created by Wahyu Kurniawan on 20/05/26.
//

import SwiftUI

struct AudioBarsView: View {
    private let bars: [(height: CGFloat, color: String)] = [
        (31, "primaryDark"),
        (61, "secondary"),
        (47, "primaryDark"),
        (77, "primary"),
        (39, "tertiary"),
        (31, "primaryDark"),
        (61, "secondary"),
        (47, "tertiary"),
        (31, "primaryDark"),
        (77, "primary"),
        (39, "secondary"),
        (31, "primaryDark")
    ]

    var body: some View {
        HStack(spacing: 7) {
            ForEach(0 ..< bars.count, id: \.self) { index in
                let bar = bars[index]
                Rectangle()
                    .fill(Color(bar.color))
                    .frame(width: 10, height: bar.height)
                    .clipShape(RoundedRectangle(cornerRadius: 9999))
                    .frame(height: 77, alignment: .bottom)
            }
        }
    }
}

#Preview {
    AudioBarsView()
        .padding()
        .background(AppColors.backgroundPrimary)
}
