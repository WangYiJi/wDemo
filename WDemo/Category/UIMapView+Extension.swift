//
//  UIMapView+Extension.swift
//  WDemo
//
//  Created by wyj on 2018/9/17.
//  Copyright © 2018 Alex. All rights reserved.
//

import Foundation

import MapKit

extension MKMapView {
    //zoom level
    var zoomLevel: Int {
        //get zoom level
        get {
            return Int(log2(360 * (Double(self.frame.size.width/256)
                / self.region.span.longitudeDelta)) + 1)
        }
        //Setting zoom level
        set (newZoomLevel){
            setCenterCoordinate(coordinate: self.centerCoordinate, zoomLevel: newZoomLevel,
                                animated: false)
        }
    }
    
    //Call when setting zoom
    private func setCenterCoordinate(coordinate: CLLocationCoordinate2D, zoomLevel: Int,
                                     animated: Bool){
        let span = MKCoordinateSpanMake(0,
                                        360 / pow(2, Double(zoomLevel)) * Double(self.frame.size.width) / 256)
        setRegion(MKCoordinateRegionMake(centerCoordinate, span), animated: animated)
    }
}
