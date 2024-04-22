//
//  SettingsView.swift
//  SightSeer2
//
//  Created by Peter Zhao on 4/11/23.
//

import SwiftUI
import AVFoundation
import UIKit

struct SettingsView: View {
    private var VoiceSynthesiser = VoiceSynthesis()
    private let UserSettings = UserDefaults.standard
    @State private var voiceMode: AVSpeechSynthesisVoice = AVSpeechSynthesisVoice.speechVoices()[10]
    @State private var voiceSpeed: Float = 5
    @State private var isEditingSlider = false
    @State private var isStartUp = true
    private var options = AVSpeechSynthesisVoice.speechVoices()
    var body: some View {
        VStack{
            HStack{

                NavigationLink(destination: ContentView()){
                    ButtonView(width: 350, height: 100, xPose: 20, yPose: 60, text: "Back", bg: Color.red, fg: Color.white, corner: 15)
                }
                .onAppear(){
                    voiceSpeed = UserSettings.float(forKey: "speedOfVoice")
                    
                    for voice in AVSpeechSynthesisVoice.speechVoices(){
                        if voice.name == UserSettings.string(forKey: "typeOfVoice") ?? "Susan (Enhanced)" {
                            voiceMode = voice
                        }
                    }
                }
            }
            List {
                Picker("Select a Voice", selection: $voiceMode){
                    ForEach(options, id: \.self) {
                        
                        if (String($0.language)=="en-US"){
                            Text($0.name+" "+$0.language)
                        }
                    }
                }
                HStack {
                        Text("Suggested Voice")
                        Spacer()
                        Text("Susan (Enhanced)")
                    }
            }
            .onChange(of: voiceMode) {newValue in
                if (isStartUp){
                    isStartUp = false
                }else{
                    UserSettings.set(voiceMode.name, forKey: "typeOfVoice")
                    VoiceSynthesiser.textToSpeech(text: "This is my new voice")
                }
    
            }
            
            List {
                Slider(
                            value: $voiceSpeed,
                            in: 1...10,
                            onEditingChanged: { editing in
                                isEditingSlider = editing
                            }

                        )
                        Text("\(round(voiceSpeed))")
                HStack {
                        Text("Suggested Speed")
                        Spacer()
                        Text("5")
                    }
            }
        
            .onChange(of: isEditingSlider) {newValue in
                if (isEditingSlider == false){
                    UserSettings.set(voiceSpeed, forKey: "speedOfVoice")
                    VoiceSynthesiser.textToSpeech(text: "This is my new speed")
                }
            }
            
            
            Spacer()
        }
        .navigationBarHidden(true)
        .statusBar(hidden: true)
    }
   
}
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
