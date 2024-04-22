//
//  Microphone.swift
//  SightSeer2
//
//  Created by Peter Zhao on 4/14/23.
//

import Foundation
import AVFoundation
import Speech

class Microphone: NSObject{
    private var isMicrophonePaused = false
    private let audioEngine = AVAudioEngine()
    private let recognizer = SFSpeechRecognizer()
    private let request = SFSpeechAudioBufferRecognitionRequest()
    let audioSession = AVAudioSession.sharedInstance()
    
    override init(){
        super.init()
        setupRecording()
    }
    private func setupRecording(){
        let inputNode = audioEngine.inputNode
        
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to set audio session category.")
        }
        self.request.shouldReportPartialResults = true
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in self.request.append(buffer)
        }
        audioEngine.prepare()
        do{
            try audioEngine.start()
        } catch {
            print("failed to start")
        }
    }
    

}
