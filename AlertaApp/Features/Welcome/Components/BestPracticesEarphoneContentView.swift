//
//  BestPracticesEarphoneContentView.swift
//  AlertaApp
//
//  Created by Wahyu Kurniawan on 10/06/26.
//

import SwiftUI

struct BestPracticesEarphoneContentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Best Practices")
                .soraFont(size: 34, weight: .bold)
                .foregroundColor(.white)
                .padding(.horizontal, 22)
                .padding(.bottom, 16)

            Text("Use earphones for the best experience")
                .soraFont(size: 20, weight: .semiBold)
                .padding(.leading, 24)

            LoopingVideoPlayer(videoName: "earphoneIllustration", videoExt: "mp4")
                .frame(width: 357, height: 188)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
            Text(
                "For the best experience, connect your headphones before starting a session. "
                    + "This allows Alerta to deliver audio cues that help you stay informed "
                    + "about important sounds detected around you."
            )
            .soraFont(size: 17, weight: .regular)
            .padding(.horizontal, 24)
            .foregroundColor(AppColors.textSecondary)
            .padding(.bottom, 24)
        }
    }
}
