//
//  CarViewModel.swift
//  WDemo
//
//  Created by wyj on 2018/9/15.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit

class CarViewModel: NSObject {
    @objc dynamic var carsResponse:CarResponse?
    
    public func getCarsCount() -> NSInteger {
        return self.carsResponse?.placemarks?.count ?? 0
    }
    
    public func requestCarList() ->Void {
        SwiftNetworkCenter.downloadFile(successBlock: { (response) in
            self.carsResponse = response as? CarResponse
        }) { (error) in
            print(error)
        }
    }
}
