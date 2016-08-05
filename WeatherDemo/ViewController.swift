//
//  ViewController.swift
//  WeatherDemo
//
//  Created by Linsw on 16/8/4.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit
import Haneke
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var cityWeatherView: CityWeatherView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = currentWeatherDataByName + "London" + APPID
        let cache = Shared.JSONCache
//        cache.removeAll()
        cache.fetch(URL: NSURL(string: url)!,failure:{ _ in
            dispatch_async(dispatch_get_main_queue()) {
                print("fail to fetch data")
            }
        }).onSuccess { [unowned self] jsonObject in
            self.cityWeatherView.weatherJsonData = JSON(jsonObject.dictionary)
            print(self.cityWeatherView.weatherJsonData)
        }
        
        print(url)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

