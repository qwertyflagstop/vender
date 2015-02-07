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
    var currentMachine: Machine?;
    
    override init(){
        super.init()
        manager = CLLocationManager();
        manager.delegate = self;
        manager.distanceFilter = kCLDistanceFilterNone
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.requestWhenInUseAuthorization();
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
        currentMachine = closestMachine();
        updateCompass()
    }
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("we have failed in our efforts... Great");
    }
    func updateCompass(){
        NSNotificationCenter.defaultCenter().postNotificationName("updateCompass", object:self)
    }
   //func headingToClosestMachineFromCurrentHeading()->CLLocationDirection{
    //    return CLLocationDirection(cll)
   //}
    
    func distanceToClosestMachine()->CLLocationDistance?{
        return currentLocation?.distanceFromLocation(currentMachine?.location)
    }
    func closestMachine()->Machine{
        var closestDistance:CLLocationDistance = 999999999;
        var closestMachine:Machine?
        for machine in Vending().machineArray(){
            let cur = machine as Machine
            let curloc = CLLocation(latitude: cur.latitude!, longitude: cur.longitude!)
            let curdist = currentLocation?.distanceFromLocation(curloc)
            if curdist<closestDistance{
                closestMachine=cur
                closestDistance = curdist!
            }
        }
        return closestMachine!
    }
    
    //func getHeadingFromLocToLoc(from: CLLocation, to: CLLocation)->Float{
    //    let tLat:Double = DegreesToRadians(to.coordinate.latitude)
    //    let tLng:Double = DegreesToRadians(to.coordinate.longitude)
    //    let fLat:Double = DegreesToRadians(from.coordinate.latitude)
   //     let fLng:Double = DegreesToRadians(from.coordinate.longitude)
   //     return atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng))
   // }
    func DegreesToRadians (value:Double) -> Double {
        return value * M_PI / 180.0
    }
    
    
}