//
//  OpenWeatherMapAPI.swift
//  WeatherDemo
//
//  Created by Linsw on 16/8/4.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import Foundation
import UIKit
//MARK: APP constant setting
let windowBounds = UIScreen.mainScreen().bounds


let cityListTableViewWidth : CGFloat = 150 //This property MUST set in Main.stroyboard

let cityListTableViewHeight : CGFloat = 100

let dayInfoViewCellSize = CGSize(width: (windowBounds.width - cityListTableViewWidth)/5.0, height: 200)

//MARK: AddCityPageVC constant
let searchControllerWidth : CGFloat = 400
let searchControllerFrame = CGRect(x: (windowBounds.width - searchControllerWidth)/2, y: 100, width: searchControllerWidth, height: 44)

let searchTableViewWidth : CGFloat = 400
let searchTableViewFrame = CGRect(x: (windowBounds.width - searchControllerWidth)/2, y: 100 + searchControllerFrame.height, width: searchTableViewWidth, height: 500)

//MARK: OpenWeatherMap API

let APPID = "&APPID=91d32f2d41f0656d8c13bba6f2c1aaed"
//let APPID = "&lang=zh_cn&APPID=91d32f2d41f0656d8c13bba6f2c1aaed"
let currentWeatherDataByName = "http://api.openweathermap.org/data/2.5/weather?q="
let fiveDayWeatherDataByName = "http://api.openweathermap.org/data/2.5/forecast?q="
/*
API call:
http://api.openweathermap.org/data/2.5/forecast/city?id=524901&APPID={APIKEY}
Parameters:
APPID {APIKEY} is your unique API key

Example of API call:
api.openweathermap.org/data/2.5/forecast/city?id=524901&APPID=1111111111
*/

/*
Current Weather API call:

api.openweathermap.org/data/2.5/weather?q={city name}

api.openweathermap.org/data/2.5/weather?q={city name},{country code}

Parameters:

q city name and country code divided by comma, use ISO 3166 country codes

Examples of API calls:

api.openweathermap.org/data/2.5/weather?q=London

api.openweathermap.org/data/2.5/weather?q=London,uk
*/
/*
Five Day Weather API :
api.openweathermap.org/data/2.5/forecast?q={city name},{country code}
Parameters:

q city name and country code divided by comma, use ISO 3166 country codes

Examples of API calls:

api.openweathermap.org/data/2.5/forecast?q=London,us&mode=xml

*/



