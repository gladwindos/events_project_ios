//
//  utilities.swift
//  uni_events
//
//  Created by Gladwin Dosunmu on 21/06/2016.
//  Copyright © 2016 Gladwin Dosunmu. All rights reserved.
//

import Foundation
import UIKit

class Utilies {
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func myDateTimeFormatter(date: NSDate) -> String {
        
        let mydate = date
        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateStyle = .FullStyle
        dateFormatter.dateFormat = "EEEE dd MMMM"
        
        let time = date
        let timeFormatter = NSDateFormatter()
        timeFormatter.timeStyle = .ShortStyle
        
        let dateString = dateFormatter.stringFromDate(mydate)
        let timeString = timeFormatter.stringFromDate(time)
        return dateString + ", " + timeString
    }
}







