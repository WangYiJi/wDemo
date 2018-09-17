//
//  CarAnnoation.swift
//  WDemo
//
//  Created by wyj on 2018/9/16.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit
import MapKit

protocol CarAnnotationViewDelegate:NSObjectProtocol {
    func selectCar(carAnnotationView:CarAnnoationView) -> Void
    func disSelectCar(carAnnotationView:CarAnnoationView) -> Void
}

class CarAnnoationView: MKAnnotationView {

    var imageViewPop:UIImageView!
    var btnPoint:UIButton!
    var lblCarName:UILabel!

    var isSelect:Bool = false
    weak var delegate:CarAnnotationViewDelegate?
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        self.imageViewPop = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        self.imageViewPop.image = UIImage(named: "pop")
        self.imageViewPop.isHidden = true
        
        self.lblCarName = UILabel(frame: CGRect(x: 0, y: 10, width: 100, height: 21))
        self.lblCarName.backgroundColor = UIColor.clear
        self.lblCarName.font = UIFont.systemFont(ofSize: 15)
        self.lblCarName.textColor = UIColor.black
        self.lblCarName.textAlignment = .center
        self.lblCarName.isHidden = true
        
        self.btnPoint = UIButton(frame: CGRect(x: 25, y: 50, width: 50, height: 50))
        self.btnPoint.setImage(UIImage(named: "carIcon"), for: .normal)
        self.btnPoint.addTarget(self, action: #selector(didPressedCar), for: .touchUpInside)
        
        self.addSubview(self.imageViewPop)
        self.addSubview(self.btnPoint)
        self.addSubview(self.lblCarName)
        
    }
    
    @objc func didPressedCar() -> Void {
        if self.isSelect {
            self.lblCarName.isHidden = true
            self.imageViewPop.isHidden = true
            self.isSelect = false
            self.delegate?.disSelectCar(carAnnotationView: self)
        } else {
            self.lblCarName.text = (self.annotation?.title)!
            self.lblCarName.isHidden = false
            self.imageViewPop.isHidden = false
            self.isSelect = true
            self.delegate?.selectCar(carAnnotationView: self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
