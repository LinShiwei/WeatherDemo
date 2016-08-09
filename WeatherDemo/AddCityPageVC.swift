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
    var senderView : UITableViewCell
    let maskView = UIView()
    
//    let searchTableView = UITableView()
    let searchController = UISearchController(searchResultsController: UITableViewController())
    
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
//        searchTableView.registerNib(UINib(nibName: "SearchCityTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchCityCell")
//        searchTableView.frame = CGRect(x: 200, y: 100, width: 400, height: 500)
//        searchTableView.tableHeaderView = searchController.searchBar
//        searchTableView.delegate = self
//        searchTableView.dataSource  = self
//        searchTableView.backgroundColor = UIColor.redColor()
//        view.addSubview(searchTableView)
//        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        if let controller = searchController.searchResultsController as? UITableViewController, let table = controller.tableView{
            table.delegate = self
            table.dataSource = self
            table.registerNib(UINib(nibName: "SearchCityTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchCityCell")
            table.backgroundColor = UIColor.redColor()
        }
        
//        initCitiesFromJSON()
    }
    
    override func loadView() {
        super.loadView()
        
        maskView.frame = windowBounds
        maskView.alpha = 0.5
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapToReturn:")
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
        if let path = NSBundle.mainBundle().pathForResource("city.list", ofType: "json"),let stringData = try? String(contentsOfFile: path, usedEncoding: nil){
            let lines = stringData.componentsSeparatedByString("\n")
            if let dataFromString = lines[0].dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false),let cityName = JSON(data:dataFromString)["name"].string{
                    cities.append(cityName)
            }
        }
    }
}

extension AddCityPageVC : UITableViewDelegate {
    
}

extension AddCityPageVC : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchCityCell", forIndexPath: indexPath)
        
        return cell
    }
}

extension AddCityPageVC : UISearchBarDelegate {
    
}

extension AddCityPageVC : UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        let searchBar = searchController.searchBar
//        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
//        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}
