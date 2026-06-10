import SwiftUI

enum AppColors {
    static let primary = Color("primary")
    static let primaryDark = Color("primaryDark")
    static let secondary = Color("secondary")
    static let tertiary = Color("tertiary")
    static let accent = Color("accent")

    static let backgroundPrimary = Color("backgroundPrimary")
    static let backgroundSecondary = Color("backgroundSecondary")
    static let surfacePrimary = Color("surfacePrimary")
    static let surfaceElevated = Color("surfaceElevated")

    static let textPrimary = Color("textPrimary")
    static let textSecondary = Color("textSecondary")
    static let textTertiary = Color("textTertiary")
    static let textDisabled = Color("textDisabled")

    static let buttonDefault = Color("buttonDefault")
    static let buttonPressed = Color("buttonPressed")
    static let buttonDisabled = Color("buttonDisabled")
    static let buttonText = Color("buttonText")
    static let buttonDestructive = Color("buttonDestructive")

    static let alertCritical = Color("alertCritical")
    static let alertHigh = Color("alertMedium")
    static let alertMedium = Color("alertLow")
    static let alertLow = Color("alertInfo")

    static let systemSuccess = Color("systemSuccess")
    static let systemError = Color("systemError")

    static let background = backgroundPrimary
    static let surface = surfacePrimary
    static let cyan = primary
    static let card = surfaceElevated

    enum ButtonPrimary {
        static let `default`: Color = .init(.buttonPrimaryDefault)
        static let pressed: Color = .init(.buttonPrimaryPressed)
        static let disabled: Color = .init(.buttonPrimaryDisabled)
        static let text: Color = .init(.buttonPrimaryText)
    }

    ///
    ///    enum ButtonSecondary {
    ///        static let `default`: Color = .init(.buttonSecondaryDefault)
    ///        static let pressed: Color   = .init(.buttonSecondaryPressed)
    ///        static let disabled: Color  = .init(.buttonSecondaryDisabled)
    ///    }
    ///
    enum ButtonDestructive {
        static let `default`: Color = .init(.buttonDestructiveDefault)
        static let pressed: Color = .init(.buttonDestructivePressed)
        static let disabled: Color = .init(.buttonDestructiveDisabled)
    }
}
