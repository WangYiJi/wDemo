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
    private var myContext = 0
    
    func getCoordinateDelegateSuccess() {
        setMapWithCenterCoordinate(coordinate: LocationManager.sharedInstance.userCoordinate!)
    }
    
    func getCoordinateDelegateFailed() {
        //Will display all point visible
    }
    
    var carVM:CarViewModel!
    
    weak var delegate:CarMapViewModelDelegate?
    
    init(carViewModel:CarViewModel,delegateObj:CarMapViewModelDelegate) {
        super.init()
        self.carVM = carViewModel
        self.delegate = delegateObj
        //Don't have to get data, because after list view, The data already exist
        loadExistCars()
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
        self.delegate?.getMapView().zoomLevel = 10

    }
    
    func loadExistCars() -> Void {
        displayCarOnMap(carList: self.carVM.carList)
    }
    
    func displayCarOnMap(carList:Array<CarEntity>) {
        var annotationArray:Array<MKAnnotation> = Array.init()
        
        //removeAllAnnotations()
        
        for carObj in carList {
            let annotationObj = MKPointAnnotation()
            annotationObj.coordinate = CLLocation(latitude: carObj.latitude,
                                                  longitude: carObj.longitude).coordinate
            annotationObj.title = carObj.name
            annotationArray.append(annotationObj)
        }
        self.delegate?.getMapView().addAnnotations(annotationArray)
        
        if !LocationManager.sharedInstance.userExist {
            let first = (annotationArray.first?.coordinate)!
            //can't got user location, set visible regoin
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                self.setvisibleDisplay(point: first)
            }
        }
    }
    
    func setvisibleDisplay(point:CLLocationCoordinate2D) -> Void {
        let region = MKCoordinateRegionMakeWithDistance(point, 3000, 3000)
        self.delegate?.getMapView().setRegion(region, animated: false)
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
