enum AppError: Error, Equatable {
    case unavailableFeature(name: String)

    var message: String {
        switch self {
        case let .unavailableFeature(name):
            "\(name) is not available in this build."
        }
    }
}
