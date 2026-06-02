import AVFoundation

struct SystemMicrophonePermissionProvider: MicrophonePermissionProviding {
    func requestPermission() async -> Bool {
        await AVAudioApplication.requestRecordPermission()
    }

    var permissionGranted: Bool {
        let session = AVAudioSession.sharedInstance()
        return session.recordPermission == .granted
    }
}
