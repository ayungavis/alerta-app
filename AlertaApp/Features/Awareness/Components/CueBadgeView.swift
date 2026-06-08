import SwiftUI

struct CueBadgeView: View {
    enum Style {
        case labeled
        case compact
    }

    let icon: String
    let label: String
    let style: Style

    var body: some View {
        switch style {
        case .labeled:
            VStack(spacing: 4) {
                cueIcon

                Text(label)
                    .font(AppFont.soraRegular(13))
                    .foregroundStyle(AppColors.secondary)
                    .tracking(-0.08)
            }
            .frame(width: 82, height: 76)
        case .compact:
            cueIcon
        }
    }

    private var cueIcon: some View {
        ZStack {
            Circle()
                .fill(style == .labeled ? AppColors.surfaceElevated : .clear)
                .overlay {
                    Circle()
                        .stroke(AppColors.surfaceElevated, lineWidth: 4)
                }
                .frame(width: 46, height: 46)

            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(iconColor)
        }
    }

    private var iconColor: Color {
        switch label {
        case "Haptics":
            AppColors.secondary
        default:
            AppColors.primaryDark
        }
    }
}

#Preview {
    HStack(spacing: 6) {
        CueBadgeView(icon: "iphone.radiowaves.left.and.right", label: "Haptics", style: .labeled)
        CueBadgeView(icon: "airpods.max", label: "Sound", style: .labeled)
    }
    .padding()
    .background(AppColors.backgroundPrimary)
}
