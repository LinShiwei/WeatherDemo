//
//  CityWeatherViewTests.swift
//  WeatherDemoTests
//
//  Created by Linsw on 16/9/14.
//  Copyright © 2016年 Linsw. All rights reserved.
//


import Quick
import Nimble
@testable import WeatherDemo

class CityWeatherViewTests: QuickSpec {
    override func spec() {
        describe("after init from storyboard"){
            var cityWeatherView: CityWeatherView!
            beforeEach{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "MainViewControllerID") as! MainViewController
                for view in viewController.view.subviews where view is CityWeatherView {
                    cityWeatherView = view as! CityWeatherView
                }
            }
            
            it("notNil"){
                expect(cityWeatherView).toNot(beNil())
            }
            
            it("contains MainWeatherInfoView and FiveDayInfoView"){
                let mainWeatherInfoView = cityWeatherView.mainWeatherInfoView!
                let fiveDayInfoView = cityWeatherView.fiveDayInfoView!
                expect(cityWeatherView.subviews).to(contain([mainWeatherInfoView, fiveDayInfoView]))
            }
        }
    }
}
