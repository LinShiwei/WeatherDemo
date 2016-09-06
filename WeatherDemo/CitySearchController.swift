//
//  CitySearchController.swift
//  WeatherDemo
//
//  Created by Linsw on 16/9/5.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

protocol CitySearchControllerDelegate {
    func didChangeSearchTextInSearchBar(searchBar:CitySearchBar,searchText:String)
}

class CitySearchController: UISearchController {

    var citySearchBar : CitySearchBar!
    
    var searchDelegate : CitySearchControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    init(searchResultsController: UIViewController?,searchBarFrame: CGRect, searchBarTintColor: UIColor) {
        super.init(searchResultsController: searchResultsController)
        
        configureSearchBar(searchBarFrame, bgColor: searchBarTintColor)
    }
    
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    func configureSearchBar(barFrame: CGRect, bgColor: UIColor) {
        citySearchBar = CitySearchBar(frame:barFrame)
        
        citySearchBar.barTintColor = bgColor
        citySearchBar.showsBookmarkButton = false
        citySearchBar.placeholder =  "City Name"
        citySearchBar.showsCancelButton = false
        
        citySearchBar.delegate = self
    }
}

extension CitySearchController : UISearchBarDelegate{
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        guard let bar = searchBar as? CitySearchBar else {return}
        searchDelegate?.didChangeSearchTextInSearchBar(bar, searchText: searchText)
    }

}
