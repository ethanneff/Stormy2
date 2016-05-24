//
//  DailyViewController.swift
//  Stormy
//
//  Created by Ethan Neff on 5/12/15.
//  Copyright (c) 2015 eneff. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class DailyViewController: UIViewController, CLLocationManagerDelegate {
  // MARK: properties
  @IBOutlet weak var weatherIcon: UIImageView!
  @IBOutlet weak var summaryLabel: UILabel!
  @IBOutlet weak var sunriseTimeLabel: UILabel!
  @IBOutlet weak var sunsetTimeLabel: UILabel!
  @IBOutlet weak var lowTemperatureLabel: UILabel!
  @IBOutlet weak var highTemperatureLabel: UILabel!
  @IBOutlet weak var precipitationLabel: UILabel!
  @IBOutlet weak var humidityLabel: UILabel!
  
  var dailyWeather: DailyWeather? {
    didSet {
      configureView()
    }
  }
  
  func configureView() {
    // change title
    if let weather = dailyWeather {
      self.title = weather.day
      weatherIcon?.image = weather.largeIcon
      summaryLabel?.text = weather.summary
      sunriseTimeLabel?.text = weather.sunriseTime
      sunsetTimeLabel?.text = weather.sunsetTime
      
      if let lowTemp = weather.minTemperature,
        let highTemp = weather.maxTemperature,
        let rain = weather.percipChance,
        let humidity = weather.humidity {
          lowTemperatureLabel?.text = "\(lowTemp)º"
          highTemperatureLabel?.text = "\(highTemp)º"
          precipitationLabel?.text = "\(rain)%"
          humidityLabel?.text = "\(humidity)%"
      }
    }
    
    // change nav bar text
    if let buttonFont = UIFont(name: "HelveticaNeue-Thin", size: 20.0) {
      let barButtonAttributeDictionary: [String: AnyObject]? = [
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: buttonFont
      ]
      UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributeDictionary, forState: .Normal)
    }
  }
  
  // MARK: LOAD
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureView()
  }
  
  
  //  // MARK: LOCATION
  //  func getUserLocation() {
  //    // Ask for Authorisation from the User.
  //    self.locationManager.requestAlwaysAuthorization()
  //
  //    // For use in foreground
  //    self.locationManager.requestWhenInUseAuthorization()
  //
  //    if CLLocationManager.locationServicesEnabled() {
  //      locationManager.delegate = self
  //      locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
  //      locationManager.startUpdatingLocation()
  //    }
  //  }
  //
  //  func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
  //    let locValue:CLLocationCoordinate2D = newLocation.coordinate
  //    coordinate = (locValue.latitude, locValue.longitude)
  //    locationManager.stopUpdatingLocation()
  //  }
  
}

