//
//  DisclaimerView.swift
//  AlertaApp
//
//  Created by Kyky on 05/06/26.
//

import SwiftUI

struct DisclaimerView: View {
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
                Text("Disclaimer")
                    .soraFont(size: 34, weight: .bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)

                ZStack {
                    Rectangle()
                        .fill(AppColors.surfacePrimary)
                        .cornerRadius(16)
                        .padding(.horizontal, 24)
                        .frame(height: 572)

                    VStack {
                        HStack {
                            Text("Stop & Read This.")
                                .soraFont(size: 20, weight: .semiBold)
                                .padding(.leading, 40)
                                .padding(.bottom, 8)
                            Spacer()
                        }
                        // swiftlint:disable:next line_length
                        Text(
                            "This app provides assistive awareness cues based on detected environmental sounds." +
                                "Detection accuracy may vary depending on surrounding conditions, device limitations, and other factors." +
                                "\n\nAlerts may be delayed, incorrect, incomplete, or missed entirely." +
                                "This app does not guarantee the detection of all sounds and should not be relied upon as a substitute for your attention, judgment, hearing, or safe road practices." +
                                "\n\nAlways stay aware of your surroundings and make safety decisions independently." +
                                "By continuing, you acknowledge that this app is intended as an awareness support tool only and does not provide guaranteed safety or protection."
                        )
                        .soraFont(size: 17, weight: .regular)
                        .frame(width: 322)
                        .foregroundColor(AppColors.textSecondary)
                    }
                }

                Spacer()

                NavigationLink {
                    BestPracticesEarphoneView()
                } label: {
                    Text("I Understand")
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
    DisclaimerView()
}
