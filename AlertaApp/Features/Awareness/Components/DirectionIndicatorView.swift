import SwiftUI

struct DirectionIndicatorView: View {
    let direction: SoundDirection

    private let size: CGFloat = 56

    private var positions: [(SoundDirection, Double)] {
        [
            (.frontLeft, -45),
            (.frontRight, 45),
            (.backLeft, -135),
            (.backRight, 135),
            (.left, -90),
            (.right, 90),
        ]
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color("primaryDark").opacity(0.3), lineWidth: 1.5)
                .frame(width: size, height: size)

            ForEach(positions, id: \.0.rawValue) { dir, angle in
                tick(isActive: dir == direction, angle: angle)
            }

            Circle()
                .fill(direction == .nearby || direction == .unknown
                    ? Color("primary")
                    : Color("primaryDark").opacity(0.4))
                .frame(width: 8, height: 8)
        }
        .frame(width: size, height: size)
    }

    private func tick(isActive: Bool, angle: Double) -> some View {
        Image(systemName: "arrowtriangle.up.fill")
            .font(.system(size: isActive ? 9 : 6))
            .foregroundStyle(isActive ? Color("primary") : Color("primaryDark").opacity(0.3))
            .rotationEffect(.degrees(angle))
            .offset(
                x: size / 2 * 0.72 * sin(CGFloat(angle) * .pi / 180),
                y: -size / 2 * 0.72 * cos(CGFloat(angle) * .pi / 180)
            )
    }
}

#Preview("Left") {
    DirectionIndicatorView(direction: .left)
        .padding()
        .background(Color("backgroundPrimary"))
}

#Preview("Front Right") {
    DirectionIndicatorView(direction: .frontRight)
        .padding()
        .background(Color("backgroundPrimary"))
}

#Preview("Nearby") {
    DirectionIndicatorView(direction: .nearby)
        .padding()
        .background(Color("backgroundPrimary"))
}
