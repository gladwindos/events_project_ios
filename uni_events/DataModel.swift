//
//  DataModel.swift
//  uni_events
//
//  Created by Gladwin Dosunmu on 29/06/2016.
//  Copyright © 2016 Gladwin Dosunmu. All rights reserved.
//

import Foundation
import UIKit
import Lock

class Event : NSObject {
    
    var id : Int = 0
    var title : String = ""
    var university = [Int]()
    var posterUrl = ""
    var start_date : NSDate = NSDate()
    var end_date : NSDate = NSDate()
    var ticketLink : String = ""
    var main_description : String = ""
    var venue_name : String = ""
    var venue_address : String = ""
    var venue_city : String = ""
    var venue_postcode : String = ""
    var contact_details : String = ""
    var favourites_ids : [String] = []
}

class User : NSObject {
    var loggedIn : Bool = false
    var profile: A0UserProfile? = A0UserProfile()
    var idToken : String = ""
    
}