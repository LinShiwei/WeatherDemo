//
//  CityListTableCell.swift
//  WeatherDemo
//
//  Created by Linsw on 16/8/8.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class CityListTableCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
