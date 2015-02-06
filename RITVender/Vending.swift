//
//  Vending.swift
//  RITVender
//
//  Created by Lynne Meehan on 2/5/15.
//  Copyright (c) 2015 Big Window Studios. All rights reserved.
//

import Foundation

class Vending{
    func getString() ->NSString{
        //String Function; returns json string
        if let filePath = NSBundle.mainBundle().pathForResource("vending",ofType:"json") {
            return String(contentsOfFile: filePath, encoding: NSUTF8StringEncoding, error: nil)!
        } else {
            return ""
        }
    }
}
