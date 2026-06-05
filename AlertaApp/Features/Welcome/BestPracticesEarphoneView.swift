//
//  BestPracticesEarphoneView.swift
//  AlertaApp
//
//  Created by Kyky on 05/06/26.
//

import SwiftUI

struct BestPracticesEarphoneView: View {
    var body: some View {
        ZStack {
            AppColors.backgroundPrimary.ignoresSafeArea()

            Circle()
                .fill(Color("primary").opacity(0.2))
                .frame(width: 320, height: 320)
                .blur(radius: 60)
                .offset(x: -136, y: -200)

            Circle()
                .fill(Color("primaryDark").opacity(0.5))
                .frame(width: 256, height: 256)
                .blur(radius: 50)
                .opacity(0.2)
                .offset(x: 100, y: UIScreen.main.bounds.height / 2 - 150)

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
                    "For the best experience, connect your headphones before starting a session. This allows Alerta to deliver audio cues that help you stay informed about important sounds detected around you."
                )
                .soraFont(size: 17, weight: .regular)
                .padding(.horizontal, 24)
                .foregroundColor(AppColors.textSecondary)
                .padding(.bottom, 24)

                NavigationLink {
                    BestPracticesPhoneView()
                } label: {
                    Text("Next")
                        .soraFont(size: 17, weight: .semiBold)
                        .foregroundStyle(Color("buttonText"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color("buttonDefault"))
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)

                Spacer()
            }
        }
    }
}

#Preview {
    BestPracticesEarphoneView()
}
