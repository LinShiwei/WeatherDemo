//
//  DayInfoViewCell.swift
//  WeatherDemo
//
//  Created by Linsw on 16/8/6.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class DayInfoViewCell: UIView {

    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var dayNumber = -1 {
        didSet {
            frame = CGRect(origin: CGPoint(x: dayInfoViewCellSize.width*CGFloat(dayNumber), y: 0), size: dayInfoViewCellSize)
            
            let dataFormater = DateFormatter()
            
            dataFormater.dateStyle = DateFormatter.Style.full
            dataFormater.timeStyle = DateFormatter.Style.none
            dayLabel.text = dataFormater.string(from: Date(timeIntervalSinceNow: Double(86400*dayNumber))).components(separatedBy: ", ").first

        }
    }
    
    var temperatureMax : Int = 0 {
        didSet {
            temperatureLabel.text = String(temperatureMin) + "~" + String(temperatureMax)
        }
    }
    var temperatureMin : Int = 0 {
        didSet {
            temperatureLabel.text = String(temperatureMin) + "~" + String(temperatureMax)
        }
    }
    var weatherDescription : String = "" {
        didSet{
            weatherDescriptionLabel.text = weatherDescription
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
