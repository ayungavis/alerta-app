import Combine
import Foundation

protocol AudioMonitoringProviding: AnyObject {
    var isRunning: Bool { get }
    var detectionPublisher: AnyPublisher<DetectionEvent, Never> { get }
    func start() throws
    func stop()
}
