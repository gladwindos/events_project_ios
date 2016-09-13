//
//  AppMemory.swift
//  uni_events
//
//  Created by Gladwin Dosunmu on 29/06/2016.
//  Copyright © 2016 Gladwin Dosunmu. All rights reserved.
//

import Foundation

class AppMemory {
    
    var eventList : [Event] = []
    
    var currentEvent = Event()
    
    var sortedEvents : [[Event]]? = []
    
    var currentUser = User()
    
    let apiUrl = "http://unievents-dev.eu-west-1.elasticbeanstalk.com/"
    
    var myNotificationCenter = MyNotificationCenter()
}