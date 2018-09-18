//
//  MainListViewController.swift
//  WDemo
//
//  Created by wyj on 2018/9/14.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit

class MainListViewController: UIViewController,CarListTableViewModelDelegate {
    var carListTableviewModel:CarListTableViewModel!
    var carVM:CarViewModel!
    
    @IBOutlet weak var mainTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Car List"

        let rightBar = UIBarButtonItem.init(title: "Map",
                                            style: .plain, target: self,
                                            action: #selector(didPressedMap))
        self.navigationItem.rightBarButtonItem = rightBar
        
        self.carVM = CarViewModel()
        
        self.carListTableviewModel = CarListTableViewModel.init(identifier: "CarItemCell",
                                                                viewModel: self.carVM,
                                                                tableview: self.mainTableview)
        
        self.carListTableviewModel.delegate = self;
        
        self.mainTableview.delegate = self.carListTableviewModel
        self.mainTableview.dataSource = self.carListTableviewModel
    }

    
    @objc func didPressedMap() {
        let mapVC:MapViewController = MapViewController.init(nibName:"MapViewController",bundle:nil)
        mapVC.carVM = self.carVM
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    //viewModel delegate
    func reloadCarList() {
        self.mainTableview.reloadData()
    }
}
