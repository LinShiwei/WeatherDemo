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
    //MARK: Property
    var mainWeatherInfoView : MainWeatherInfoView?
    var fiveDayInfoView : FiveDayInfoView?

    var weatherJsonData : JSON? {
        didSet{
            guard let data = weatherJsonData else {return}
            print("getData")
            if let name = data["name"].string {
                cityName = name
            }else{
                print("[lsw] failed to get name data from json")
            }
            
            if let description = data["weather"][0]["description"].string{
                weatherDescription = description
            }else{
                print("[lsw] failed to get description data from json")
            }
            
            if let main = data["main"].dictionary {

                if let temp = main["temp"]?.double, temp_max = main["temp_max"]?.double, temp_min = main["temp_min"]?.double {
                    temperature = Temperature(average: Int(temp-KOffSet), max: Int(temp_max-KOffSet), min: Int(temp_min-KOffSet))
                }else{
                    print("[lsw] failed to get temperature data from json")
                }
            }else{
                print("[lsw] failed to get main data from json")
            }
            
        }
    }
    
    var fiveDayJsonData : JSON? {
        didSet{
            guard let data = fiveDayJsonData else {return}
            print("getfiveData")

            if let list = data["list"].array {
                assert(4*8...5*8 ~= list.count)
                for dayNumber in 0...4 {
                    let dayData = list[1+8*dayNumber]
                    let temperatureMin = Int(dayData["main"]["temp_min"].double! - 273.15)
                    let temperatureMax = Int(dayData["main"]["temp_max"].double! - 273.15)
                    
                    fiveDayInfoView!.days[dayNumber].temperatureMax = temperatureMax
                    fiveDayInfoView!.days[dayNumber].temperatureMin = temperatureMin
                    
                    fiveDayInfoView!.days[dayNumber].weatherDescription = dayData["weather"][0]["description"].string!
                }
                let dataFormater = NSDateFormatter()
                dataFormater.dateStyle = NSDateFormatterStyle.FullStyle
                dataFormater.timeStyle = NSDateFormatterStyle.NoStyle
                day = dataFormater.stringFromDate(NSDate())
            }else{
                print("[lsw] failed to get list data from json")
            }
        }
    }
    
    var day : String = "" {
        didSet{
            mainWeatherInfoView?.date.text = day
        }
    }
    
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
    //MARK: Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        guard let mainView = NSBundle.mainBundle().loadNibNamed("MainWeatherInfoView", owner: self, options: nil).first as? MainWeatherInfoView else {return}
        mainWeatherInfoView = mainView
        addSubview(mainWeatherInfoView!)
        
        guard let fiveDayView = NSBundle.mainBundle().loadNibNamed("FiveDayInfoView", owner: self, options: nil).first as? FiveDayInfoView else {return}
        fiveDayInfoView = fiveDayView
        addSubview(fiveDayInfoView!)
    }
}
