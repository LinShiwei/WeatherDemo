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
    @IBOutlet weak var cityListTable: UITableView!
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
        }
        
        let url5Day = fiveDayWeatherDataByName + "London" + APPID
        let cache5Day = Shared.JSONCache
//        cache.removeAll()
        cache5Day.fetch(URL: NSURL(string: url5Day)!,failure:{ _ in
            dispatch_async(dispatch_get_main_queue()) {
                print("fail to fetch data")
            }
        }).onSuccess { [unowned self] jsonObject in
            self.cityWeatherView.fiveDayJsonData = JSON(jsonObject.dictionary)
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController:UITableViewDataSource{
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CityListTableCell", forIndexPath: indexPath)
        
        return cell

    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 5
    }

}

extension ViewController:UITableViewDelegate {
    
}

