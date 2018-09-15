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

class CarsItem: NSObject {
    var address:String?
    var engineType:String?
    var exterior:String?
    var fuel:NSNumber?
    var interior:String?
    var name:String?
    var vin:String?
    var coordinates:coordinate?
}

class CarResponse: ResponseBaseEntity {
    var placemarks:NSMutableArray?
    
    init(json:JSON) {
        super.init()
        self.placemarks = NSMutableArray()
        for (key,value):(String,JSON) in json { //array
            for (subKey,subValue):(String,JSON) in value { //dic
               
                let carItem:CarsItem = CarsItem()
                
                for(dicKey,dicValue):(String,JSON) in subValue {
                    switch dicValue.type {
                    case .string:
                        carItem.setValue(dicValue.string, forKey: dicKey)
                        break;
                    case .number:
                        carItem.setValue(dicValue.number, forKey: dicKey)
                        break;
                    case .array:
                        let location:coordinate = coordinate()
                        //                    location.latitude = subValue.array![0]
                    //                    location.longitude = subValue.array![1]
                    default:
                        break;
                    }
                }
                self.placemarks?.add(carItem)
            }
        }
    }
}


