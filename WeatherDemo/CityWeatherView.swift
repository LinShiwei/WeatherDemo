//
//  CityWeatherView.swift
//  WeatherDemo
//
//  Created by Linsw on 16/8/4.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit
import SwiftyJSON

let KOffSet = 273.15
struct Temperature {
    let average : Int
    let max : Int
    let min : Int
}

class CityWeatherView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var weatherJsonData : JSON? {
        didSet{
            guard let data = weatherJsonData else {return}
            if let name = data["name"].string {
                print(name)
                cityName = name
            }
            
            if let description = data["weather"][0]["description"].string{
                weatherDescription = description
            }
            
            if let main = data["main"].dictionary {

                if let temp = main["temp"]?.double, temp_max = main["temp_max"]?.double, temp_min = main["temp_min"]?.double {
                    temperature = Temperature(average: Int(temp-KOffSet), max: Int(temp_max-KOffSet), min: Int(temp_min-KOffSet))
                }
            }
            
        }
    }
    var mainWeatherInfoView : MainWeatherInfoView?
    var cityName:String = ""{
        didSet{
            mainWeatherInfoView?.cityName.text = cityName
        }
    }
    var weatherDescription:String = ""{
        didSet{
            mainWeatherInfoView?.cloud.text = weatherDescription
        }
    }
    var temperature : Temperature = Temperature(average: 0, max: 0, min: 0){
        didSet{
            let tempString = String(temperature.average)+" "+String(temperature.min)+"/"+String(temperature.max)
            mainWeatherInfoView?.degree.text = tempString
        }
    }
    
    
    func setCity(cityName:String){
        
    }
    
    override func awakeFromNib() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        guard let viewFromNib = NSBundle.mainBundle().loadNibNamed("MainWeatherInfoView", owner: self, options: nil).first as? MainWeatherInfoView else {return}
        mainWeatherInfoView = viewFromNib
        
        addSubview(mainWeatherInfoView!)
    }
}
