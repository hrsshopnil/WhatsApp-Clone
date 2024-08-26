//
//  BubbleAudioView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 6/7/24.
//

import SwiftUI
import AVKit

struct BubbleAudioView: View {
    
    @EnvironmentObject var voiceMessagePlayer: VoiceMessagePlayer
    let item: MessageItem
    
    @State private var playbackState: VoiceMessagePlayer.PlaybackState = .stopped
    @State private var sliderValue = 0.0
    @State private var sliderRange: ClosedRange<Double> = 0...20
    @State private var playbackTime = "00:00"
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 5) {
            if item.showSenderProfile {
                CircularProfileImageView(size: .mini, profileImageUrl: item.sender?.profileImageUrl)
            }
            
            if item.direction == .sent {
                TimeStampView(item: item)
            }
            
            HStack {
                Button {
                    handleAudioPlayer()
                }
                 label: {
                    PlayButton(item: item, icon: playbackState.icon)
                }
                Slider(value: $sliderValue, in: sliderRange) { editing in
                print("editing")
                }
                    .tint(.gray)
                Text(playbackTime)
                    .foregroundStyle(.gray)
            }
            .padding(10)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .padding(5)
            .background(item.bgColor)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .applyTail(item.direction)
            
            if item.direction == .received {
                TimeStampView(item: item)
            }
        }
        .shadow(color: Color(.systemGray3).opacity(0.1), radius: 5, x: 0, y: 20)
        .frame(maxWidth: .infinity, alignment: item.alignment)
        .padding(.leading, item.leadingPadding)
        .padding(.trailing, item.trailingPadding)
        
        .onReceive(voiceMessagePlayer.$playbackState) { state in
            observePlaybackState(state)
        }
        
        .onReceive(voiceMessagePlayer.$currentTime) { currentTime in
            guard voiceMessagePlayer.currentUrl?.absoluteString == item.audioUrl else {
                return }
            listens(to: currentTime)
        }
        
        .onReceive(voiceMessagePlayer.$playerItem) { playerItem in
            guard voiceMessagePlayer.currentUrl?.absoluteString == item.audioUrl else {
                return }
            guard let audioDuration = item.audioDuration else { return }
            print(audioDuration)
            sliderRange = 0...audioDuration
        }
    }
}

extension BubbleAudioView {
    
    private func handleAudioPlayer() {
        if playbackState == .stopped || playbackState == .paused {
            guard let audioUrl = URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3") else { return }
            voiceMessagePlayer.playAudio(from: audioUrl)
        } else {
            voiceMessagePlayer.pauseAudio()
        }
    }
    
    private func observePlaybackState(_ state: VoiceMessagePlayer.PlaybackState) {
        if state == .stopped {
            playbackState = .stopped
            sliderValue = 0
        } else {
            guard voiceMessagePlayer.currentUrl?.absoluteString == item.audioUrl else { return }
            playbackState = state
        }
    }
    
    private func listens(to currentValue: CMTime) {
        playbackTime = currentValue.seconds.formattedElapsedTime
        sliderValue = currentValue.seconds
    }
}

#Preview {
    ScrollView {
        BubbleAudioView(item: .sentPlaceholder)
        BubbleAudioView(item: .receivedPlaceholder)
    }
    .environmentObject(VoiceMessagePlayer())
    .background(.gray.opacity(0.3))}
