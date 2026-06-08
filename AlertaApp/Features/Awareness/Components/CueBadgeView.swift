import SwiftUI

struct CueBadgeView: View {
    enum Style {
        case labeled
        case compact
    }

    let icon: String
    let label: String
    let style: Style
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
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
        .buttonStyle(.plain)
        .accessibilityLabel(label)
        .accessibilityValue(isActive ? "Enabled" : "Disabled")
    }

    private var cueIcon: some View {
        ZStack {
            Circle()
                .fill(isActive ? AppColors.surfaceElevated : .clear)
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
        isActive ? AppColors.secondary : AppColors.primaryDark
    }
}

#Preview {
    HStack(spacing: 6) {
        CueBadgeView(
            icon: "iphone.radiowaves.left.and.right",
            label: "Haptics",
            style: .labeled,
            isActive: true,
            action: {}
        )
        CueBadgeView(
            icon: "airpods.max",
            label: "Sound",
            style: .labeled,
            isActive: false,
            action: {}
        )
    }
    .padding()
    .background(AppColors.backgroundPrimary)
}
