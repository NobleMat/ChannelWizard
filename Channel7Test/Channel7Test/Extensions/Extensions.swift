//
//  Extensions.swift
//  Channel7Test
//
//  Created by Noble Mathew on 30/6/17.
//  Copyright © 2017 NTech. All rights reserved.
//

import Foundation
import UIKit

//MARK: - WeatherActivityIndicator
//Custom class to implement Activity Indicator
class ActivityIndicator {
  
  static var container: UIView = UIView()
  static var loadingView: UIView = UIView()
  static var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
  
  /*
   Show customized activity indicator,
   actually add activity indicator to passing view
   
   - parameter onView - add activity indicator to this view
   */
  static func showActivityIndicator(_ onView: UIView) {
    container.frame = onView.frame
    container.center = onView.center
    container.backgroundColor = UIColor(hex: "0xffffff", alpha: 0.3)
    
    loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
    loadingView.center = onView.center
    loadingView.backgroundColor = UIColor(hex: "0x444444", alpha: 0.7)
    loadingView.clipsToBounds = true
    loadingView.layer.cornerRadius = 10
    
    activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    activityIndicator.activityIndicatorViewStyle = .whiteLarge
    activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
    
    loadingView.addSubview(activityIndicator)
    container.addSubview(loadingView)
    onView.addSubview(container)
    activityIndicator.startAnimating()
  }
  
  /**
   Hide activity indicator
   Actually remove activity indicator from its super view
   
   - parameter fromView: remove activity indicator from this view
   */
  static func hideActivityIndicator(_ fromView: UIView) {
    activityIndicator.stopAnimating()
    container.removeFromSuperview()
  }
  
}

//MARK: UIColor
extension UIColor {
  
  /**
   Init UIColor from hex value
   
   - Parameter rgbValue: hex color value
   - Parameter alpha: transparency level
   */
  convenience init(hex: String, alpha: CGFloat) {
    let scanner = Scanner(string: hex)
    scanner.scanLocation = 0
    
    var RGBValue: UInt64 = 0
    scanner.scanHexInt64(&RGBValue)
    
    let red = (RGBValue & 0xff0000) >> 16
    let green = (RGBValue & 0xff00) >> 8
    let blue = RGBValue & 0xff
    
    self.init(red: CGFloat(red) / 0xff, green: CGFloat(green) / 0xff, blue: CGFloat(blue) / 0xff, alpha: alpha)
  }
}

//MARK: - String
extension String {
  /**
   Calculate the height of the bounding box that can contain the string
   
   - parameter width: Width of the containing view
   - parameter font: Font of the label that will be using the string
   
   - returns: A CGFloat that can be used as the height the string requires to be
   seen completely
   */
  func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
    
    return boundingBox.height
  }
}

//MARK: - UIImageView
let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {
  func getImage(_ imageURL: String, completion: @escaping(Bool?) -> ()) {
    let url = URL(string: imageURL)
    image = nil
    
    if let imageFromCache = imageCache.object(forKey: imageURL as AnyObject) as? UIImage {
      self.image = imageFromCache
      completion(true)
    }
    
    URLSession.shared.dataTask(with: url!) { (data, response, error) in
      if error != nil {
        print(error ?? "Error fetching image")
        completion(false)
      }
      
      DispatchQueue.main.async {
        let imageToCache = UIImage(data: data!)
        self.image = imageToCache
        imageCache.setObject(imageToCache!, forKey: imageURL as AnyObject)
      }
    }.resume()
  }
}
