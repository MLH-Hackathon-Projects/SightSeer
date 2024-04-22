import Foundation
import UIKit
import SwiftUI
import Vision
import AVFoundation

class Camera: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate{
    var VoiceSynthesiser = VoiceSynthesis()
    var isPreviewPaused: Bool = false
    private let captureSession = AVCaptureSession()
    private let dataOutput = AVCaptureVideoDataOutput()
    private var photoOutput = AVCapturePhotoOutput()
    
    
    private let videoDataOutputQueue = DispatchQueue(label: "CameraFeedDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    override init(){
        super.init()
        setupInput()
    }
    
    private func setupInput() {
        print("no")
        captureSession.beginConfiguration()

        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .unspecified)
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!), captureSession.canAddInput(videoDeviceInput)
        else { return }
        
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
              dataOutput.alwaysDiscardsLateVideoFrames = true
              dataOutput.videoSettings = [
                String(kCVPixelBufferPixelFormatTypeKey): Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
              dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        }

        captureSession.addInput(videoDeviceInput)

        captureSession.addOutput(photoOutput)
        captureSession.sessionPreset = .high
        
        photoOutput.maxPhotoDimensions
        photoOutput.maxPhotoQualityPrioritization = .quality
        
        captureSession.commitConfiguration()
        
    }
    func startCamera() async{
        captureSession.startRunning()
    }
    
    func stopCamera() async{
        captureSession.stopRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if (isPreviewPaused==false){
            let requestHandler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .down)
            
            let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
            
            do {
              // Perform the text-detection request.
              try requestHandler.perform([request])
            } catch {
              print("Unable to perform the request: \(error).")
            }
        }
    }
    
    func recognizeTextHandler(request: VNRequest, error: Error?) {
        print("yes")
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            return
        }

        let recognizedStrings = observations.compactMap { observation in
            return observation.topCandidates(1).first?.string
        }
        
        if(!recognizedStrings.isEmpty){
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }
    
    func readText(image: CIImage){
        print("letsgoooooo")
        let requestHandler = VNImageRequestHandler(ciImage: image)
        let request = VNRecognizeTextRequest(completionHandler: readTextHandler)
        do {
          try requestHandler.perform([request])
        } catch {
          print("Unable to perform the request: \(error).")
        }
    }
    
    func readTextHandler(request: VNRequest, error: Error?){
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            return
        }

        let recognizedStrings = observations.compactMap { observation in
            return observation.topCandidates(1).first?.string
        }
        
        VoiceSynthesiser.textToSpeech(text: recognizedStrings.joined(separator:". "))
    }
    
    func takePhoto(){
        var photoSettings = AVCapturePhotoSettings()
        let photoOutput = self.photoOutput
        
        if photoOutput.availablePhotoCodecTypes.contains(.hevc) {
            photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
        }
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    func stopVoice(){
        VoiceSynthesiser.stopVoice()
    }
}

extension Camera: AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        readText(image: CIImage(data: photo.fileDataRepresentation()!)!)
    }
}

