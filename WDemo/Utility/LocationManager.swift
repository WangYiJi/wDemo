//
//  LocationManager.swift
//  WDemo
//
//  Created by wyj on 2018/9/16.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationManagerDelegate:NSObjectProtocol {
    func getCoordinateDelegateSuccess() -> Void
    func getCoordinateDelegateFailed() -> Void
}

class LocationManager: NSObject,CLLocationManagerDelegate {
    var lManager:CLLocationManager!
    var userCoordinate:CLLocationCoordinate2D?
    weak var delegate:LocationManagerDelegate?
    var userExist = false
    
    static let sharedInstance = LocationManager()
    
    private override init() {
        super.init()
    }
    
    func startUpdateLocation() -> Void {
        if self.lManager == nil {
            self.lManager = CLLocationManager.init()
            self.lManager.delegate = self
        }
        self.lManager.requestWhenInUseAuthorization()
        self.lManager.startUpdatingLocation()
    }
    
    //LocationManager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            let locationItem:CLLocation = locations[0]
            self.userCoordinate = locationItem.coordinate
            self.userExist = true
            self.lManager.stopUpdatingLocation()
            self.delegate?.getCoordinateDelegateSuccess()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.userExist = false
        self.delegate?.getCoordinateDelegateFailed()
    }
    
    
    
    
    
    
    
    
    
    
    
}
