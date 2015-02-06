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

    @IBOutlet weak var cameraView: UIView!
    let captureSession: AVCaptureSession = AVCaptureSession();
    var captureDevice : AVCaptureDevice?
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
                        for captureFormat in videoformats{
                            
                        }
                    }
                }
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

