//
//  Cars.swift
//  WDemo
//
//  Created by wyj on 2018/9/14.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit
import SwiftyJSON

class coordinate: NSObject {
    var latitude:NSNumber = 0.0
    var longitude:NSNumber = 0.0
    
}

class CarItem: NSObject {
    var address:String?
    var engineType:String?
    var exterior:String?
    var fuel:NSNumber?
    var interior:String?
    var name:String?
    var vin:String?
    var coordinates:coordinate?
    
    init(json:JSON) {
        super.init()
        for (subKey,subValue):(String, JSON) in json {
            if subKey == "address" {
                self.address = subValue.string
            } else if subKey == "engineType" {
                self.engineType = subValue.string
            } else if subKey == "exterior" {
                self.exterior = subValue.string
            } else if subKey == "fuel" {
                self.fuel = subValue.number
            } else if subKey == "interior" {
                self.interior = subValue.string
            } else if subKey == "name" {
                self.name = subValue.string
            } else if subKey == "vin" {
                self.vin = subValue.string
            } else if subKey == "coordinates" {
                let coord:coordinate = coordinate.init()
                coord.longitude = subValue.array![0].number!
                coord.latitude = subValue.array![1].number!
                self.coordinates = coord
            }
        }
    }
}

class CarResponse: NSObject {
    var placemarks:NSMutableArray?
    
    init(json:JSON) {
        super.init()
        self.placemarks = NSMutableArray();
        
        for (_,value):(String, JSON) in json {
            for (_,subJson):(String, JSON) in value {
                
                let car:CarItem = CarItem(json: subJson)

                self.placemarks?.add(car)
            }
            break;
        }
    }
}


