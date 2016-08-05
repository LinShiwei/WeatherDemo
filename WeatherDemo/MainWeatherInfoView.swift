//
//  MainWeatherInfoView.swift
//  WeatherDemo
//
//  Created by Linsw on 16/8/5.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class MainWeatherInfoView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var cityName: UILabel!

    @IBOutlet weak var degree: UILabel!
    @IBOutlet weak var cloud: UILabel!
    @IBOutlet weak var date: UILabel!
}