//
//  AudioOutputProviding.swift
//  AlertaApp
//
//  Created by Dimas Nugraha on 04/06/26.
//
import AVFoundation

protocol AudioOutputProviding: AnyObject {
    func play(_ event: DetectionEvent) throws
    func stopSpeaking()

    func speechSynthesizer(
        _ synthesiser: AVSpeechSynthesizer,
        didStart utterance: AVSpeechUtterance
    )
}
