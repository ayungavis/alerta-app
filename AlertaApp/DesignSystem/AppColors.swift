import SwiftUI

enum AppColors {
    static let backgroundPrimary: Color = .init(.backgroundPrimary)
    static let backgroundSecondary: Color = .init(.backgroundSecondary)
    static let primary: Color = .init(.primary)
    static let secondary: Color = .init(.secondary)
    static let tertiary: Color = .init(.tertiary)
    static let surfacePrimary: Color = .init(.surfacePrimary)
    static let surfaceElevated: Color = .init(.surfaceElevated)
    static let textPrimary: Color = .init(.textPrimary)
    static let textSecondary: Color = .init(.textSecondary)
    static let textTretiary: Color = .init(.textTertiary)
    static let accent: Color = .init(.accent)
    static let systemError: Color = .init(.systemError)
    static let systemSuccess: Color = .init(.systemSuccess)
    static let alertCritical: Color = .init(.alertCritical)
    static let alertHigh: Color = .init(.alertMedium)
    static let alertMedium: Color = .init(.alertLow)
    static let alertLow: Color = .init(.alertInfo)
    ///    static let primary = Color(red: 0, green: 240, blue: 255)
    static let card = Color(red: 0.13, green: 0.13, blue: 0.13)

    enum ButtonPrimary {
        static let `default`: Color = .init(.buttonPrimaryDefault)
        static let pressed: Color = .init(.buttonPrimaryPressed)
        static let disabled: Color = .init(.buttonPrimaryDisabled)
        static let text: Color = .init(.buttonPrimaryText)
    }
    //
    //    enum ButtonSecondary {
    //        static let `default`: Color = .init(.buttonSecondaryDefault)
    //        static let pressed: Color   = .init(.buttonSecondaryPressed)
    //        static let disabled: Color  = .init(.buttonSecondaryDisabled)
    //    }
    //
        enum ButtonDestructive {
            static let `default`: Color = .init(.buttonDestructiveDefault)
            static let pressed: Color   = .init(.buttonDestructivePressed)
            static let disabled: Color  = .init(.buttonDestructiveDisabled)
        }
}
