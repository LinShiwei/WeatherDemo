//
//  FiveDayInfoView.swift
//  WeatherDemo
//
//  Created by Linsw on 16/8/6.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

let dayCount = 5

class FiveDayInfoView: UIView {
    
    var days = [DayInfoViewCell]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
        frame = CGRect(x: cityListTableViewWidth, y: windowBounds.height - dayInfoViewCellSize.height, width: dayInfoViewCellSize.width*CGFloat(dayCount), height: dayInfoViewCellSize.height)

        
        for day in 0...dayCount - 1 {
            guard let viewFromNib = NSBundle.mainBundle().loadNibNamed("DayInfoViewCell", owner: self, options: nil).first as? DayInfoViewCell else {return}
            viewFromNib.dayNumber = day
            
            days.append(viewFromNib)
            addSubview(viewFromNib)
        }
    }}
