//
//  WeeklyTableViewController.swift
//  Stormy
//
//  Created by Ethan Neff on 2/9/16.
//  Copyright © 2016 eneff. All rights reserved.
//

import UIKit

class WeeklyTableViewController: UITableViewController {

  // MARK: - PROPERTIES
  @IBOutlet weak var currentTemperatureLabel: UILabel?
  @IBOutlet weak var currentWeatherIcon: UIImageView?
  @IBOutlet weak var currentPrecipitationLabel: UILabel?
  @IBOutlet weak var currentTemperatureRangeLabel: UILabel?

  var coordinate: (lat: Double, lon: Double) = (37.8267,-122.423)
  var weeklyWeather: [DailyWeather] = []
  private let forecastAPIKey = "e5c60e42191a5e18959f26c8881c6bdc"


  // MARK: - LOAD
  override func viewDidLoad() {
    super.viewDidLoad()

    configureView()
    retrieveWeatherForecast()
  }

  func configureView() {
    // change table view
    tableView.backgroundView = BackgroundView()

    // cell custom height
    tableView.rowHeight = 64

    // refresh control above background view
    refreshControl?.layer.zPosition = (tableView.backgroundView?.layer.zPosition)! + 1
    refreshControl?.tintColor = .whiteColor()

    // change nav bar text
    if let navBarFont = UIFont(name: "HelveticaNeue-Thin", size: 20.0) {
      let navBarAttributeDictionary: [String: AnyObject]? = [
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: navBarFont
      ]
      navigationController?.navigationBar.titleTextAttributes = navBarAttributeDictionary
    }
  }

  @IBAction func refreshWeather(sender: AnyObject) {
    retrieveWeatherForecast()
    refreshControl?.endRefreshing()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  // MARK: - NAVIGATION
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showDaily" {
      // get cell
      if let indexPath = tableView.indexPathForSelectedRow {
        let dailyWeather = weeklyWeather[indexPath.row]
        // pass data
        (segue.destinationViewController as! DailyViewController).dailyWeather = dailyWeather
      }
    }
  }

  // MARK: - TABLEVIEW DATA SOURCE
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return weeklyWeather.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! DailyWeatherTableViewCell

    let dailyWeather = weeklyWeather[indexPath.row]
    if let maxTemp = dailyWeather.maxTemperature {
      cell.temperatureLabel.text = "\(maxTemp)"
    }
    cell.weatherIcon.image = dailyWeather.icon
    cell.dayLabel.text = dailyWeather.day

    return cell
  }

  override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
    let cell = tableView.cellForRowAtIndexPath(indexPath)
    cell?.contentView.backgroundColor = UIColor(red: 165/255.0, green: 142/255.0, blue: 203/255.0, alpha: 1.0)
    let highlightView = UIView()
    highlightView.backgroundColor = UIColor(red: 165/255.0, green: 142/255.0, blue: 203/255.0, alpha: 1.0)
    cell?.selectedBackgroundView = highlightView
  }

  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Forecast"
  }

  // MARK: TABLEVIEW DELEGATE
  override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    view.tintColor = UIColor (red: 170/255.0, green: 131/255.0, blue: 224/245.0, alpha: 1.0)
    if let header = view as? UITableViewHeaderFooterView {
      header.textLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 14.0)
      header.textLabel?.textColor = UIColor.whiteColor()
    }
  }

  // MARK: - UPDATE DATE
  func retrieveWeatherForecast() {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    // create service
    let forecastService = ForecastService(APIKey: forecastAPIKey)
    // get weather
    forecastService.getForecast(coordinate.lat, lon: coordinate.lon) {
      (let forecast) in
      if let weatherForecast = forecast {
        if let currentWeather = weatherForecast.currentWeather {
          // update view on main queue
          dispatch_async(dispatch_get_main_queue()) {
            if let temperature = currentWeather.temperature {
              self.currentTemperatureLabel?.text = "\(temperature)º"
            }
            if let precipitation = currentWeather.precipProbability {
              self.currentPrecipitationLabel?.text = "Rain: \(precipitation)%"
            }
            if let icon = currentWeather.icon {
              self.currentWeatherIcon?.image = icon
            }
            self.weeklyWeather = weatherForecast.weekly


            if let highTemp = self.weeklyWeather.first?.maxTemperature,
              let lowTemp = self.weeklyWeather.first?.minTemperature {
                self.currentTemperatureRangeLabel?.text = "↑\(highTemp)º↓\(lowTemp)"
            }

            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.tableView.reloadData()
          }
        }
      }
    }
  }
}
