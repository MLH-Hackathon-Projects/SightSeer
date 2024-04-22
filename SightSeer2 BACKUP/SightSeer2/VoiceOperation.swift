//
//  VoiceOperation.swift
//  SightSeer2
//
//  Created by Peter Zhao on 4/11/23.
//

import Foundation
import AVFoundation

struct VoiceSynthesis{
    let synthesizer = AVSpeechSynthesizer()
    let userMadeSettings = UserDefaults.standard
    
    func stopVoice(){
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
    
    func textToSpeech(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        var voiceToUse: AVSpeechSynthesisVoice!
        var voiceName: String = "Susan (Enhanced)"
        var speedSetting: Float = 0.47
        if  (userMadeSettings.string(forKey: "typeOfVoice") != ""){
            voiceName = String(userMadeSettings.string(forKey: "typeOfVoice") ?? "Susan (Enhanced)")
        }
        if  (userMadeSettings.float(forKey: "speedOfVoice") != 0){
            speedSetting = (round(userMadeSettings.float(forKey: "speedOfVoice"))-1)/23.53+0.30
        }
        for voice in AVSpeechSynthesisVoice.speechVoices()
        {
            if voice.name == voiceName {
                voiceToUse = voice
            }
        }
        utterance.voice = voiceToUse
        utterance.rate = speedSetting
        self.synthesizer.speak(utterance)
        }


}
