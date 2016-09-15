//
//  AddCityPageVC.swift
//  WeatherDemo
//
//  Created by Linsw on 16/8/9.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

protocol SelectCityForAddingDelegate: class {
    func selectedCityName(cityName _:String)
}

class AddCityPageVC: UIViewController {

    //MARK: Property
    private var cities = [String]()
    private var filteredCities = [String]()
    
    private var senderView : UITableViewCell?
    private let maskView = UIView()
    
    let searchTableView = UITableView()
    var searchController : CitySearchController!
    
    private var rootViewController : UIViewController!

    var delegate : SelectCityForAddingDelegate?

    //MARK: Life cycle
    init(senderView : UITableViewCell?, rootViewController rootVC:UIViewController, backgroundColor:UIColor){
        self.senderView = senderView
        self.maskView.backgroundColor = backgroundColor
        
        rootViewController = rootVC
        
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
    
    override func loadView() {
        super.loadView()
        configureSearchController()
        configureSearchTableView()
        configureMaskView()
        
        animateEntry()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCities()
    }
    
    //MARK: Configure view & viewController
    private func  configureMaskView(){
        maskView.frame = windowBounds
        maskView.alpha = 0.0
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddCityPageVC.tapToReturn(_:)))
        maskView.addGestureRecognizer(tapGestureRecognizer)
        view.insertSubview(maskView, atIndex: 0)
    }
    
    private func configureSearchTableView(){
        searchTableView.registerNib(UINib(nibName: "SearchCityTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchCityCell")
        searchTableView.frame = searchTableViewFrame
        searchTableView.delegate = self
        searchTableView.dataSource  = self
        searchTableView.backgroundColor = UIColor.redColor()
        searchTableView.alpha = 0
        view.addSubview(searchTableView)
    }
    
    private func configureSearchController(){
        searchController = CitySearchController(searchResultsController: nil,searchBarFrame: searchControllerFrame, searchBarTintColor: UIColor.purpleColor())
        //        searchController.searchBar.sizeToFit()
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchDelegate = self
        searchController.citySearchBar.alpha = 0
        view.addSubview(searchController.citySearchBar)
       
    }

    //MARK: Animation
    private func animateEntry(){
        UIView.animateWithDuration(0.6, delay: 0.0, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseInOut], animations: {[unowned self]() -> Void in
            self.searchController.citySearchBar.alpha = 1
            self.searchTableView.alpha = 1
        
            }, completion: {(finished) in
                print("AniateEntry finished")
        })
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseInOut], animations: {[unowned self]() -> Void in
            self.maskView.alpha = 0.5
            
            }, completion: {[unowned self](finished) in
                self.searchController.citySearchBar.becomeFirstResponder()
        })
        
    }
    
    private func dismissViewController() {
        dispatch_async(dispatch_get_main_queue(), {
            UIView.animateWithDuration(0.3, delay: 0.0, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseInOut], animations: {[unowned self]() -> Void in
                
                self.searchTableView.alpha = 0.0
                self.searchController.citySearchBar.alpha = 0.0
                
                }, completion: {[unowned self](finished) in
                    self.searchController.citySearchBar.resignFirstResponder()
            })
            UIView.animateWithDuration(0.5, delay: 0, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseInOut], animations: {[unowned self]() in
                self.maskView.alpha = 0.0
                }, completion: {[unowned self](finished) in
                    self.willMoveToParentViewController(nil)
                    self.view.removeFromSuperview()
                    self.removeFromParentViewController()
            })
        })
    }

    //MARK: Data
    private func initCities(){
    //Here provide two ways to initCities. Choose one of them and disable the other one.
        initCitiesFromCoreData()
//        initCitiesFromJSON()
    }
    
    private func initCitiesFromCoreData(){
        var objects = [NSManagedObject]()
        let managedContext = getManagedContext()
        let fetchRequest = NSFetchRequest(entityName: "City")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            objects = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        if objects.count > 0 {
            for object in objects {
                cities.append(object.valueForKey("name") as! String)
            }
        }else{
            initCitiesFromJSON()
            saveCitiesInCoreData(withManagedContext: managedContext)
        }
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
    
    private func saveCitiesInCoreData(withManagedContext managedContext:NSManagedObjectContext){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){[unowned self] in
            let entity = NSEntityDescription.entityForName("City", inManagedObjectContext:managedContext)
            for city in self.cities {
                let cityObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                cityObject.setValue(city, forKey: "name")
                
            }
            do {
                try managedContext.save()
            }
            catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    
    private func filterContentForSearchText(searchText: String){
        filteredCities = cities.filter({ ( city : String)-> Bool in
            return city.lowercaseString.containsString(searchText.lowercaseString)
        })
    
        searchTableView.reloadData()
    }
    
    //MARK: Helper
    func tapToReturn(sender: UITapGestureRecognizer){
        dismissViewController()
    }
    
    func getManagedContext()->NSManagedObjectContext{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }
}

//MARK: UITableViewDelegate
extension AddCityPageVC : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard rootViewController is MainViewController else { return }

        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? SearchCityTableViewCell {
            delegate?.selectedCityName(cityName: cell.cityNameLabel.text!)
        }
    }
}

//MARK: UITabelViewDataSource
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

//MARK: CitySearchControllerDelegate
extension AddCityPageVC : CitySearchControllerDelegate {
    func didChangeSearchTextInSearchBar(searchBar: CitySearchBar, searchText: String) {
        filterContentForSearchText(searchText)
    }
}

