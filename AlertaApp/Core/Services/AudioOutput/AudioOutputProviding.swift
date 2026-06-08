//
//  AudioOutputProviding.swift
//  AlertaApp
//
//  Created by Wahyu Kurniawan on 08/06/26.
//

import Foundation

protocol AudioOutputProviding {
    func play(_ event: DetectionEvent) throws
    func stopSpeaking()
}
