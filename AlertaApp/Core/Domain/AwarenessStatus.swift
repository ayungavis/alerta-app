enum AwarenessStatus: Equatable {
    case notStarted
    case ready
    case listening
    case unavailable(reason: String)

    var title: String {
        switch self {
        case .notStarted:
            "Ready to set up"
        case .ready:
            "Ready"
        case .listening:
            "Listening"
        case .unavailable:
            "Unavailable"
        }
    }

    var description: String {
        switch self {
        case .notStarted:
            "Connect future audio services before starting a real session."
        case .ready:
            "The awareness session can start when services are connected."
        case .listening:
            "Alerta is monitoring nearby sound events."
        case let .unavailable(reason):
            reason
        }
    }
}
