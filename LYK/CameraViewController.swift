//
//  CameraViewController.swift
//  LYK
//
//  Created by Jack Short on 1/16/17.
//  Copyright © 2017 Jack Short. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    @IBOutlet weak var previewLayer: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCapturePhotoOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var photoSettings: AVCapturePhotoSettings?
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var microphone: AVCaptureDevice?
    
    var photo: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cameraButton.layer.masksToBounds = false
        self.cameraButton.layer.cornerRadius = self.cameraButton.frame.size.height / 2
        self.cameraButton.layer.borderWidth = 5
        self.cameraButton.layer.borderColor = UIColor.white.cgColor
        
        // ---- EVERYTHING BELOW THIS IS CAMERA SHIT
        //setup session
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = AVCaptureSessionPreset1920x1080
        stillImageOutput = AVCapturePhotoOutput()
        
        //get devices
        backCamera = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back)
        frontCamera = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front)
        microphone = AVCaptureDevice.defaultDevice(withDeviceType: .builtInMicrophone, mediaType: AVMediaTypeAudio, position: .unspecified)
        
        //setup input to attach devices to session
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            if captureSession!.canAddInput(input) {
                captureSession!.addInput(input)
                
                if (captureSession?.canAddOutput(stillImageOutput))! {
                    captureSession?.addOutput(stillImageOutput)
                    captureSession!.startRunning()
                    
                    videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    videoPreviewLayer!.frame = self.previewLayer.bounds
                    videoPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
                    videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                    previewLayer.layer.addSublayer(videoPreviewLayer!)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.fade
    }
    
    //avcapture delegate functions
    @IBAction func takePhoto(_ sender: Any) {
        photoSettings = AVCapturePhotoSettings()
        let previewPixelType = photoSettings?.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                             kCVPixelBufferWidthKey as String: 160,
                             kCVPixelBufferHeightKey as String: 160]
        photoSettings?.previewPhotoFormat = previewFormat
        self.stillImageOutput?.capturePhoto(with: photoSettings!, delegate: self)
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
        
        if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            let image = UIImage(data: dataImage)
            self.photo = image
            
            self.performSegue(withIdentifier: "photoSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoSegue" {
            let vc = segue.destination as! ImageViewController
            vc.photo = self.photo
        }
    }
}
