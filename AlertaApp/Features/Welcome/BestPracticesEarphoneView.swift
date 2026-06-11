//
//  BestPracticesEarphoneView.swift
//  AlertaApp
//
//  Created by Kyky on 05/06/26.
//

import SwiftUI

struct BestPracticesEarphoneView: View {
    var body: some View {
        NavigationStack {
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

                ZStack(alignment: .bottom) {
                    BestPracticesEarphoneContentView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

                    LinearGradient(
                        colors: [
                            AppColors.backgroundPrimary.opacity(0),
                            AppColors.backgroundPrimary,
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 200)
                    .allowsHitTesting(false)

                    NavigationLink {
                        BestPracticesPhoneView()
                    } label: {
                        Text("Next")
                            .soraFont(
                                .body,
                                emphasized: true,
                                color: AppColors.buttonText
                            )
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(AppColors.buttonDefault)
                            .clipShape(Capsule())
                    }
                    .padding(AppSpacing.large)
                    .padding(.bottom, 30)
                }
            }
            .ignoresSafeArea(.container, edges: .bottom)
        }
    }
}

#Preview {
    BestPracticesEarphoneView()
}
