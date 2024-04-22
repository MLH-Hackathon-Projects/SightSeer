//
//  ContentView.swift
//  SightSeer2
//
//  Created by Peter Zhao on 4/11/23.
//

import SwiftUI
import UIKit
import AVFAudio

struct ContentView: View {
    let camera = Camera()
    
    var body: some View {
        NavigationStack{
            VStack {
                HStack{
                    Spacer()
                    NavigationLink(destination: SettingsView()){
                        ButtonView(width: 100, height: 50, xPose: 20, yPose: 60, text: "Settings", bg: Color.gray, fg: Color.white, corner: 15)
                            .onAppear {
                                camera.isPreviewPaused = false
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            }
                            .onDisappear {
                                camera.isPreviewPaused = true
                                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                            }
                    }
                }
                Spacer()
                HStack{
                    NavigationLink(destination: CameraView().onAppear {camera.takePhoto()}.onDisappear{camera.VoiceSynthesiser.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)}){
                        ButtonView(width: 200, height: 100, xPose: 20, yPose: 60, text: "Read Text", bg: Color.blue, fg: Color.white, corner: 20)
                    }
                    
                }
                
            }
            .task{
                await camera.startCamera()
            }
            .navigationBarHidden(true)
            .statusBar(hidden: true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct ButtonView: View {
    let width: CGFloat
    let height: CGFloat
    let xPose: CGFloat
    let yPose: CGFloat
    let text: String
    let bg: Color
    let fg: Color
    let corner: CGFloat
    init(width: CGFloat, height: CGFloat, xPose: CGFloat, yPose: CGFloat, text: String, bg: Color, fg: Color, corner: CGFloat){
        self.width = width
        self.height = height
        self.xPose = xPose
        self.yPose = yPose
        self.bg = bg
        self.fg = fg
        self.text = text
        self.corner = corner
    }
    var body: some View {
        Text(self.text)
            .frame(width: self.width, height: self.height, alignment: .center)
            //.position(x: self.xPose, y: self.yPose)
            .background(self.bg)
            .foregroundColor(self.fg)
            .cornerRadius(self.corner)
    }
}
