import SwiftUI

struct CueBadgeView: View {
    let icon: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .stroke(AppColors.surfaceElevated, lineWidth: 4)
                    .frame(width: 46, height: 46)

                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(AppColors.secondary)
            }

            Text(label)
                .font(AppFont.soraRegular(13))
                .foregroundStyle(AppColors.secondary)
        }
    }
}

#Preview {
    HStack(spacing: 6) {
        CueBadgeView(icon: "iphone.radiowaves.left.and.right", label: "Haptics")
        CueBadgeView(icon: "speaker.wave.2", label: "Sound")
    }
    .padding()
    .background(AppColors.backgroundPrimary)
}
