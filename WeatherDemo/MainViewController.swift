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

class MainViewController: UIViewController {

    
    var citiesInTable = [String](){
        didSet{
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(citiesInTable, forKey: "cities")
        }
    }
    
    @IBOutlet weak var cityWeatherView: CityWeatherView!
    @IBOutlet weak var cityListTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        citiesInTable = defaults.objectForKey("cities") as? [String] ?? ["London","Quanzhou"]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func fetchDataWithCityName(cityName:String) {
        guard cityName != "" else {
            print("cityName is blank ")
            return
        }
        
        let url = currentWeatherDataByName + cityName + APPID
        let cache = Shared.JSONCache
        //        cache.removeAll()
        cache.fetch(URL: NSURL(string: url)!,failure:{ _ in
            dispatch_async(dispatch_get_main_queue()) {
                print("fail to fetch data")
            }
        }).onSuccess { [unowned self] jsonObject in
            self.cityWeatherView.weatherJsonData = JSON(jsonObject.dictionary)
        }
        
        let url5Day = fiveDayWeatherDataByName + cityName + APPID
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
}

extension MainViewController:UITableViewDataSource{
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CityListTableCell", forIndexPath: indexPath) as! CityListTableCell
        
        if indexPath.row == tableView.numberOfRowsInSection(0) - 1{
            cell.nameLabel.text = "+"
        }else{
            cell.nameLabel.text = citiesInTable[indexPath.row]
        }
        
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return citiesInTable.count + 1
    }

}

extension MainViewController:UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.row == tableView.numberOfRowsInSection(0) - 1 {
            let addCityPage = AddCityPageVC(senderView: cityListTable.cellForRowAtIndexPath(indexPath)!, backgroundColor: UIColor.blueColor())
            addCityPage.presentFromRootViewController()
            return nil
        }else{
            return indexPath
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard indexPath.row < tableView.numberOfRowsInSection(0) - 1 else {return}
        
        fetchDataWithCityName((cityListTable.cellForRowAtIndexPath(indexPath) as! CityListTableCell).nameLabel.text!)
    
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CityListTableCell
        UIView.animateWithDuration(0.5, animations: {()-> Void in
            cell.alpha = 1.0
        })
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CityListTableCell
        UIView.animateWithDuration(0.5, animations: {()-> Void in
            cell.alpha = 0.5
        })
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if (indexPath.row == tableView.numberOfRowsInSection(0) - 1) {
            return false
        }else{
            return true
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            citiesInTable.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.reloadData()
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //set default selection
        if indexPath.row == 0 && tableView.indexPathForSelectedRow == nil &&  tableView.numberOfRowsInSection(0) > 1{
            tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
            fetchDataWithCityName((cell as! CityListTableCell).nameLabel.text!)
        }
        
        if cell.selected {
            cell.alpha = 1.0
        }else{
            cell.alpha = 0.5
        }
    }
}

extension MainViewController: SelectCityForAddingDelegate{
    func selectedCityName(cityName cityName:String){
        for name in citiesInTable {
            if cityName == name {
                return
            }
        }
        citiesInTable.append(cityName)
        cityListTable.reloadData()
    }
}

