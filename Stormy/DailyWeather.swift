//
//  DailyWeather.swift
//  Stormy
//
//  Created by Ethan Neff on 2/9/16.
//  Copyright © 2016 eneff. All rights reserved.
//

import Foundation
import UIKit

struct DailyWeather {
  // all optionals b/c api does not guarentee the will exist
  let maxTemperature: Int?
  let minTemperature: Int?
  let humidity: Int?
  let percipChance: Int?
  let summary: String?
  var icon: UIImage? = UIImage(named: "default.png")
  var largeIcon: UIImage? = UIImage(named: "default_large.png")
  var sunriseTime: String?
  var sunsetTime: String?
  var day: String?
  let dateFormatter = NSDateFormatter()

  init(dailyWeatherDict: [String:AnyObject]) {
    // guarenteed
    maxTemperature = dailyWeatherDict["temperatureMax"] as? Int
    minTemperature = dailyWeatherDict["temperatureMin"] as? Int
    summary = dailyWeatherDict["summary"] as? String
    // optional
    if let humidityFloat = dailyWeatherDict["humidity"] as? Double {
      humidity = Int(humidityFloat * 100)
    } else {
      humidity = nil
    }
    if let precipChanceFloat = dailyWeatherDict["precipProbability"] as? Double {
      percipChance = Int(precipChanceFloat * 100)
    } else {
      percipChance = nil
    }
    if let iconString = dailyWeatherDict["icon"] as? String,
      let iconEnum = Icon(rawValue: iconString) {
        (icon, largeIcon) = iconEnum.toImage()
    }
    if let sunriseDate = dailyWeatherDict["sunriseTime"] as? Double {
      sunriseTime = timeStringFromUnixTime(sunriseDate)
    } else {
      sunriseTime = nil
    }
    if let sunsetDate = dailyWeatherDict["sunsetTime"] as? Double {
      sunsetTime = timeStringFromUnixTime(sunsetDate)
    } else {
      sunsetTime = nil
    }
    if let time = dailyWeatherDict["time"] as? Double {
      day = dayStringFromUnixTime(time)
    }
  }

  func timeStringFromUnixTime(unixTime:Double) -> String {
    let date = NSDate(timeIntervalSince1970: unixTime)
    dateFormatter.dateFormat = "hh:mm a"
    return dateFormatter.stringFromDate(date)
  }

  func dayStringFromUnixTime(unixTime:Double) -> String {
    let date = NSDate(timeIntervalSince1970: unixTime)
    dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.currentLocale().localeIdentifier)
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter.stringFromDate(date)

  }
}