//
//  VideoPlayerView.swift
//  LiveWeatherApp
//
//  Created by Lov Lamba on 31/03/23.
//

import Foundation
import SwiftUI
import AVKit
import AVFoundation

struct VideoPlayerView: UIViewRepresentable {
    @Binding var weather: Weather?
    func updateUIView(_ uiView: LoopingPlayerUIView, context: Context) {
        uiView.videoName = MainViewModel.getVideoName(iconName: weather?.icon ?? "")
        uiView.play()
    }
    func makeUIView(context: Context) -> LoopingPlayerUIView{
        return LoopingPlayerUIView(frame: .zero, videoName: MainViewModel.getVideoName(iconName: weather?.icon ?? ""))
    }
}

class LoopingPlayerUIView: UIView {
    var videoName: String
    private let playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(frame: CGRect, videoName: String) {
        self.videoName = videoName
        super.init(frame: frame)
        play()
        
    }
    func play(){
        let fileUrl = Bundle.main.url(forResource: self.videoName, withExtension: "MOV")!
        let asset = AVAsset(url: fileUrl)
        let item = AVPlayerItem(asset: asset)
        let player = AVQueuePlayer()
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
        playerLooper = AVPlayerLooper(player: player, templateItem: item)
        player.play()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
