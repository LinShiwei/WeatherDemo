//
//  SearchCityTableViewCell.swift
//  WeatherDemo
//
//  Created by Linsw on 16/8/9.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class SearchCityTableViewCell: UITableViewCell {

    @IBOutlet weak var cityNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
