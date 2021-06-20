//
//  AudioRecoeder.swift
//  Voice_sns
//
//  Created by Yuta Nisimatsu on 2021/06/20.
//

import Foundation
import AVFoundation

class AudioRecorder {
    
    private var audioRecoder:AVAudioRecorder!
    internal var audioPlayer: AVAudioPlayer!
    
    internal func record() {
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord)
        try! session.setActive(true)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        audioRecoder = try! AVAudioRecorder(url: getURL(), settings: settings)
        audioRecoder.record()
    }
    
    internal func recoredStop() -> Data? {
        audioRecoder.stop()
        let data = try? Data(contentsOf: getURL())
        return data
    }
    
    internal func play() {
        audioPlayer = try! AVAudioPlayer(contentsOf: getURL())
        audioPlayer.volume = 10.0
        audioPlayer.play()
    }
    
    internal func playStop() {
        audioPlayer.stop()
    }
    
    private func getURL() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("sound.m4a")
    }
    
}
