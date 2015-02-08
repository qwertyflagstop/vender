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
    
    var locations: [CLLocation]
    let manager = CLLocationManager()
    var currentHeading: CLHeading?;
    var currentMachine: Machine?;
    var started:Bool;
    var initalDistance: Double?;
    var mostRecentLocation: CLLocation?
    override init(){
        self.started = false;
        self.locations = [];
        super.init()
        manager = CLLocationManager();
        manager.delegate = self;
        manager.distanceFilter = kCLDistanceFilterNone
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization();
        manager.startUpdatingLocation();
        manager.startUpdatingHeading();
    }
    func locationManager(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!) {
        currentHeading = newHeading
        refresh()
    }
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        if newLocation.horizontalAccuracy<0 {
            return
        }
        if newLocation.timestamp.timeIntervalSinceNow > 5.0 {
            return
        }
        mostRecentLocation = newLocation;
        refresh()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var location:CLLocation = locations[locations.count-1] as CLLocation
        if location.horizontalAccuracy < -0.5{
                return
        }
        
        if !started {
            self.locations.append(location)
            currentMachine = closestMachine();
            started=true
            initalDistance = location.distanceFromLocation(currentMachine?.location)
        } else {
            self.locations.append(location)
            refresh()
        }
    }
    
    var currentLocation: CLLocation?{
        get
        {
          return locations.last
            
        }
    }
    
    func getHeadingFromLocToLoc(from: CLLocation, to: CLLocation)->Float{
        let tLat : Float = DegreesToRadians(NSNumber(double:to.coordinate.latitude).floatValue)
        let tLng : Float = DegreesToRadians(NSNumber(double:to.coordinate.longitude).floatValue)
        let fLat : Float = DegreesToRadians(NSNumber(double:from.coordinate.latitude).floatValue)
        let fLng : Float = DegreesToRadians(NSNumber(double:from.coordinate.longitude).floatValue)
        return atan2(sin(tLng-fLng)*cos(tLat) ,cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng))
    }
    func DegreesToRadians (value:Float) -> Float {
        return value * Float(M_PI) / Float(180.0)
    }
    func refresh(){
        updateCompass()
    }
    func updateCompass(){
        NSNotificationCenter.defaultCenter().postNotificationName("updateCompass", object:self)
    }
    func closestMachine()->Machine{
        var closestDistance:CLLocationDistance = 999999999;
        var closestMachine:Machine?
        for machine in Vending().machineArray(){
            let cur = machine as Machine
            let curloc = CLLocation(latitude: cur.latitude!, longitude: cur.longitude!)
            let curdist = locations.last?.distanceFromLocation(curloc)
            if curdist<closestDistance{
                closestMachine=cur
                closestDistance = curdist!
            }
        }
        return closestMachine!
    }
    func distanceLeft()->Float{
        return Float(currentLocation!.distanceFromLocation(currentMachine?.location))*3.28084
    }
}