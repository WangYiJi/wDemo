//
//  CarViewModel.swift
//  WDemo
//
//  Created by wyj on 2018/9/15.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit

class CarViewModel: NSObject {
    @objc dynamic var carList:Array<CarEntity> = []
    
    public func getCarsCount() -> NSInteger {
        return self.carList.count
    }
    
    public func requestCarList() ->Void {
        
        let result = DBHelp.shared.searchWithName(modelName: "CarEntity")
        if result.count > 0 {
            //Get Result from database
            self.carList = result as! Array<CarEntity>
        } else {
            //Fetch data from Network
            SwiftNetworkCenter.downloadFile(successBlock: { [weak self] in
                let result = DBHelp.shared.searchWithName(modelName: "CarEntity")
                self?.carList = result as! Array<CarEntity>
            }) { (error) in
                print(error)
            }
        }
    }

}
