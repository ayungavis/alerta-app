//
//  BestPracticesPhoneView.swift
//  AlertaApp
//
//  Created by Kyky on 05/06/26.
//

import SwiftUI

struct BestPracticesPhoneView: View {
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

                Text("Recommended Phone Placement While Running")
                    .soraFont(size: 20, weight: .semiBold)
                    .padding(.leading, 24)

                // No. 1
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("1. Hold Your Phone (Recommended)")
                            .soraFont(size: 17, weight: .semiBold)
                            .padding(.leading, 24)
                            .padding(.top, 16)

                        Text("Best Detection Accuracy")
                            .soraFont(size: 16, weight: .regular)
                            .foregroundStyle(AppColors.textSecondary)
                            .padding(.leading, 24)
                            .padding(.vertical, 8)

                        Image("phonePlacement1")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 347, height: 183)
                            .cornerRadius(16)
                            .padding(.horizontal, 16)
                            .padding(.leading, 8)
                        // swiftlint:disable:next line_length
                        Text(
                            "Holding your phone provides the clearest access to surrounding sounds and helps " + "Alerta detect important events more reliably. This is the recommended option for the most consistent awareness support."
                        )
                        .soraFont(size: 13, weight: .regular)
                        .padding(.horizontal, 24)
                        .foregroundColor(AppColors.textSecondary)
                        .padding(.vertical, 8)

                        // No.2

                        Text("2. Use a Shoulder Strap")
                            .soraFont(size: 17, weight: .semiBold)
                            .padding(.leading, 24)
                            .padding(.top, 16)

                        Text("Good Detection Accuracy")
                            .soraFont(size: 16, weight: .regular)
                            .foregroundStyle(AppColors.textSecondary)
                            .padding(.leading, 24)
                            .padding(.vertical, 8)

                        Image("phonePlacement3")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 347, height: 183)
                            .cornerRadius(16)
                            .padding(.horizontal, 16)
                            .padding(.leading, 8)
                        // swiftlint:disable:next line_length
                        Text(
                            "Wearing your phone on a shoulder strap keeps it accessible while allowing the microphone to remain relatively unobstructed. " +
                                "This option offers a good balance between comfort and detection performance."
                        )
                        .soraFont(size: 13, weight: .regular)
                        .padding(.horizontal, 24)
                        .foregroundColor(AppColors.textSecondary)
                        .padding(.vertical, 8)

                        // No.3

                        Text("3. Carry It in Your Pocket")
                            .soraFont(size: 17, weight: .semiBold)
                            .padding(.leading, 24)
                            .padding(.top, 16)

                        Text("Basic Detection Accuracy")
                            .soraFont(size: 16, weight: .regular)
                            .foregroundStyle(AppColors.textSecondary)
                            .padding(.leading, 24)
                            .padding(.vertical, 8)

                        Image("phonePlacement2")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 347, height: 183)
                            .cornerRadius(16)
                            .padding(.horizontal, 16)
                            .padding(.leading, 8)
                        // swiftlint:disable:next line_length
                        Text(
                            "Keeping your phone in a pocket is convenient, but clothing and body movement may reduce microphone performance. "
                            "Alerts will still work, though some sounds may be detected less consistently."
                        )
                        .soraFont(size: 13, weight: .regular)
                        .padding(.horizontal, 24)
                        .foregroundColor(AppColors.textSecondary)
                        .padding(.vertical, 8)
                    }
                }

                NavigationLink {
                    AwarenessView()
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
    BestPracticesPhoneView()
}
