//
//  VoiceMessagePlayer.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 17/8/24.
//

import Foundation
import AVFoundation

final class VoiceMessagePlayer: ObservableObject {
    private var player: AVPlayer?
    private(set) var currentUrl: URL?
    
    @Published private(set) var playerItem: AVPlayerItem?
    @Published private(set) var playbackState = PlaybackState.stopped
    @Published private(set) var currentTime = CMTime.zero
    private var currentTimeObserver: Any?
    
    deinit {
        tearDown()
    }
    
    func playAudio(from url: URL) {
        if let currentUrl, currentUrl == url {
            resumePlaying()
        }
        else {
            currentUrl = url
            let playerItem = AVPlayerItem(url: url)
            self.playerItem = playerItem
            player = AVPlayer(playerItem: playerItem)
            player?.play()
            playbackState = .playing
            observedCurrentPlayerTime()
            observeEndOfPlayback()
        }
    }
    
    func pauseAudio() {
        player?.pause()
        playbackState = .paused
    }
    
//    func seek(tos timeInterval: TimeInterval) {
//        guard let player = player else { return }
//        let targetTime = CMTime(seconds: timeInterval, preferredTimescale: 1)
//        player.seek(to: targetTime)
//    }
    
    private func resumePlaying() {
        if playbackState == .paused || playbackState == .stopped {
            player?.play()
            playbackState = .playing
        }
    }
    private func observedCurrentPlayerTime() {
        print("gearing up")
        currentTimeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: DispatchQueue
            .main) { [weak self] time in
                self?.currentTime = time
                print(time)
            }
    }
    
    private func observeEndOfPlayback() {
        NotificationCenter.default.addObserver(forName: AVPlayerItem.didPlayToEndTimeNotification, object: player?.currentItem, queue: .main) { [weak self] _ in
            self?.stopAudioPlayer()
            print("observeEndofPlayback")
        }
    }
    
    private func stopAudioPlayer() {
        player?.pause()
        player?.seek(to: .zero)
        playbackState = .stopped
        currentTime = .zero
    }
    
    private func removeObserver() {
        guard let currentTimeObserver else { return }
        player?.removeTimeObserver(currentTimeObserver)
        self.currentTimeObserver = nil
        print("removeObserver fired")
    }
    
    private func tearDown() {
        removeObserver()
        player = nil
        playerItem = nil
        currentUrl = nil
    }
}

extension VoiceMessagePlayer {
    enum PlaybackState {
        case stopped, playing, paused
        
        var icon: String {
            return self == .playing ? "pause.fill" : "play.fill"
        }
    }
}
