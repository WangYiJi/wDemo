//
//  MapViewController.swift
//  WDemo
//
//  Created by wyj on 2018/9/14.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,CarMapViewModelDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var mapViewModel:CarMapViewModel!
    var carVM:CarViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Map"
        self.mapView.showsUserLocation = true
        self.mapViewModel = CarMapViewModel(carViewModel: self.carVM, delegateObj: self)
        self.mapView.delegate = self.mapViewModel


        addBackButton()
        // Do any additional setup after loading the view.
    }

    func addBackButton() -> Void {
        let backBar = UIBarButtonItem.init(title: "Back",
                                           style: .plain, target: self,
                                           action: #selector(didPressedBack))
        self.navigationItem.leftBarButtonItem = backBar
    }

    @objc func didPressedBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getMapView() -> MKMapView {
        return self.mapView
    }

}
