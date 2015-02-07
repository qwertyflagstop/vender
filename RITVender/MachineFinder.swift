//
//  MachineFinder.swift
//  RITVender
//
//  Created by Nicholas Peretti on 2/6/15.
//  Copyright (c) 2015 Big Window Studios. All rights reserved.
//
import Foundation
import CoreLocation


class MachineFinder:NSObject, CLLocationManagerDelegate {
    
    
    let manager = CLLocationManager()
    var currentLocation: CLLocation?;
    var currentHeading: CLHeading?;
    
    
    override init(){
        super.init()
        manager = CLLocationManager();
        manager.delegate = self;
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.startUpdatingLocation();
        manager.startUpdatingHeading();
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!) {
        currentHeading = newHeading;
        updateCompass()
    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var location:CLLocation = locations[locations.count-1] as CLLocation
        currentLocation = location;
        updateCompass()
    }
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("we have failed in our efforts... Great");
    }
    func updateCompass(){
        NSNotificationCenter.defaultCenter().postNotificationName("updateCompass", object:self)
    }
    //func headingToClosestMachine()->CLLocationDirection{
        
   // }
    
  //  func distanceToClosestMachine()->CLLocationDistance{
        
  //  }
    func closestMachine()->Machine{
        var closestDistance:CLLocationDistance = 999999999;
        var closestMachine:Machine?
        for machine in Vending().machineArray(){
            let cur = machine as Machine
            
        }
        
        return closestMachine!
    }
    
    
}