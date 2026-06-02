//
//  AudioSessionConfigurator.swift
//  ExprimentApp
//
//  Created by Wahyu Kurniawan on 20/05/26.
//

import AVFoundation

struct AudioSessionConfigurator {
    func requestMicrophonePermission() async -> Bool {
        await AVAudioApplication.requestRecordPermission()
    }

    func configureSession() throws {
        let session = AVAudioSession.sharedInstance()

        try session.setCategory(
            .playAndRecord,
            mode: .measurement,
            options: [.allowBluetoothA2DP, .defaultToSpeaker]
        )

        guard let builtInMic = session.availableInputs?.first(where: { $0.portType == .builtInMic }) else {
            throw AppError.microphoneUnavailable
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

    func isHeadphoneConnected() -> Bool {
        AVAudioSession.sharedInstance().currentRoute.outputs.contains { output in
            output.portType == .headphones ||
                output.portType == .bluetoothA2DP ||
                output.portType == .bluetoothLE ||
                output.portType == .bluetoothHFP
        }
    }

    func isAirPodsConnected() -> Bool {
        AVAudioSession.sharedInstance().currentRoute.inputs.contains { input in
            input.portType == .bluetoothHFP ||
                input.portType == .bluetoothA2DP
        }
    }
}
