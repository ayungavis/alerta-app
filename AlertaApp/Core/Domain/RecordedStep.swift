import Foundation

struct RecordedStep: Identifiable, Codable, Hashable {
    var id: UUID = .init()
    var duration: TimeInterval
    var waitTime: TimeInterval
}
