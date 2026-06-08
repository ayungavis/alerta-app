import SwiftUI

struct AppButton: View {
    enum Style {
        case `default`
        case destructive
    }

    let title: String
    let systemImage: String
    let style: Style
    let action: () -> Void

    init(
        _ title: String,
        systemImage: String,
        style: Style,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.style = style
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Stack(
                direction: .horizontal,
                justify: .center,
                align: .center,
                spacing: 8,
                width: .fill,
                height: .fixed(56)
            ) {
                Image(systemName: systemImage)
                    .font(.system(size: 17, weight: .semibold))
                Text(title)
                    .font(AppFont.soraSemiBold(17))
            }
            .foregroundStyle(AppColors.buttonText)
            .background(style == .default ? AppColors.buttonDefault : AppColors.buttonDestructive)
            .clipShape(Capsule())
        }
    }
}

#Preview("Default") {
    AppButton("Start", systemImage: "play.fill", style: .default) {}
        .padding()
}

#Preview("Destructive") {
    AppButton("Stop", systemImage: "stop.fill", style: .destructive) {}
        .padding()
}
