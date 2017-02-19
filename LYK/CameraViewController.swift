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
import Firebase
import ChameleonFramework

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    @IBOutlet weak var previewLayer: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var switchCameraImageView: UIImageView!
    @IBOutlet weak var picturesTakenImageView: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCapturePhotoOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var photoSettings: AVCapturePhotoSettings?
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var microphone: AVCaptureDevice?
    
    var photo: UIImage?
    var isBackFacing: Bool = true;
    
    var ref: FIRDatabaseReference!
    var currentUser: FIRUser!
    var user: User!
    
    var photosTaken: [UIImage]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Firebase setup
        self.ref = FIRDatabase.database().reference()
        self.currentUser = FIRAuth.auth()?.currentUser
        
        //setup camera button
        self.cameraButton.layer.masksToBounds = false
        self.cameraButton.layer.cornerRadius = self.cameraButton.frame.size.height / 2
        self.cameraButton.layer.borderWidth = 5
        self.cameraButton.layer.borderColor = UIColor.flatWhite().cgColor
        
        //setup switch camera button
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(CameraViewController.switchCamera))
        singleTap.numberOfTapsRequired = 1
        self.switchCameraImageView.addGestureRecognizer(singleTap)
        
        //setup send button
        self.sendButton.isHidden = true
        
        //remove photos
        let tapOnPhotos = UITapGestureRecognizer(target: self, action: #selector(CameraViewController.removePhotos))
        tapOnPhotos.numberOfTapsRequired = 1
        self.picturesTakenImageView.addGestureRecognizer(tapOnPhotos)
        self.picturesTakenImageView.isUserInteractionEnabled = false
        
//        //remove photos
//        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(CameraViewController.switchCamera))
//        tapOnPhotos.numberOfTapsRequired = 2
//        self.previewLayer.addGestureRecognizer(doubleTap)
        
        // setup preview past pictures
        self.photosTaken = [UIImage]()
        self.picturesTakenImageView.layer.masksToBounds = true
        self.picturesTakenImageView.layer.cornerRadius = self.picturesTakenImageView.frame.size.height / 8
        self.picturesTakenImageView.layer.borderWidth = 2
        self.picturesTakenImageView.layer.borderColor = UIColor.flatWhite().cgColor
        
        setupCamera(back: true)
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.fade
    }
    
    func setPhotosTaken (photos: [UIImage]) {
        self.photosTaken = photos
        
        if self.photosTaken.isEmpty {
            self.picturesTakenImageView.image = nil
            self.picturesTakenImageView.isUserInteractionEnabled = false
            self.picturesTakenImageView.isHidden = true
            self.sendButton.isHidden = true
        } else {
            self.picturesTakenImageView.image = self.photosTaken.last
        }
    }
    
    func setupCamera(back: Bool) {
        // ---- EVERYTHING BELOW THIS IS CAMERA SHIT
        //setup session
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = AVCaptureSessionPresetHigh
        stillImageOutput = AVCapturePhotoOutput()
        
        //get devices
        frontCamera = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front)
        backCamera = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back)
        microphone = AVCaptureDevice.defaultDevice(withDeviceType: .builtInMicrophone, mediaType: AVMediaTypeAudio, position: .unspecified)
        
        //setup input to attach devices to session
        do {
            var input: AVCaptureDeviceInput;
            
            if (back) {
                input = try AVCaptureDeviceInput(device: backCamera)
            } else {
                input = try AVCaptureDeviceInput(device: frontCamera)
            }
            
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
            if (!self.isBackFacing) {
                self.photo = UIImage(cgImage: (self.photo?.cgImage!)!, scale: 1.0, orientation: UIImageOrientation.leftMirrored)
            }
            
            //this is when we change to the show image view controller
//            self.performSegue(withIdentifier: "photoSegue", sender: self)
            
            self.picturesTakenImageView.isHidden = false
            self.picturesTakenImageView.image = self.photo
            self.picturesTakenImageView.isUserInteractionEnabled = true
            self.photosTaken.append(self.photo!)
            print("took photo")
            
            self.sendButton.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postPhotoSegue" {
            let vc = segue.destination as! PostImageViewController
            print(self.photosTaken)
            vc.photos = self.photosTaken
            vc.user = self.user
        } else if segue.identifier == "choosePhotosSegue" {
            let vc = segue.destination as! CameraPickerViewController
            vc.photos = self.photosTaken
        }
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
    }
    
    @IBAction func prepareForSegueFromPosting(segue: UIStoryboardSegue) {
    }
    
    func switchCamera() {
        self.captureSession?.stopRunning()
        self.setupCamera(back: self.switchCameraImageView.isHighlighted)
        self.switchCameraImageView.isHighlighted = !self.switchCameraImageView.isHighlighted
        self.isBackFacing = !self.switchCameraImageView.isHighlighted;
    }
    
    func removePhotos() {
        performSegue(withIdentifier: "choosePhotosSegue", sender: self)
    }
}
