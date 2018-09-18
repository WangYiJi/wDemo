//
//  CarListTableViewModel.swift
//  WDemo
//
//  Created by wyj on 2018/9/16.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit

typealias completeBlock = () -> ()

let DEFCARLIST = "carList"

protocol CarListTableViewModelDelegate:NSObjectProtocol {
    func reloadCarList()
}

class CarListTableViewModel: NSObject,UITableViewDelegate,UITableViewDataSource {
    var tableviewID:NSString = ""
    
    var carVM:CarViewModel!
    
    weak var delegate:CarListTableViewModelDelegate?
    
    private var myContext = 0
    
//    lazy var popView:PopMapView = {
//        let view:PopMapView = PopMapView()
//        view.frame = CGRect(x: 0, y: 0, width: 300, height: 400);
//        view.dismissBlock = { (popview) in
//            PopTool.sharedInstance().close(animated: true)
//        }
//        return view
//    }()
    
    
    init(identifier:NSString,viewModel:CarViewModel,tableview:UITableView) {
        super.init()
        
        self.tableviewID = identifier
        self.carVM = viewModel
        
        tableview.register(UINib.init(nibName: "CarItemCell", bundle: nil), forCellReuseIdentifier: "CarItemCell")
        
        //binding viewmodel KVO
        bindViewModel()
        
        //requestData
        self.carVM.requestCarList()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.carVM.removeObserver(self, forKeyPath: DEFCARLIST)
    }
    
    func bindViewModel() -> Void {
        self.carVM.addObserver(self, forKeyPath: DEFCARLIST, options: [.new, .old], context: &myContext)
    }
    
    
    //Tableview Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.carVM.getCarsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let carObj:CarEntity = self.carVM.carList[indexPath.row]
        let cell:CarItemCell = tableView.dequeueReusableCell(withIdentifier: "CarItemCell") as! CarItemCell
        cell.lblName.text = carObj.name
        cell.lblAddress.text = carObj.address
        cell.lblFuel.text = "\(carObj.fuel)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let poiItem:poiListItem = self.vehicleVM!.vehicleList?.poiList?.object(at: indexPath.row) as! poiListItem
//        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: poiItem.coordinate?.latitude.doubleValue ?? 0.0, longitude: poiItem.coordinate?.longitude.doubleValue ?? 0.0)
//
//        self.popView.setAnnotation(coordinate)
//        PopTool.sharedInstance().pop(self.popView, animated: true)
    }
    
}

extension CarListTableViewModel {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == DEFCARLIST {
    
            //Use Main thread call UI
            DispatchQueue.main.async { [weak self] in
                
                self?.delegate?.reloadCarList()
            }
        }
    }
}

