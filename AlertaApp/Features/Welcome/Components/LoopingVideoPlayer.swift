//
//  LoopingVideoPlayer.swift
//  AlertaApp
//
//  Created by Kyky on 05/06/26.
//

import AVFoundation
import SwiftUI

struct LoopingVideoPlayer: UIViewRepresentable {
    var videoName: String
    var videoExt: String = "mp4"

    func makeUIView(context: Context) -> UIView {
        LoopingPlayerUIView(videoName: videoName, videoExt: videoExt)
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

class LoopingPlayerUIView: UIView {
    private var playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?

    init(videoName: String, videoExt: String) {
        super.init(frame: .zero)

        guard let url = Bundle.main.url(forResource: videoName, withExtension: videoExt) else {
            print("⚠️ File \(videoName).\(videoExt) not found!")
            return
        }

        let asset = AVAsset(url: url)
        let item = AVPlayerItem(asset: asset)

        let queuePlayer = AVQueuePlayer(playerItem: item)
        queuePlayer.isMuted = true

        playerLayer.player = queuePlayer
        playerLayer.videoGravity = .resizeAspect
        layer.addSublayer(playerLayer)

        playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: item)
        queuePlayer.play()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
