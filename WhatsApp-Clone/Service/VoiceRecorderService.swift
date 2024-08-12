//
//  VoiceRecorderService.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 12/8/24.
//

import Foundation
import AVFoundation
import Combine

/// Recording Voice Message
/// Storing Message URL
final class VoiceRecorderService {
    private var audioRecorder: AVAudioRecorder?
    private var isRecording = false
    private var elapsedTime: TimeInterval = 0
    private var startTime: Date?
    private var timer: AnyCancellable?

    func startRecording() {
        /// SetUp AudioSession
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.overrideOutputAudioPort(.speaker)
            try audioSession.setActive(true)
        } catch {
            print("VoiceRecorderService: Failed to setUp AVAudioSession")
        }

        /// Where do wanna store the voice message? URL
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFileName = Date().toString(format: "dd-MM-YY 'at' HH:mm:ss") + ".m4a"
        let audioFileURL = documentPath.appendingPathComponent(audioFileName)

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: settings)
            audioRecorder?.record()
            isRecording = true
            startTime = Date()
            startTimer()
        } catch {
            print("VoiceRecorderService: Failed to setUp AVAudioRecorder")
        }
    }
    
    func stopRecording(completion: ((_ audioUrl: URL?, _ audioDuration: TimeInterval) -> Void)? = nil) {
        guard isRecording else {return}
        
        let audioDuration = elapsedTime
        
        audioRecorder?.stop()
        isRecording = false
        timer?.cancel()
        elapsedTime = 0
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
            guard let audioUrl = audioRecorder?.url else { return }
            completion?(audioUrl, audioDuration)
        }
        catch {
            print("VoiceRecorderService: Failed to tear down AVAudioRecorder")
        }
    }
    
    private func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect().sink { [weak self] _ in
            guard let startTime = self?.startTime else {return}
            self?.elapsedTime = Date().timeIntervalSince(startTime)
        }
    }
}
