//
//  WeatherDemoTests.swift
//  WeatherDemoTests
//
//  Created by Linsw on 16/8/4.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import XCTest
@testable import WeatherDemo

class WeatherDemoTests: XCTestCase {
    
    
    var fiveDayInfoView : FiveDayInfoView?
    
    override func setUp() {
        super.setUp()
        fiveDayInfoView = NSBundle.mainBundle().loadNibNamed("FiveDayInfoView", owner: self, options: nil).first as? FiveDayInfoView
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFiveDayInfoView() {
        XCTAssertNotNil(fiveDayInfoView)
        XCTAssertEqual(fiveDayInfoView!.days.count, 5, "days.count NotEqual 5")
        XCTAssertFalse(fiveDayInfoView!.autoresizesSubviews)
        var dayNumberSum = 0
        for cell in fiveDayInfoView!.days {
            dayNumberSum += cell.dayNumber
            XCTAssertEqual(cell.frame.size, dayInfoViewCellSize, "dayCellSize is not correct")
            print(cell.frame)
        }
        XCTAssertEqual(dayNumberSum, 10, "Summary of dayNumbers is not 10")
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
