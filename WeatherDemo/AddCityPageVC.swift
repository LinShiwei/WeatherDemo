//
//  AddCityPageVC.swift
//  WeatherDemo
//
//  Created by Linsw on 16/8/9.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol SelectCityForAddingDelegate: class {
    func selectedCityName(cityName _:String)
}

class AddCityPageVC: UIViewController {

    var cities = [String]()
    var filteredCities = [String]()
    
    var senderView : UITableViewCell
    let maskView = UIView()
    
    let searchTableView = UITableView()
    var searchController : CitySearchController!
    
    var rootViewController: UIViewController!

    var delegate : SelectCityForAddingDelegate?
    
    init(senderView : UITableViewCell,backgroundColor:UIColor){
        self.senderView = senderView
        self.maskView.backgroundColor = backgroundColor
        rootViewController = UIApplication.sharedApplication().keyWindow!.rootViewController!
        
        if let controller = rootViewController as? MainViewController{
            delegate = controller
        }else{
            print("fater error : AddCityPageVC's rootViewController is not MainViewController")
        }
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
        configureSearchController()
        
        configureSearchTableView()
        
        initCitiesFromJSON()
    }
    
    private func configureSearchTableView(){
        searchTableView.registerNib(UINib(nibName: "SearchCityTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchCityCell")
        searchTableView.frame = CGRect(x: 200, y: 144, width: 400, height: 500)
        searchTableView.delegate = self
        searchTableView.dataSource  = self
        searchTableView.backgroundColor = UIColor.redColor()
        
        view.addSubview(searchTableView)
    }
    
    private func configureSearchController(){
        let barFrame = CGRect(x: 200, y: 100, width: 400, height: 44)
        searchController = CitySearchController(searchResultsController: nil,searchBarFrame: barFrame, searchBarTintColor: UIColor.purpleColor())
        //        searchController.searchBar.sizeToFit()
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchDelegate = self
       
        view.addSubview(searchController.citySearchBar)
       
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
           
            }, completion: {[unowned self](finished) in
                self.searchController.citySearchBar.becomeFirstResponder()
        })
        
    }
    
    private func dismissViewController() {
        searchController.active = false
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
        if let path = NSBundle.mainBundle().pathForResource("CN_city_sorted", ofType: "txt"),let stringData = try? String(contentsOfFile: path, usedEncoding: nil){
            let lines = stringData.componentsSeparatedByString("\n")
            for line in lines {
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
        guard rootViewController is MainViewController else { return }

        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? SearchCityTableViewCell {
            delegate?.selectedCityName(cityName: cell.cityNameLabel.text!)
        }
    }
}

extension AddCityPageVC : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.citySearchBar.text != "" {
            return filteredCities.count
        }else{
            return cities.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchCityCell", forIndexPath: indexPath) as! SearchCityTableViewCell
        if searchController.citySearchBar.text != "" {
            cell.cityNameLabel.text = filteredCities[indexPath.row]
        }else{
            cell.cityNameLabel.text = cities[indexPath.row]
        }
        return cell
    }
}

extension AddCityPageVC : CitySearchControllerDelegate {
    func didChangeSearchTextInSearchBar(searchBar: CitySearchBar, searchText: String) {
        filterContentForSearchText(searchBar.text!)
    }
}