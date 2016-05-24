//
//  Forecast.swift
//  Stormy
//
//  Created by Ethan Neff on 2/9/16.
//  Copyright © 2016 eneff. All rights reserved.
//

import Foundation


// MARK: WRAPPER FILE
struct Forecast {
  var currentWeather: CurrentWeather?
  var weekly: [DailyWeather] = []

  init(weatherDictionary: [String:AnyObject]?) {
    if let currentWeatherDictionary = weatherDictionary?["currently"] as? [String: AnyObject] {
      // proper format the data
      currentWeather = CurrentWeather(weatherDictionary: currentWeatherDictionary)
    }
    if let weeklyWeatherArray = weatherDictionary?["daily"]?["data"] as? [[String: AnyObject]] {
      // proper format the data
      for dailyWeather in weeklyWeatherArray {
        let daily = DailyWeather(dailyWeatherDict: dailyWeather)
        weekly.append(daily)
      }
    }
  }
}