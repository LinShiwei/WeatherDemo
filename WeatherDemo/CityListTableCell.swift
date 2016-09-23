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
        backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
//    func fadeInAnimation(){
//        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
//        fadeInAnimation.fromValue = 0.5
//        fadeInAnimation.toValue = 1.0
//        fadeInAnimation.duration = 0.5
//
//        
//    }
}
