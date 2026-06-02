import AudioToolbox
import UIKit

struct CueFeedbackService {
    func playHapticCue(for event: DetectionEvent) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }

    func visualMessage(for event: DetectionEvent) -> String {
        "\(event.soundEvent.rawValue): \(event.direction.rawValue)"
    }
}
