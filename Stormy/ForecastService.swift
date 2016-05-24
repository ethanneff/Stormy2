//
//  ForecastService.swift
//  Stormy
//
//  Created by Ethan Neff on 5/13/15.
//  Copyright (c) 2015 eneff. All rights reserved.
//

import Foundation

// MARK: SETUP THE URL
struct ForecastService {
  // MARK: PRORPERTIES
  let forecastAPIKey: String
  let forecastBaseURL: NSURL?
  
  // MARK: INIT
  init(APIKey: String) {
    forecastAPIKey = APIKey
    forecastBaseURL = NSURL(string: "https://api.forecast.io/forecast/\(forecastAPIKey)/")
  }
  
  // MARK: PUBLIC METHODS
  func getForecast(lat: Double, lon: Double, completion: (Forecast? -> Void)) {
    if let forecastURL = NSURL(string: "\(lat),\(lon)", relativeToURL: forecastBaseURL) {
      // create network connection
      let networkOperation = NetworkOperation(url: forecastURL)
      // download with completion closure
      networkOperation.downloadJSONFromURL {
        (let JSONDictionary) in
        // format JSON data to View data
        let forecast = Forecast(weatherDictionary: JSONDictionary)
        // completion to ViewController
        completion(forecast)
      }
    } else {
      print("Could not construct a valid URL")
    }
  }
  
}