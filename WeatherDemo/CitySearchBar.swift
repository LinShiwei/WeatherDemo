//
//  CitySearchBar.swift
//  WeatherDemo
//
//  Created by Linsw on 16/9/5.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class CitySearchBar: UISearchBar {

    override func drawRect(rect: CGRect) {
        if let index = indexOfSearchFieldInSubviews() {
            let searchField: UITextField = subviews[0].subviews[index] as! UITextField
            
            searchField.frame = CGRectMake(5.0, 5.0, frame.size.width - 10.0, frame.size.height - 10.0)
        
            searchField.backgroundColor = barTintColor
        }
        
        super.drawRect(rect)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        
        searchBarStyle = UISearchBarStyle.Prominent
        translucent = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func indexOfSearchFieldInSubviews() -> Int! {
        var index: Int!
        let searchBarView = subviews[0] 
        
        for i in 0 ..< searchBarView.subviews.count {
            if searchBarView.subviews[i].isKindOfClass(UITextField) {
                index = i
                break
            }
        }
        
        return index
    }
}
