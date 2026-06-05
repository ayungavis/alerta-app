//
//  WelcomeView.swift
//  AlertaApp
//
//  Created by Wahyu Kurniawan on 20/05/26.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack {
            Color("backgroundPrimary")
                .ignoresSafeArea()

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

            VStack(spacing: 0) {
                Spacer()

                Text("Welcome to")
                    .soraFont(size: 20, weight: .regular)
                    .foregroundStyle(Color("primary"))

                Text("ALERTA")
                    .soraFont(size: 64, weight: .bold)
                    .foregroundStyle(Color("primary"))
                    .padding(.top, 41)

                AudioBarsView()
                    .padding(.top, 71)

                Text("Stay alert. Stay safe.")
                    .soraFont(size: 22, weight: .semiBold)
                    .foregroundStyle(Color("primary"))
                    .padding(.top, 71)

                Text(
                    "We detect important environmental sounds and instantly notify you about potential danger nearby."
                )
                .soraFont(size: 17, weight: .regular)
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .frame(width: 320)
                .padding(.top, 18)

                Spacer()

                NavigationLink {
                    DisclaimerView()
                } label: {
                    Text("Let\u{2019}s Rock!")
                        .soraFont(size: 17, weight: .semiBold)
                        .foregroundStyle(Color("buttonText"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color("buttonDefault"))
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack {
        WelcomeView()
    }
}
