//
//  OpenWeatherMapAPI.swift
//  WeatherDemo
//
//  Created by Linsw on 16/8/4.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import Foundation

/*
    API call:
    http://api.openweathermap.org/data/2.5/forecast/city?id=524901&APPID={APIKEY}

    Parameters:
    APPID {APIKEY} is your unique API key
   
    Example of API call:
    api.openweathermap.org/data/2.5/forecast/city?id=524901&APPID=1111111111
*/

let APPID = "&APPID=91d32f2d41f0656d8c13bba6f2c1aaed"
let currentWeatherDataByName = "http://api.openweathermap.org/data/2.5/weather?q="