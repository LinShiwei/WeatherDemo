//
//  CityListTableView.swift
//  WeatherDemo
//
//  Created by Linsw on 16/9/5.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class CityListTableView: UITableView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
    }
}
