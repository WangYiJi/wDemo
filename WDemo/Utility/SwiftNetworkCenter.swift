//
//  SwiftNetworkCenter.swift
//  WDemo
//
//  Created by wyj on 2018/9/14.
//  Copyright © 2018 Alex. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//Request Success Block
typealias requestSuccess = () -> ()
//Request Fail Block
typealias requestFail = (String) -> ()

class ResponseBaseEntity: NSObject {
    public func fillWithJson(json:JSON) -> Void {
        for (key,value):(String,JSON) in json
        {
            //Ignore UnDefine Key
            if isIncludeKey(key: key) {
                switch value.type{
                case .string:
                    self.setValue(value.string, forKey: key)
                    break;
                case .number:
                    self.setValue(value.number, forKey: key)
                    break;
                case .dictionary:
                    self.fillWithJson(json: value)
                    break;
                case .array:
                    //
                    break;
                default:
                    break;
                }
            }
        }
    }
    
    func isIncludeKey(key:String) -> Bool {
        let mirror:Mirror = Mirror(reflecting: self)
        
        if mirror.children.count > 0 {
            for children in mirror.children {
                let propertyNameString = children.label!
                if propertyNameString == key {
                    return true
                } else {
                    //continue
                }
            }
        }
        return false
    }
}


class SwiftNetworkCenter: NSObject {

    static func downloadFile(successBlock:@escaping requestSuccess, failBlock:@escaping requestFail) -> Void {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("locations.json")
        //Download From Server
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download("https://s3-us-west-2.amazonaws.com/wunderbucket/locations.json", to: destination).response { response in
            print(response)
            do {
                let nsData:NSData = try NSData(contentsOf: response.destinationURL!)
                let jsonData = try JSON(data: nsData as Data)
                SwiftNetworkCenter.storeCarToCoreData(json: jsonData)
                successBlock()
            } catch {
                
            }
        }
    }
    
    
    static func storeCarToCoreData(json:JSON) {
        for (_,value):(String, JSON) in json {
            for (_,subJson):(String, JSON) in value {
                
                let carItem = DBHelp.shared.insertWithModelName(modelName: "CarEntity") as! CarEntity
                
                for (subKey,subValue):(String, JSON) in subJson {
                    if subKey == "address" {
                        carItem.address = subValue.string
                    } else if subKey == "engineType" {
                        carItem.engineType = subValue.string
                    } else if subKey == "exterior" {
                        carItem.exterior = subValue.string
                    } else if subKey == "fuel" {
                        carItem.fuel = (subValue.number?.int16Value)!
                    } else if subKey == "interior" {
                        carItem.interior = subValue.string
                    } else if subKey == "name" {
                        carItem.name = subValue.string
                    } else if subKey == "vin" {
                        carItem.vin = subValue.string
                    } else if subKey == "coordinates" {
                        carItem.longitude = subValue.array![0].number!.doubleValue
                        carItem.latitude = subValue.array![1].number!.doubleValue
                    }
                }
            }
        }
            DBHelp.shared.saveContext()
    }
}




/*
 let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
 let fileURL = documentsURL.appendingPathComponent("locations.json")
 
 if FileManager.default.fileExists(atPath: fileURL.path) {
 //Exist Just Read From Disk
 do {
 let nsData:NSData = try NSData(contentsOfFile: fileURL.path)
 let jsonData = try JSON(data: nsData as Data)
 let carRep:CarResponse = CarResponse.init(json: jsonData)
 successBlock(carRep)
 } catch {
 
 }
 } else {
 */


















