import Combine
import Foundation

enum CalibrationState: Equatable {
    case notStarted
    case calibrating
    case complete(FrequencyProfile)
}

protocol AudioMonitoringProviding: AnyObject {
    var isRunning: Bool { get }
    var detectionPublisher: AnyPublisher<DetectionEvent, Never> { get }
    var calibrationPublisher: AnyPublisher<CalibrationState, Never> { get }
    func start() throws
    func stop()
}
