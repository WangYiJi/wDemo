//
//  CarItemCell.swift
//  WDemo
//
//  Created by wyj on 2018/9/16.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit

class CarItemCell: UITableViewCell {


    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var fuel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
