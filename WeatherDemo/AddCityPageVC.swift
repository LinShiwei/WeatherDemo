//
//  AddCityPageVC.swift
//  WeatherDemo
//
//  Created by Linsw on 16/8/9.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddCityPageVC: UIViewController {

    var cities = [String]()
    var filteredCities = [String]()
    
    var senderView : UITableViewCell
    let maskView = UIView()
    
    let searchTableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)
    
    var rootViewController: UIViewController!

    init(senderView : UITableViewCell,backgroundColor:UIColor){
        self.senderView = senderView
        self.maskView.backgroundColor = backgroundColor
        rootViewController = UIApplication.sharedApplication().keyWindow!.rootViewController!
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentFromRootViewController() {
        willMoveToParentViewController(rootViewController)
        rootViewController.view.addSubview(view)
        rootViewController.addChildViewController(self)
        didMoveToParentViewController(rootViewController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.registerNib(UINib(nibName: "SearchCityTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchCityCell")
        searchTableView.frame = CGRect(x: 200, y: 100, width: 400, height: 500)
        searchTableView.tableHeaderView = searchController.searchBar
        searchTableView.delegate = self
        searchTableView.dataSource  = self
        searchTableView.backgroundColor = UIColor.redColor()
        view.addSubview(searchTableView)
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self

        initCitiesFromJSON()
        
    }
    
    override func loadView() {
        super.loadView()
        
        maskView.frame = windowBounds
        maskView.alpha = 0.5
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddCityPageVC.tapToReturn(_:)))
        maskView.addGestureRecognizer(tapGestureRecognizer)
        view.insertSubview(maskView, atIndex: 0)
        
        animateEntry()
    }
    
    private func animateEntry(){
        UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseInOut], animations: {[unowned self]() -> Void in
            }, completion: nil)
        
        UIView.animateWithDuration(0.4, delay: 0.03, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseInOut], animations: {[unowned self]() -> Void in
           
            }, completion: nil)
        
    }
    
    private func dismissViewController() {
   
        dispatch_async(dispatch_get_main_queue(), {
            UIView.animateWithDuration(0.1){[unowned self]() in
            }
            UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseInOut], animations: {[unowned self]() in
                }, completion: {(finished) in
                    self.willMoveToParentViewController(nil)
                    self.view.removeFromSuperview()
                    self.removeFromParentViewController()
            })
        })
    }
    
    func tapToReturn(sender: UITapGestureRecognizer){
        dismissViewController()
    }
    
    private func initCitiesFromJSON(){
        if let path = NSBundle.mainBundle().pathForResource("CN_city", ofType: "txt"),let stringData = try? String(contentsOfFile: path, usedEncoding: nil){
            let lines = stringData.componentsSeparatedByString("\n")
            for line in lines[0...5] {
                if let dataFromString = line.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false),let cityName = JSON(data:dataFromString)["name"].string{
                    cities.append(cityName)
                }
            }
        }
    }
    
    private func filterContentForSearchText(searchText: String){
        filteredCities = cities.filter({ ( city : String)-> Bool in
            return city.lowercaseString.containsString(searchText.lowercaseString)
        })
        searchTableView.reloadData()
    }
}

extension AddCityPageVC : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let controller = rootViewController as? MainViewController else { return }
//        controller.
        let cellCount = controller.cityListTable.numberOfRowsInSection(0)
        print(cellCount)
        controller.cityListTable.insertRowsAtIndexPaths([NSIndexPath(forRow: cellCount-1, inSection: 0)], withRowAnimation: .Automatic)
    }
}

extension AddCityPageVC : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredCities.count
        }else{
            return cities.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchCityCell", forIndexPath: indexPath) as! SearchCityTableViewCell
        if searchController.active && searchController.searchBar.text != "" {
            cell.cityNameLabel.text = filteredCities[indexPath.row]
        }else{
            cell.cityNameLabel.text = cities[indexPath.row]
        }
        return cell
    }
}

extension AddCityPageVC : UISearchBarDelegate {
    
}

extension AddCityPageVC : UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
