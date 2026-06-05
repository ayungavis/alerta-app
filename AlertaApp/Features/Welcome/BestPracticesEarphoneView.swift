//
//  BestPracticesView.swift
//  AlertaApp
//
//  Created by Kyky on 05/06/26.
//

import SwiftUI

struct BestPracticesView: View {
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
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
  
                Text("Use earphones for the best experience")
                    .soraFont(size: 20, weight: .semiBold)
                    .padding(.leading, 20)
                    .padding(.top, 16)
                
                
                LoopingVideoPlayer(videoName: "earphoneIllustration", videoExt: "mp4")
                    .frame(width: 357, height: 240)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal, 20)
                        
                Text("For the best experience, connect your headphones before starting a session. This allows Alerta to deliver audio cues that help you stay informed about important sounds detected around you.")
                    .soraFont(size: 17, weight: .regular)
                    .frame(width: 322)
                    .padding(.leading, 20)
                    .foregroundColor(AppColors.textSecondary)
                    .padding(.bottom, 24)
    
                
                NavigationLink {
                    BestPracticesView()
                } label: {
                    Text("Next")
                        .soraFont(size: 17, weight: .semiBold)
                        .foregroundStyle(Color("buttonText"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color("buttonDefault"))
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
                
                Spacer()
            }
        }
    }
}

#Preview {
    BestPracticesView()
}
