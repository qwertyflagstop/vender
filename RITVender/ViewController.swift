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
        
        captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    
        let devices = AVCaptureDevice.devices()
        var Vender = Vending()
        println(Vender.dictionary())
        
        /*
        for device in devices {
            if (device.hasMediaType(AVMediaTypeVideo)) {
                if(device.position == AVCaptureDevicePosition.Back) {
                    captureDevice = device as? AVCaptureDevice
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
        configureDevice()
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.view.layer.addSublayer(previewLayer)
        previewLayer?.frame = self.view.layer.frame
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        captureSession.startRunning()
    }

    func configureDevice() {
        if let device = captureDevice {
            
            
            for vFormat in captureDevice!.formats {
                
                var ranges = vFormat.videoSupportedFrameRateRanges as [AVFrameRateRange]
                var frameRates = ranges[0]
                
                if frameRates.maxFrameRate == 60 {
                    
                    device.lockForConfiguration(nil)
                    device.activeFormat = vFormat as AVCaptureDeviceFormat
                    device.activeVideoMinFrameDuration = frameRates.minFrameDuration
                    device.activeVideoMaxFrameDuration = frameRates.minFrameDuration
                    device.unlockForConfiguration()
                    
                }
            }
        }
        
    }

}

