//
//  NetworkOperation.swift
//  Stormy
//
//  Created by Ethan Neff on 5/13/15.
//  Copyright (c) 2015 eneff. All rights reserved.
//

import Foundation

// MARK: DOWNLOAD DATA FROM THE WEB
class NetworkOperation {
  // MARK: PROPERTIES
  lazy var config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
  lazy var session: NSURLSession = NSURLSession(configuration: self.config)
  let queryURL: NSURL
  typealias JSONDictionaryCompletion = ([String: AnyObject]? -> Void)
  
  // MARK: INIT
  init(url: NSURL) {
    self.queryURL = url
  }
  
  // MARK: DOWNLOAD
  func downloadJSONFromURL(completion: JSONDictionaryCompletion) {
    let request = NSURLRequest(URL: queryURL)
    let dataTask = session.dataTaskWithRequest(request) {
      (let data, let response, let error) in
      
      // check http response
      if let httpResponse = response as? NSHTTPURLResponse {
        switch httpResponse.statusCode {
        case 200:
          // transform into JSON
          let jsonDictionary = (try? NSJSONSerialization.JSONObjectWithData(data!, options: [])) as? [String: AnyObject]
          // completion to forecastservice object
          completion(jsonDictionary)
        default:
          print("GET request not successful. HTTP status code: \(httpResponse.statusCode)")
        }
      } else {
        print("Error: Not a valid HTTP response")
      }
    }
    
    dataTask.resume()
  }
}