import AVFoundation
import Foundation

protocol MicrophonePermissionProviding {
    func requestPermission() async -> Bool
    var permissionGranted: Bool { get }
}
