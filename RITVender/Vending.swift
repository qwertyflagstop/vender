//
//  Vending.swift
//  RITVender
//
//  Created by Lynne Meehan on 2/5/15.
//  Copyright (c) 2015 Big Window Studios. All rights reserved.
//

import Foundation

class Vending{
    
    
    func getString() ->NSString?{
        //String Function; returns json string
        if let filePath = NSBundle.mainBundle().pathForResource("vending",ofType:"json") {
            return NSString(contentsOfFile: filePath, encoding: NSUTF8StringEncoding, error: nil)!
        } else {
            return ""
        }
    }
    func getDict(fileString: NSString)->NSDictionary{
        if let fileData = fileString.dataUsingEncoding(NSUTF8StringEncoding){
            let jsonData = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("vending",ofType:"json")!, options: nil, error: nil)
            if let dict = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
                return dict
            }else{
                print(dict)
                return [:]
            }
        }
        return [:]
    }
    
    func dictionary()->NSDictionary{
        return getDict(getString()!)
    }
    
    func machineArray()->NSMutableArray{
        var mArray = NSMutableArray()
        var machineDict: NSDictionary = dictionary()
        for key in machineDict.allKeys{
            
            var newDict: NSDictionary = machineDict.objectForKey(key) as NSDictionary
            let title = key as NSString
            let meals = newDict.objectForKey("meals") as NSNumber
            let soda = newDict.objectForKey("soda") as NSNumber
            let snacks = newDict.objectForKey("snacks") as NSNumber
            let latitude = newDict.objectForKey("latitude") as NSNumber
            let longitude = newDict.objectForKey("longitude") as NSNumber
            let floor = newDict.objectForKey("floor") as NSNumber
            
            mArray.addObject(Machine(title: title, meals: meals, soda: soda, snacks: snacks, latitude: latitude, longitude: longitude, floor: floor))
        }
        return mArray
    }
    
}
