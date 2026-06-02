//
//  DirectionEstimator.swift
//  ExprimentApp
//
//  Created by Wahyu Kurniawan on 20/05/26.
//

import AVFoundation

struct DirectionEstimator {
    func estimateDirection(from buffer: AVAudioPCMBuffer, threshold: Float) -> SoundDirection {
        guard let channelData = buffer.floatChannelData else {
            return .unknown
        }
        
        guard Int(buffer.format.channelCount) >= 2 else {
            return .unknown
        }
        
        let frameLength = Int(buffer.frameLength)
        let leftEnergy = calculateEnergy(samples: channelData[0], frameLength: frameLength)
        let rightEnergy = calculateEnergy(samples: channelData[1], frameLength: frameLength)
        let difference = leftEnergy - rightEnergy
        
        if difference > threshold {
            return .left
        }
        
        if difference < -threshold {
            return .right
        }
        
        return .nearby
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
