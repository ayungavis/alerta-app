//
//  DisclaimerView.swift
//  AlertaApp
//
//  Created by Kyky on 05/06/26.
//

import SwiftUI

struct DisclaimerView: View {
    var body: some View {
        WelcomeInfoBackground {
            VStack(alignment: .leading, spacing: 0) {
                DisclaimerContentView()

                Spacer()

                NavigationLink {
                    BestPracticesEarphoneView()
                } label: {
                    Text("I Understand")
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
            .ignoresSafeArea(.container, edges: .bottom)
        }
    }
}

#Preview {
    DisclaimerView()
}
