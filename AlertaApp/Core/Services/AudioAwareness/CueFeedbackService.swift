//
//  CueFeedbackService.swift
//  AlertaApp
//
//  Created by Wahyu Kurniawan on 20/05/26.
//

import AudioToolbox
import UIKit

struct CueFeedbackService {
    func playHapticCue(for event: DetectionEvent) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
