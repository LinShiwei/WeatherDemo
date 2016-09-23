//
//  MainViewControllerTests.swift
//  WeatherDemoTests
//
//  Created by Linsw on 16/8/4.
//  Copyright © 2016年 Linsw. All rights reserved.
//


import Quick
import Nimble
import SwiftyJSON
@testable import WeatherDemo

class MainViewControllerTests: QuickSpec{
    override func spec() {    
        describe("After init"){
            var viewController: MainViewController!
            var cityWeatherView: CityWeatherView!
            var table: CityListTableView!
            beforeEach{
                let defaults = UserDefaults.standard
                defaults.removeObject(forKey: "cities")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                viewController = storyboard.instantiateViewController(withIdentifier: "MainViewControllerID") as! MainViewController
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
                let defaults = UserDefaults.standard
                let cityArray = defaults.object(forKey: "cities") as! [String]
                expect(cityArray.count).to(equal(2))
            }
            
            describe("cityListTable"){
                var cellCount = 0
                beforeEach{
                    cellCount = table.numberOfRows(inSection: 0)
                }
                
                it("notNil"){
                    expect(table).toNot(beNil())

                }
                
                it("contains two city cells and one add-city cell"){
                    expect(cellCount).to(equal(3))
                    let lastCell = table.cellForRow(at: IndexPath(row: cellCount-1,section: 0)) as! CityListTableCell
                    expect(lastCell.nameLabel.text).to(equal("+"))
                }

                it("has selected the first cell"){
                    expect(table.cellForRow(at: IndexPath(row: 0, section: 0))!.isSelected).to(beTrue())
                }
                
                it("can init weather data when display the first cell"){
                    viewController.tableView(table, willDisplay: table.cellForRow(at: IndexPath(row: 0, section: 0))!, forRowAt: IndexPath(row: 0, section: 0))
                    expect(cityWeatherView.weatherJsonData).toEventuallyNot(beNil())
                    expect(cityWeatherView.fiveDayJsonData).toEventuallyNot(beNil())
                }
                
                it("can change weather data when select the city cell"){
                    for row in 1...cellCount-1-1{
                        let originWeatherJsonData = cityWeatherView.weatherJsonData
                        let originFiveDayJsonData = cityWeatherView.fiveDayJsonData
                        viewController.tableView(table, didSelectRowAt: IndexPath(row: row, section: 0))
                        expect(cityWeatherView.weatherJsonData).toEventuallyNot(equal(originWeatherJsonData))
                        expect(cityWeatherView.fiveDayJsonData).toEventuallyNot(equal(originFiveDayJsonData))
                    }
                }
                
                it("can present AddCityPageVC when select the last cell '+'"){
                    let row = cellCount-1
                    expect(row).to(equal(2))
                    viewController.tableView(table, willSelectRowAt: IndexPath(row: row, section: 0))
                    var addCityPageVC : UIViewController?
                    for vc in viewController.childViewControllers where vc is AddCityPageVC{
                        addCityPageVC = vc
                    }
                    expect(addCityPageVC).toEventuallyNot(beNil())
                }
                
                it("can delete city cells"){
                    let arrayCount = viewController.citiesInTable.count
                    viewController.tableView(table, commit: .delete, forRowAt: IndexPath(row: 0, section: 0))
                    expect(viewController.citiesInTable.count).to(equal(arrayCount-1))
                    expect(table.numberOfRows(inSection: 0)).to(equal(cellCount-1))
                }
                
                it("can not delete the add-city cell"){
                    expect(viewController.tableView(table,canEditRowAt: IndexPath(row: cellCount-1, section: 0))).toNot(beTrue())
                }
            }

            context("after select city for Adding"){
                var count = 0
                var cellCount = 0
                beforeEach{
                    count = viewController.citiesInTable.count
                    cellCount = table.numberOfRows(inSection: 0)
                    viewController.selectedCityName(cityName: "AvoidDuplicateName")
                }
                
                it("can add a city to Array and TableView"){
                    expect(viewController.citiesInTable.count).to(equal(count+1))
                    expect(viewController.citiesInTable).to(contain("AvoidDuplicateName"))
                    expect(table.numberOfRows(inSection: 0)).to(equal(cellCount+1))
                }
                
                it("zzzAvoidBug"){
                    
                }
            }
        }
    }
}




