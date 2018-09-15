//
//  ViewController.swift
//  WDemo
//
//  Created by wyj on 2018/9/14.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = "​https://s3-us-west-2.amazonaws.com/wunderbucket/locations.json"
        
        let str = String(utf8String: url.cString(using: .utf8)!)
        
        let request:SwiftNetworkCenter = SwiftNetworkCenter()
        request.downloadFile(sURL: str!, successBlock: { (response) in
            print(response)
        }) { (error) in
            print(error)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

