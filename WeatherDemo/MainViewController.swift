//
//  MainViewController.swift
//  WeatherDemo
//
//  Created by Linsw on 16/8/4.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit
//import Haneke
import Alamofire
import SwiftyJSON

class MainViewController: UIViewController {
    //MARK: Property
//    var test = false
    var citiesInTable = [String](){
        didSet{
            let defaults = UserDefaults.standard
            defaults.set(citiesInTable, forKey: "cities")
        }
    }
    
    @IBOutlet weak var cityWeatherView: CityWeatherView!
    @IBOutlet weak var cityListTable: CityListTableView!
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        citiesInTable = defaults.object(forKey: "cities") as? [String] ?? ["London","Quanzhou"]
    }
 
    // JSON Data
    fileprivate func fetchDataWithCityName(_ cityName:String) {
        guard cityName != "" else {
            print("cityName is blank ")
            return
        }
        
        
        let url = currentWeatherDataByName + cityName + APPID
        
        Alamofire.request(url).validate().responseJSON{ [unowned self] response in
            switch response.result {
            case .success:
                if let json = response.result.value{
                    print("JSON: \(json)")
                    self.cityWeatherView.weatherJsonData = JSON(json)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        let url5Day = fiveDayWeatherDataByName + cityName + APPID
        Alamofire.request(url5Day).validate().responseJSON{ [unowned self] response in
            switch response.result {
            case .success:
                if let json = response.result.value{
                    self.cityWeatherView.fiveDayJsonData = JSON(json)
                }
            case .failure(let error):
                print(error)
            }
        
        }
        
     /*
        
        let cache = Shared.JSONCache
        //        cache.removeAll()
        cache.fetch(URL: URL(string: url)!,failure:{ _ in
            DispatchQueue.main.async {
                print("fail to fetch data")
            }
        }).onSuccess { [unowned self] jsonObject in
            self.cityWeatherView.weatherJsonData = JSON(jsonObject.dictionary)
        }
        
        let url5Day = fiveDayWeatherDataByName + cityName + APPID
        let cache5Day = Shared.JSONCache
        //        cache.removeAll()
        cache5Day.fetch(URL: URL(string: url5Day)!,failure:{ _ in
            DispatchQueue.main.async {
                print("fail to fetch data")
            }
        }).onSuccess { [unowned self] jsonObject in
            self.cityWeatherView.fiveDayJsonData = JSON(jsonObject.dictionary)
        }
 */
    }
}

//MARK: UITableViewDataSource
extension MainViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityListTableCell", for: indexPath) as! CityListTableCell
        
        if (indexPath as NSIndexPath).row == tableView.numberOfRows(inSection: 0) - 1{
            cell.nameLabel.text = "+"
        }else{
            cell.nameLabel.text = citiesInTable[(indexPath as NSIndexPath).row]
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return citiesInTable.count + 1
    }

}

//MARK: UITableViewDelegate
extension MainViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cityListTableViewHeight
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if (indexPath as NSIndexPath).row == tableView.numberOfRows(inSection: 0) - 1 {
            let addCityPage = AddCityPageVC(senderView: cityListTable.cellForRow(at: indexPath)!, rootViewController: self, backgroundColor: UIColor.white)
            addCityPage.presentFromRootViewController()
            return nil
        }else{
            return indexPath
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard (indexPath as NSIndexPath).row < tableView.numberOfRows(inSection: 0) - 1 else {return}
        
        fetchDataWithCityName((cityListTable.cellForRow(at: indexPath) as! CityListTableCell).nameLabel.text!)
    
        let cell = tableView.cellForRow(at: indexPath) as! CityListTableCell
        UIView.animate(withDuration: 0.5, animations: {()-> Void in
            cell.alpha = 1.0
        })
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CityListTableCell
        UIView.animate(withDuration: 0.5, animations: {()-> Void in
            cell.alpha = 0.5
        })
    }
    
    @objc(tableView:canFocusRowAtIndexPath:) func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        
        if ((indexPath as NSIndexPath).row == tableView.numberOfRows(inSection: 0) - 1) {
            return false
        }else{
            return true
        }
    }
    
    @objc(tableView:commitEditingStyle:forRowAtIndexPath:) func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            citiesInTable.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //set default selection
        
        if (indexPath as NSIndexPath).row == 0 && tableView.indexPathForSelectedRow == nil &&  tableView.numberOfRows(inSection: 0) > 1{
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            fetchDataWithCityName((cell as! CityListTableCell).nameLabel.text!)
        }
        
        if cell.isSelected {
            cell.alpha = 1.0
        }else{
            cell.alpha = 0.5
        }
    }
}

//MARK: SelectCityForAddingDelegate
extension MainViewController: SelectCityForAddingDelegate{
    func selectedCityName(cityName:String){
        for name in citiesInTable {
            if cityName == name {
                return
            }
        }
        citiesInTable.append(cityName)
        cityListTable.reloadData()
    }
}

