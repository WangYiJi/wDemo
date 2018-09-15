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
typealias requestSuccess = (NSObject) -> ()
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

    func downloadFile(sURL:String,successBlock:@escaping requestSuccess, failBlock:@escaping requestFail) -> Void {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("locations.json")
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            //Exist Just Read From Disk
            do {
                let nsData:NSData = try NSData(contentsOfFile: fileURL.path)
                let jsonData = try JSON(data: nsData as Data)
                let carRep:CarResponse = CarResponse.init(json: jsonData)
                print(carRep)
            } catch {
                
            }
        } else {
            //Download From Server
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                
                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            Alamofire.download("https://s3-us-west-2.amazonaws.com/wunderbucket/locations.json", to: destination).response { response in
                print(response)
                do {
                    let nsData:NSData = try NSData(contentsOf: response.destinationURL!)
                    let jsonData = try JSON(data: nsData as Data)
                    let carRep:CarResponse = CarResponse.init(json: jsonData)
                    print(carRep)
                } catch {
                    
                }
            }
        }
    }
    
    
}























