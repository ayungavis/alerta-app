import Combine
import CoreMotion
import Foundation

final class HeadphoneMotionProvider {
    private let motionManager = CMHeadphoneMotionManager()
    private let yawSubject = PassthroughSubject<Double, Never>()

    var yawPublisher: AnyPublisher<Double, Never> {
        yawSubject.eraseToAnyPublisher()
    }

    var isAvailable: Bool {
        motionManager.isDeviceMotionAvailable
    }

    func start() {
        guard isAvailable else { return }

        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
            guard let self, let motion else { return }
            yawSubject.send(motion.attitude.yaw)
        }
    }

    func stop() {
        motionManager.stopDeviceMotionUpdates()
        yawSubject.send(completion: .finished)
    }

    deinit {
        stop()
    }
}
