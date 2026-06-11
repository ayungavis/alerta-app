//
//  DisclaimerContentView.swift
//  AlertaApp
//
//  Created by Wahyu Kurniawan on 10/06/26.
//

import SwiftUI

struct DisclaimerContentView: View {
    var body: some View {
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
                        "This app provides assistive awareness cues based on detected environmental sounds."
                            + "Detection accuracy may vary depending on surrounding conditions, device limitations, and other factors."
                            + "\n\nAlerts may be delayed, incorrect, incomplete, or missed entirely."
                            + "This app does not guarantee the detection of all sounds and should not be relied upon as a "
                            + "substitute for your attention, judgment, hearing, or safe road practices."
                            + "\n\nAlways stay aware of your surroundings and make safety decisions independently."
                            + "By continuing, you acknowledge that this app is intended as an awareness support "
                            + "tool only and does not provide guaranteed safety or protection."
                    )
                    .soraFont(size: 17, weight: .regular)
                    .frame(width: 322)
                    .foregroundColor(AppColors.textSecondary)
                }
            }

            Spacer()
        }
    }
}
