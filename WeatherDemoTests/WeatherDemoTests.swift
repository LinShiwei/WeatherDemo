//
//  WeatherDemoTests.swift
//  WeatherDemoTests
//
//  Created by Linsw on 16/8/4.
//  Copyright © 2016年 Linsw. All rights reserved.
//


import Quick
import Nimble
import SwiftyJSON
import XCTest
@testable import WeatherDemo

class WeatherDemoTests: QuickSpec{
    override func spec() {
        
        
        describe("MainViewController After init"){
            var viewController: MainViewController!
            var cityWeatherView: CityWeatherView!
            var table: CityListTableView!
            beforeEach{
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.removeObjectForKey("cities")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                viewController = storyboard.instantiateViewControllerWithIdentifier("MainViewControllerID") as! MainViewController
                let _ = viewController.view
                table = viewController.cityListTable
                cityWeatherView = viewController.cityWeatherView
            }
            it("notNil"){
                expect(viewController).toNot(beNil())
            }

            it("citiesInTable originally contains two city"){
                expect(viewController.citiesInTable.count) == 2
            }
            
            it("userDefaults 'city' Key originally contains a 2-city array"){
                let defaults = NSUserDefaults.standardUserDefaults()
                let cityArray = defaults.objectForKey("cities") as! [String]
                expect(cityArray.count).to(equal(2))
            }
            
            describe("cityListTable"){
                var cellCount = 0
                beforeEach{
                    cellCount = table.numberOfRowsInSection(0)
                }
                
                it("notNil"){
                    expect(table).toNot(beNil())

                }
                
                it("CountOfCell is euqal to citiesInTable.count+1"){
                    expect(cellCount).to(equal(viewController.citiesInTable.count+1))
                }
                
                it("lastCell's label name is "+""){
                    let lastCell = table.cellForRowAtIndexPath(NSIndexPath(forRow: cellCount-1,inSection: 0)) as! CityListTableCell
                    expect(lastCell.nameLabel.text).to(equal("+"))
                }
            }
//            
//            describe("cityWeatherView"){
//                
//                fit("has original weather data"){
//                    expect(cityWeatherView.weatherJsonData).toEventuallyNot(beNil(), timeout: 1, pollInterval: 1, description: nil)
//                    expect(cityWeatherView.fiveDayJsonData).toNotEventually(beNil(), timeout: 1, pollInterval: 1, description: nil)
//                }
//                
//            }
//            
            context("after select city To Add"){
                var count = 0
                var cellCount = 0
                beforeEach{
                    count = viewController.citiesInTable.count
                    cellCount = table.numberOfRowsInSection(0)
                    viewController.selectedCityName(cityName: "AvoidDuplicateName")
                }
                
                it("Add a city to Array and TableView"){
                    expect(viewController.citiesInTable.count).to(equal(count+1))
                    expect(viewController.citiesInTable).to(contain("AvoidDuplicateName"))
                    expect(table.numberOfRowsInSection(0)).to(equal(cellCount+1))
                }
                
                it("zzzAvoidBug"){
                    
                }
                
            }
            
//            context("after select cell in tableView"){
//                beforeEach{
//                    table.selectRowAtIndexPath(<#T##indexPath: NSIndexPath?##NSIndexPath?#>, animated: <#T##Bool#>, scrollPosition: <#T##UITableViewScrollPosition#>)
//                }
//            }
            

        
            
        }
        
    }
}




