import SwiftUI
import AVFoundation

// MARK: - Custom Video Player untuk Looping & Mute
struct LoopingVideoPlayer: UIViewRepresentable {
    var videoName: String
    var videoExt: String = "mp4" // Ubah kalau format videomu .mov

    func makeUIView(context: Context) -> UIView {
        return LoopingPlayerUIView(videoName: videoName, videoExt: videoExt)
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

class LoopingPlayerUIView: UIView {
    private var playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?

    init(videoName: String, videoExt: String) {
        super.init(frame: .zero)
        
        // Cari file video di dalam project
        guard let url = Bundle.main.url(forResource: videoName, withExtension: videoExt) else {
            print("⚠️ File video \(videoName).\(videoExt) tidak ditemukan di Xcode!")
            return
        }

        let asset = AVAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        
        // AVQueuePlayer yang bikin loopingnya mulus
        let queuePlayer = AVQueuePlayer(playerItem: item)
        queuePlayer.isMuted = true // Bikin tanpa suara
        
        playerLayer.player = queuePlayer
        playerLayer.videoGravity = .resizeAspect // Bisa diganti .resizeAspectFill kalau mau zoom-in
        layer.addSublayer(playerLayer)

        // Mesin Looping
        playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: item)
        queuePlayer.play()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}