//
//  BestPracticesEarphoneView.swift
//  AlertaApp
//
//  Created by Kyky on 05/06/26.
//

import SwiftUI

struct BestPracticesEarphoneView: View {
    var body: some View {
        WelcomeInfoBackground {
            VStack(alignment: .leading, spacing: 0) {
                BestPracticesEarphoneContentView()

                NavigationLink {
                    BestPracticesPhoneView()
                } label: {
                    Text("Next")
                        .soraFont(size: 17, weight: .semiBold)
                        .foregroundStyle(AppColors.buttonText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(AppColors.buttonDefault)
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
