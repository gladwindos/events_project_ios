//
//  DataModel.swift
//  uni_events
//
//  Created by Gladwin Dosunmu on 29/06/2016.
//  Copyright © 2016 Gladwin Dosunmu. All rights reserved.
//

import Foundation
import UIKit

class Event : NSObject {
    
    var id : Int = 0
    var title : String = ""
    var university = [Int]()
    var poster = NSData()
    var start_date : NSDate = NSDate()
    var end_date : NSDate = NSDate()
    var ticketLink : String = ""
    var main_description : String = ""
    var venue_name : String = ""
    var venue_address : String = ""
    var venue_city : String = ""
    var venue_postcode : String = ""
    var contact_details : String = ""
    
//    init(id : Int, title: String, university: Int, poster: NSData, start_date: NSDate, end_date: NSDate, ticketLink: String, main_description: String, venue_name: String, venue_address: String, venue_city: String, venue_postcode: String, contact_details: String) {
//        
//        self.id = id
//        self.title = title
//        self.university = university
//        self.poster = poster
//        self.start_date = start_date
//        self.end_date = end_date
//        self.ticketLink = ticketLink
//        self.main_description = main_description
//        self.venue_name = venue_name
//        self.venue_address = venue_address
//        self.venue_city = venue_city
//        self.venue_postcode = venue_postcode
//        self.contact_details = contact_details
//    }
//    
}