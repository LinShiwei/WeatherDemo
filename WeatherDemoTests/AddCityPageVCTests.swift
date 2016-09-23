//
//  AddCityPageVCTests.swift
//  WeatherDemoTests
//
//  Created by Linsw on 16/9/14.
//  Copyright © 2016年 Linsw. All rights reserved.
//


import Quick
import Nimble
@testable import WeatherDemo

class AddCityPageVCTests: QuickSpec {
    override func spec() {
        var addCityPageVC: AddCityPageVC!
        var mainVC: MainViewController!
        
        beforeEach{
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "cities")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewControllerID") as! MainViewController
            let _ = mainVC.view
            addCityPageVC = AddCityPageVC(senderView: nil, rootViewController: mainVC, backgroundColor: UIColor.white)
            addCityPageVC.presentFromRootViewController()

        }
        
        describe("after init"){
            it("present in the mainViewController"){
                expect(mainVC.childViewControllers).to(contain(addCityPageVC))
            }
            
            it("its delegate is MainViewController"){
                expect(addCityPageVC.delegate is MainViewController).to(beTrue())
            }
            
            it("view contains three subviews:maskView, searchTableView and citySearchBar"){
                expect(addCityPageVC.view.subviews.count).to(equal(3))
                expect(addCityPageVC.view.subviews).to(contain(addCityPageVC.searchTableView,addCityPageVC.searchController.citySearchBar))
            }
            
            it("subview[0]:maskView has one tapGestureRecognizer"){
                expect(addCityPageVC.view.subviews[0].gestureRecognizers![0]).to(beAKindOf(UITapGestureRecognizer))
            }
            
            describe("searchTableView"){
                var searchTableView: UITableView!
                beforeEach{
                    searchTableView = addCityPageVC.searchTableView
                }
                
                it("its delegeta and dataSource is addCityPageVC"){
                    expect(searchTableView.delegate is AddCityPageVC).to(beTrue())
                    expect(searchTableView.dataSource is AddCityPageVC).to(beTrue())
                }
                
                it("contains over 6000 city cells"){
                    expect(searchTableView.numberOfRows(inSection: 0)) > 6000
                }
                
                it("can select cell to add city in mainViewController"){
                    let _ = searchTableView.numberOfRows(inSection: 0)
                    let indexPath = IndexPath(row: 3, section: 0)
                    let cell = searchTableView.cellForRow(at: indexPath) as! SearchCityTableViewCell
                    let cityName = cell.cityNameLabel.text
                    addCityPageVC.tableView(searchTableView, didSelectRowAt: indexPath)
                    
                    expect(mainVC.citiesInTable).to(contain(cityName))
                    expect(mainVC.citiesInTable.count).to(equal(mainVC.cityListTable.numberOfRows(inSection: 0)-1))
                }
                
                it("should change presented cell when search text changed"){
                    let bar = addCityPageVC.searchController.citySearchBar
                    let previousCount = addCityPageVC.searchTableView.numberOfRows(inSection: 0)
                    bar.text = "bei"
                    addCityPageVC.didChangeSearchTextInSearchBar(bar, searchText: "bei")
//                    expect(addCityPageVC.searchTableView.numberOfRowsInSection(0)).toEventually(beLessThan(previousCount))

                    expect(addCityPageVC.searchTableView.numberOfRows(inSection: 0)) < previousCount
                }
                
                it("ZZZAvoidBUG"){}
            }
            
            it("ZZZAvoidBUG"){}
        }
    }
}
