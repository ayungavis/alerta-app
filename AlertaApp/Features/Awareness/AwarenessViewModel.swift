import Combine
import Foundation
import Observation

@Observable
@MainActor
final class AwarenessViewModel {
    private(set) var isRunning: Bool = false
    private(set) var latestEvent: DetectionEvent?
    private(set) var statusMessage: String = "Ready"
    private(set) var rawDetectedSound: String = "No sound detected yet"
    
    private let monitoringService: any AudioMonitoringProviding
    private let permissionProvider: any MicrophonePermissionProviding
    private let feedbackService: CueFeedbackService
    private var cancellables = Set<AnyCancellable>()
    
    init(
        monitoringService: any AudioMonitoringProviding,
        permissionProvider: any MicrophonePermissionProviding,
        feedbackService: CueFeedbackService
    ) {
        self.monitoringService = monitoringService
        self.permissionProvider = permissionProvider
        self.feedbackService = feedbackService
    }
    
    func start() async {
        let hasPermission = await permissionProvider.requestPermission()
        
        guard hasPermission else {
            statusMessage = "Microphone permission is required."
            return
        }
        
        do {
            try AudioSessionConfigurator().configureSession()
            try monitoringService.start()
            
            monitoringService.detectionPublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] event in
                    self?.latestEvent = event
                    self?.rawDetectedSound = event.rawIdentifier
                    self?.feedbackService.playHapticCue(for: event)
                }
                .store(in: &cancellables)
            
            isRunning = true
            statusMessage = "Listening"
        } catch {
            statusMessage = "Unable to start awareness session."
        }
    }
    
    func stop() {
        cancellables.removeAll()
        monitoringService.stop()
        isRunning = false
        statusMessage = "Stopped"
    }
}
