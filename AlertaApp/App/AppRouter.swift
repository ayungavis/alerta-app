import Observation

@Observable
final class AppRouter {
    var hasEnteredMainApp = false

    func enterMainApp() {
        hasEnteredMainApp = true
    }
}
