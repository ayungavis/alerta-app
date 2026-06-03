//
//  AudioSessionConfigurator.swift
//  AlertaApp
//
//  Created by Wahyu Kurniawan on 20/05/26.
//

import AVFoundation

struct AudioSessionConfigurator {
    func configureSession() throws {
        let session = AVAudioSession.sharedInstance()

        try session.setCategory(
            .playAndRecord,
            mode: .measurement,
            options: [.allowBluetoothA2DP, .defaultToSpeaker]
        )

        guard let builtInMic = session.availableInputs?.first(where: { $0.portType == .builtInMic })
        else {
            throw AppError.unavailableFeature(.microphoneUnavailable)
        }

        try session.setPreferredInput(builtInMic)

        if let dataSource = builtInMic.dataSources?.first,
           dataSource.supportedPolarPatterns?.contains(.stereo) == true
        {
            try dataSource.setPreferredPolarPattern(.stereo)
            try builtInMic.setPreferredDataSource(dataSource)
        }

        try session.setActive(true)
    }

    func isAirPodsConnected() -> Bool {
        AVAudioSession.sharedInstance().currentRoute.inputs.contains { input in
            input.portType == .bluetoothHFP || input.portType == .bluetoothA2DP
        }
    }
}
