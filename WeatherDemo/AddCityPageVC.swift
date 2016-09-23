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
    fileprivate var cities = [String]()
    fileprivate var filteredCities = [String]()
    
    fileprivate var senderView : UITableViewCell?
    fileprivate let maskView = UIView()
    
    let searchTableView = UITableView()
    var searchController : CitySearchController!
    
    fileprivate var rootViewController : UIViewController!

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
        willMove(toParentViewController: rootViewController)
        rootViewController.view.addSubview(view)
        rootViewController.addChildViewController(self)
        didMove(toParentViewController: rootViewController)
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
    fileprivate func  configureMaskView(){
        maskView.frame = windowBounds
        maskView.alpha = 0.0
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddCityPageVC.tapToReturn(_:)))
        maskView.addGestureRecognizer(tapGestureRecognizer)
        view.insertSubview(maskView, at: 0)
    }
    
    fileprivate func configureSearchTableView(){
        searchTableView.register(UINib(nibName: "SearchCityTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchCityCell")
        searchTableView.frame = searchTableViewFrame
        searchTableView.delegate = self
        searchTableView.dataSource  = self
        searchTableView.backgroundColor = UIColor.red
        searchTableView.alpha = 0
        view.addSubview(searchTableView)
    }
    
    fileprivate func configureSearchController(){
        searchController = CitySearchController(searchResultsController: nil,searchBarFrame: searchControllerFrame, searchBarTintColor: UIColor.purple)
        //        searchController.searchBar.sizeToFit()
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchDelegate = self
        searchController.citySearchBar.alpha = 0
        view.addSubview(searchController.citySearchBar)
       
    }

    //MARK: Animation
    private func animateEntry(){
        UIView.animate(withDuration: 0.6, delay: 0.0, options: [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.curveEaseInOut], animations: {[unowned self]() -> Void in
            self.searchController.citySearchBar.alpha = 1
            self.searchTableView.alpha = 1
        
            }, completion: {(finished) in
                print("AniateEntry finished")
        })
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.curveEaseInOut], animations: {[unowned self]() -> Void in
            self.maskView.alpha = 0.5
            
            }, completion: {[unowned self](finished) in
                self.searchController.citySearchBar.becomeFirstResponder()
        })
        
    }
    
    fileprivate func dismissViewController() {
        DispatchQueue.main.async(execute: {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {[unowned self]() -> Void in
                self.searchTableView.alpha = 0.0
                self.searchController.citySearchBar.alpha = 0.0
                
                }, completion: {[unowned self](finished) in
                    self.searchController.citySearchBar.resignFirstResponder()
            })
            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {[unowned self]() in
                self.maskView.alpha = 0.0
                }, completion: {[unowned self](finished) in
                    self.willMove(toParentViewController: nil)
                    self.view.removeFromSuperview()
                    self.removeFromParentViewController()
            })
        })
    }

    //MARK: Data
    fileprivate func initCities(){
    //Here provide two ways to initCities. Choose one of them and disable the other one.
        initCitiesFromCoreData()
//        initCitiesFromJSON()
    }
    
    fileprivate func initCitiesFromCoreData(){
        var objects = [NSManagedObject]()
        let managedContext = getManagedContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "City")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            objects = try managedContext.fetch(fetchRequest) 
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        if objects.count > 0 {
            for object in objects {
                cities.append(object.value(forKey: "name") as! String)
            }
        }else{
            initCitiesFromJSON()
            saveCitiesInCoreData(withManagedContext: managedContext)
        }
    }
    
    fileprivate func initCitiesFromJSON(){
        if let path = Bundle.main.path(forResource: "CN_city_sorted", ofType: "txt"),let stringData = try? String(contentsOfFile: path){
            let lines = stringData.components(separatedBy: "\n")
            for line in lines {
                if let dataFromString = line.data(using: String.Encoding.utf8, allowLossyConversion: false),let cityName = JSON(data:dataFromString)["name"].string{
                    cities.append(cityName)
                }
            }
        }
    }
    
    fileprivate func saveCitiesInCoreData(withManagedContext managedContext:NSManagedObjectContext){
//      下面这行用 DispatchQueue.main() 还是 DispatchQueue.global()???
        DispatchQueue.global().async{[unowned self] in
            let entity = NSEntityDescription.entity(forEntityName: "City", in:managedContext)
            for city in self.cities {
                let cityObject = NSManagedObject(entity: entity!, insertInto: managedContext)
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
    
    fileprivate func filterContentForSearchText(_ searchText: String){
        filteredCities = cities.filter({ ( city : String)-> Bool in
            return city.lowercased().contains(searchText.lowercased())
        })
    
        searchTableView.reloadData()
    }
    
    //MARK: Helper
    func tapToReturn(_ sender: UITapGestureRecognizer){
        dismissViewController()
    }
    
    func getManagedContext()->NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }
}

//MARK: UITableViewDelegate
extension AddCityPageVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard rootViewController is MainViewController else { return }

        if let cell = tableView.cellForRow(at: indexPath) as? SearchCityTableViewCell {
            delegate?.selectedCityName(cityName: cell.cityNameLabel.text!)
        }
    }
}

//MARK: UITabelViewDataSource
extension AddCityPageVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.citySearchBar.text != "" {
            return filteredCities.count
        }else{
            return cities.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCityCell", for: indexPath) as! SearchCityTableViewCell
        if searchController.citySearchBar.text != "" {
            cell.cityNameLabel.text = filteredCities[(indexPath as NSIndexPath).row]
        }else{
            cell.cityNameLabel.text = cities[(indexPath as NSIndexPath).row]
        }
        return cell
    }
}

//MARK: CitySearchControllerDelegate
extension AddCityPageVC : CitySearchControllerDelegate {
    func didChangeSearchTextInSearchBar(_ searchBar: CitySearchBar, searchText: String) {
        filterContentForSearchText(searchText)
    }
}

