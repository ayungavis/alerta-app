import Foundation

struct RecordedStep: Identifiable {
    let id = UUID()
    let duration: TimeInterval
    let waitTime: TimeInterval
}
