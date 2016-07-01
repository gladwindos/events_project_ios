//
//  AppLogic.swift
//  uni_events
//
//  Created by Gladwin Dosunmu on 29/06/2016.
//  Copyright © 2016 Gladwin Dosunmu. All rights reserved.
//

import Foundation
import UIKit

extension App {
    

    static func fetchEvents(completionHandler : (events: [Event]) -> Void) {
        
        var allEvents = [Event]()
        
        let url = NSURL(string: "http://127.0.0.1:8000/api/events/")
        NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            
            do {
                
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                
                for dict in json as! [[String : AnyObject]] {
                    
                    let newEvent = Event()
                    
                    if let id = dict["id"] as? NSInteger {
                        newEvent.id = id
                    }
                    
                    if let title = dict["title"] as? String {
                        newEvent.title = title
                    }
                    
                    if let university = dict["university"] as? [Int] {
                        newEvent.university = university
                    }
                    
                    var poster = NSData()
                    
                    if let posterStr = dict["poster"] as? String {
                        
                        let posterUrl = NSURL(string: posterStr)!
                        
                        poster = NSData(contentsOfURL: posterUrl)!
                        
                        newEvent.poster = poster
                        
                    }
                    
                    if let start_date_string = dict["start_date"] as? String {
                        
                        let start_date = getDateFromString(start_date_string)
                        newEvent.start_date = start_date
                    }
                    
                    if let end_date_string = dict["end_date"] as? String {
                        
                        let end_date = getDateFromString(end_date_string)
                        newEvent.end_date = end_date
                    }
                    
                    if let ticketLink = dict["ticket_link"] as? String{
                        newEvent.ticketLink = ticketLink
                    }
                    
                    if let main_description = dict["description"] as? String {
                        newEvent.main_description = main_description
                    }
                    
                    if let venue_name = dict["venue_name"] as? String {
                        newEvent.venue_name = venue_name
                    }
                    
                    if let venue_address = dict["venue_address"] as? String {
                        newEvent.venue_address = venue_address
                    }
                    
                    if let venue_city = dict["venue_city"] as? String {
                        newEvent.venue_city = venue_city
                    }
                    
                    if let venue_postcode = dict["venue_postcode"] as? String {
                        newEvent.venue_postcode = venue_postcode
                    }
                    
                    if let contact_details = dict["contact_details"] as? String {
                        newEvent.contact_details = contact_details
                    }
                    
                    allEvents.append(newEvent)
                    
                    App.Memory.eventList = allEvents
                    
                }
                
                completionHandler(events: allEvents)
                print("fetch")               
                
                
                
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
        
        
    }
    

    
    static func getDateFromString(string: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssz"
        return dateFormatter.dateFromString(string)!
    }
}




