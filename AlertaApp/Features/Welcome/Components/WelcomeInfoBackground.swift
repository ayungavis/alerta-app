//
//  WelcomeInfoBackground.swift
//  AlertaApp
//
//  Created by Wahyu Kurniawan on 10/06/26.
//

import SwiftUI

struct WelcomeInfoBackground<Content: View>: View {
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            AppColors.backgroundPrimary.ignoresSafeArea()

            Circle()
                .fill(AppColors.primary.opacity(0.2))
                .frame(width: 320, height: 320)
                .blur(radius: 60)
                .offset(x: -136, y: -200)

            Circle()
                .fill(AppColors.primaryDark.opacity(0.5))
                .frame(width: 256, height: 256)
                .blur(radius: 50)
                .opacity(0.2)
                .offset(x: 100, y: UIScreen.main.bounds.height / 2 - 150)

            content
        }
    }
}
