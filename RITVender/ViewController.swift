//
//  ViewController.swift
//  RITVender
//
//  Created by Nicholas Peretti on 2/5/15.
//  Copyright (c) 2015 Big Window Studios. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    let captureSession: AVCaptureSession = AVCaptureSession();
    var captureDevice : AVCaptureDevice?
    var previewLayer : AVCaptureVideoPreviewLayer?
    var blurEffect : UIBlurEffect?
    let finder:MachineFinder=MachineFinder();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        captureSession.sessionPreset = AVCaptureSessionPresetHigh;

        let devices = AVCaptureDevice.devices()
       
        
        
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
        blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect!)
        blurEffectView.frame = view.bounds //view is self.view in a UIViewController
        view.addSubview(blurEffectView)
        view.bringSubviewToFront(distanceLbl);
        view.bringSubviewToFront(titleLbl);
        view.bringSubviewToFront(arrow);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateHUD", name: "updateCompass", object: nil)
    }
    
    func updateHUD(){
        distanceLbl.text = NSString(format: "~%.0f Feet", finder.currentLocation.distanceFromLocation(finder.currentMachine?.location)*3.28084)
        titleLbl.text = finder.currentMachine!.title
        if finder.currentHeading != nil {
            let angleFromCurrent :Float = finder.getHeadingFromLocToLoc(finder.currentLocation, to: finder.currentMachine!.location!)
            let currentOffset: Float = -DegreesToRadians( NSNumber(double:finder.currentHeading!.trueHeading).floatValue )
            let rotation = CGFloat(angleFromCurrent-currentOffset)
            var transform = CGAffineTransformRotate(CGAffineTransformIdentity, -(rotation+0.5))
            UIView.animateKeyframesWithDuration(0.05, delay: 0.0, options: nil
                , animations: { () -> Void in
                   self.arrow.transform = transform
            }, completion: { (Bool) -> Void in
            
            })
        }
        
    }
    
    func beginSession() {
        var err : NSError? = nil

        if(captureSession.canAddInput(AVCaptureDeviceInput(device: captureDevice, error: &err))){
        captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err))
        }
        
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
    func DegreesToRadians (value:Float) -> Float {
        return value * Float(M_PI) / Float(180.0)
    }


}

