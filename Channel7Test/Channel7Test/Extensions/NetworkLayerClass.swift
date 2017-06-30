//
//  NetworkLayerClass.swift
//  Channel7Test
//
//  Created by Noble Mathew on 30/6/17.
//  Copyright © 2017 NTech. All rights reserved.
//

import Foundation
import UIKit

class NetworkLayerClass: NSObject {
  
  static func fetchDataFrom(_ url: String, completion: @escaping([String: Any]?) -> ()) {
    guard let endpointURL = URL(string: url) else {
      print("Endpoint URL Error")
      completion(nil)
      return
    }
    
    let urlRequest = URLRequest(url: endpointURL)
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    
    session.dataTask(with: urlRequest) { (fetchedData, response, error) in
      if let error = error {
        print("Error fetching: \(error.localizedDescription)")
        completion(nil)
        return
      }
      
      guard fetchedData != nil else {
        print("Error: Did not receive any data")
        completion(nil)
        return
      }
      
      do {
        if let fetchedData = fetchedData {
          guard let details = try JSONSerialization.jsonObject(with: fetchedData, options: []) as? [String: Any] else {
            completion(nil)
            return
          }
          completion(details)
        }
      } catch {
        print("Error converting JSON Data \(error.localizedDescription)")
        completion(nil)
        return
      }
    }.resume()
  }
}
