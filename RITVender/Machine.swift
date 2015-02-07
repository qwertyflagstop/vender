//
//  Machine.swift
//  RITVender
//
//  Created by Lynne Meehan on 2/6/15.
//  Copyright (c) 2015 Big Window Studios. All rights reserved.
//

import Foundation

class Machine{
    
    var meals: Bool?
    var snacks: Bool?
    var soda: Bool?
    var latitude: Double?
    var longitude: Double?
    var floor: Int?
    var title: NSString?
    
    init(title: NSString, meals: NSNumber, soda: NSNumber, snacks: NSNumber, latitude: NSNumber, longitude: NSNumber, floor: NSNumber){
        self.title = title
        self.meals = meals.boolValue
        self.soda = soda.boolValue
        self.snacks = snacks.boolValue
        self.latitude = latitude.doubleValue
        self.longitude = longitude.doubleValue
        self.floor = floor.integerValue
        
    }
    
}