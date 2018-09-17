//
//  CarMapViewModel.swift
//  WDemo
//
//  Created by wyj on 2018/9/16.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit
import MapKit

protocol CarMapViewModelDelegate:NSObjectProtocol {
    func getMapView() -> MKMapView
}

class CarMapViewModel: NSObject,LocationManagerDelegate,CarAnnotationViewDelegate {
    var bIsSelected:Bool = false
    var selectPoint:CLLocationCoordinate2D?
    var lastRemoveAnnotation:Array<MKAnnotation>?
    
    func getCoordinateDelegateSuccess() {
        setMapWithCenterCoordinate(coordinate: LocationManager.sharedInstance.userCoordinate!)
    }
    
    func getCoordinateDelegateFailed() {
        //When faild use germany location
        let germanyCoordinate = CLLocationCoordinate2DMake(10.01423,53.59376000000)
        setMapWithCenterCoordinate(coordinate: germanyCoordinate)
    }
    
    var carVM:CarViewModel!
    
    weak var delegate:CarMapViewModelDelegate?
    
    init(carViewModel:CarViewModel,delegateObj:CarMapViewModelDelegate) {
        super.init()
        self.carVM = carViewModel
        self.delegate = delegateObj
        if self.carVM.carsResponse != nil {
            updateAnnotation()
        } else {
            self.carVM.requestCarList()
        }
        getUserLocation()
    }
    
    func getUserLocation() -> Void {
        if LocationManager.sharedInstance.userExist {
            //User Location Exist. Center on Map
            setMapWithCenterCoordinate(coordinate: LocationManager.sharedInstance.userCoordinate!)
        } else {
            //User Location Not Exist. Start Updata
            LocationManager.sharedInstance.delegate = self
            LocationManager.sharedInstance.startUpdateLocation()
        }
    }
    
    //MARK:- Map Method
    func setMapWithCenterCoordinate(coordinate:CLLocationCoordinate2D) -> Void {
        self.delegate?.getMapView().setCenter(coordinate, animated: true)
        self.delegate?.getMapView().zoomLevel = 15

    }
    
    func updateAnnotation() -> Void {
        let annotationArray:Array<MKAnnotation> = Array.init()
        
        removeAllAnnotations()
        
        for car in (self.carVM.carsResponse?.placemarks)! {
            let carObj:CarItem = car as! CarItem
            let annotationObj = MKPointAnnotation()
            annotationObj.coordinate = CLLocation(latitude: (carObj.coordinates?.latitude.doubleValue)!,
                                                  longitude: (carObj.coordinates?.longitude.doubleValue)!).coordinate
            annotationObj.title = carObj.name
            self.delegate?.getMapView().addAnnotation(annotationObj)
        }
        self.delegate?.getMapView().addAnnotations(annotationArray)
        print("updateAnnotation")
    }
    
    func removeAllAnnotations() -> Void {
        let existAnnotation = self.delegate?.getMapView().annotations
        self.delegate?.getMapView().removeAnnotations(existAnnotation!)
    }
}


extension CarMapViewModel:MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else {
            let identifier = "item"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? CarAnnoationView
            
            if annotationView == nil {
                annotationView = CarAnnoationView(annotation: annotation, reuseIdentifier: identifier)
            } else {
                annotationView?.annotation = annotation
            }
            
            annotationView?.canShowCallout = false
            annotationView?.delegate = self

            print("viewFor annotation")
            return annotationView
        }
    }

    func selectCar(carAnnotationView: CarAnnoationView) {

        if self.lastRemoveAnnotation != nil {
            self.lastRemoveAnnotation?.removeAll()
        } else {
            self.lastRemoveAnnotation = Array.init()
        }
        self.selectPoint = nil
        self.selectPoint = carAnnotationView.annotation?.coordinate
        for item in (self.delegate?.getMapView().annotations)! {
            if item.coordinate.latitude != self.selectPoint?.latitude && item.coordinate.longitude != self.selectPoint?.longitude {
                self.lastRemoveAnnotation?.append(item)
            }
        }
        self.delegate?.getMapView().removeAnnotations(self.lastRemoveAnnotation!)
    }
    
    func disSelectCar(carAnnotationView: CarAnnoationView) {
        self.delegate?.getMapView().addAnnotations(self.lastRemoveAnnotation!)
    }
    
    func isSelectPoint(point:CLLocationCoordinate2D) -> Bool {
        if point.latitude == self.selectPoint?.latitude &&
            point.longitude == self.selectPoint?.longitude {
            return true
        } else {
            return false
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
