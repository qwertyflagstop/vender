//
//  ViewController.swift
//  RITVender
//
//  Created by Nicholas Peretti on 2/5/15.
//  Copyright (c) 2015 Big Window Studios. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    let captureSession: AVCaptureSession = AVCaptureSession();
    var captureDevice : AVCaptureDevice?
    var previewLayer : AVCaptureVideoPreviewLayer?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        captureSession.sessionPreset = AVCaptureSessionPreset1280x720
        
        let devices = AVCaptureDevice.devices()
        
        for device in devices {

            if (device.hasMediaType(AVMediaTypeVideo)) {

                if(device.position == AVCaptureDevicePosition.Back) {
                    captureDevice = device as? AVCaptureDevice
                    if let videoformats = captureDevice?.formats {
                        var fastFormat:AVCaptureDeviceFormat;
                        for captureFormat in videoformats{
                            println("inner")
                            if(captureFormat.maxFrameRate>=59&&captureFormat.maxFrameRate<=61.0){
                                println("here /(captureFormat)")
                                fastFormat = captureFormat as AVCaptureDeviceFormat;
                            }
                        }
                    }
                }
            }
        }
        if captureDevice != nil {
            beginSession()
        }
        
        
    }
    
    
    func beginSession() {
        var err : NSError? = nil
        captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err))
        
        if err != nil {
            println("error: \(err?.localizedDescription)")
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.view.layer.addSublayer(previewLayer)
        previewLayer?.frame = self.view.layer.frame
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        captureSession.startRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

