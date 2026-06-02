//
//  SoundEventClassifier.swift
//  ExprimentApp
//
//  Created by Wahyu Kurniawan on 20/05/26.
//

import AVFoundation

struct SoundEventClassifier {
    func classify(buffer: AVAudioPCMBuffer) -> SoundEvent? {
        guard let channelData = buffer.floatChannelData else {
            return nil
        }
        
        let frameLength = Int(buffer.frameLength)
        let energy = calculateEnergy(samples: channelData[0], frameLength: frameLength)
        
        if energy > 0.04 {
            return .generalLoudSound
        }
        
        return nil
    }
    
    private func calculateEnergy(samples: UnsafePointer<Float>, frameLength: Int) -> Float {
        guard frameLength > 0 else {
            return 0
        }
        
        var total: Float = 0
        
        for index in 0 ..< frameLength {
            let sample = samples[index]
            total += sample * sample
        }
        
        return total / Float(frameLength)
    }
}
