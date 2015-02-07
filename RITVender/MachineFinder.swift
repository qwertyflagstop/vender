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
    
    override init(){
        self.started = false;
        self.locations = [];
        super.init()
        manager = CLLocationManager();
        manager.delegate = self;
        manager.distanceFilter = kCLDistanceFilterNone
    
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.activityType = CLActivityType.OtherNavigation
        manager.requestWhenInUseAuthorization();
        manager.startUpdatingLocation();
        manager.startUpdatingHeading();
    }
    func locationManager(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!) {
        currentHeading = newHeading
        //println( DegreesToRadians(currentHeading!.trueHeading) )
        refresh()
    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var location:CLLocation = locations[locations.count-1] as CLLocation
        if location.horizontalAccuracy > -1{
        self.locations.append(location)
        if !started {
            currentMachine = closestMachine();
            started=true
        }
        refresh()
        }
    }
    func refresh(){
        
        updateCompass()
    }
    var currentLocation: CLLocation{
        get
        {
            let count = 20
            if locations.count<count {
                return locations.last!
            }else{
                var totalLat = 0.0;
                var totalLng = 0.0;
                for index in 1...count {
                    let current = locations[locations.count-index] as CLLocation
                    totalLat = totalLat+current.coordinate.latitude;
                    totalLng = totalLng+current.coordinate.longitude;
                }
                return CLLocation(latitude: (totalLat/Double(count))*0.3+locations.last!.coordinate.latitude*0.7, longitude: (totalLng/Double(count))*0.3+locations.last!.coordinate.longitude*0.7)
            }
            
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
}