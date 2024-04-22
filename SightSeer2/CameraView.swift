//
//  CameraView.swift
//  SightSeer2
//
//  Created by Peter Zhao on 4/11/23.
//

import Foundation
import SwiftUI
import Vision
import AVFoundation

struct CameraView: View {
    var body: some View {
        VStack{
            Spacer()
            NavigationLink(destination: ContentView()){
                ButtonView(width: 200, height: 100, xPose: 20, yPose: 60, text: "Stop", bg: Color.red, fg: Color.white, corner: 20)
            }
        }
        .navigationBarHidden(true)
        .statusBar(hidden: true)
    }
    
}
struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}


