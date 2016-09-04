//
//  AppLogic.swift
//  uni_events
//
//  Created by Gladwin Dosunmu on 29/06/2016.
//  Copyright © 2016 Gladwin Dosunmu. All rights reserved.
//

import Foundation
import UIKit
import Lock
import SimpleKeychain
import Alamofire

extension App {
    

    static func fetchEvents(completionHandler : (events: [[Event]]) -> Void) {
        
        App.Memory.sortedEvents = []
        
        App.Memory.eventList = []
        
        var counter = 0
        
        var allEvents = [[Event]]()
        
        let url = NSURL(string: "\(App.Memory.apiUrl)/api/events")
//        let url = NSURL(string: "http://127.0.0.1:8000/api/events/")
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
                    
                    if let posterUrl = dict["poster"] as? String {
                        
                        newEvent.posterUrl = posterUrl
                        
                    }
                    
                    if let start_date_string = dict["start_date"] as? String {
                        
                        let start_date = App.getDateFromString(start_date_string)
                        newEvent.start_date = start_date
                    }
                    
                    if let end_date_string = dict["end_date"] as? String {
                        
                        let end_date = App.getDateFromString(end_date_string)
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
                    
                    if let favourite_ids = dict["auth0_favourite_ids"] as? [String] {
                        newEvent.favourites_ids = favourite_ids
                    }
                    
                    
                    App.Memory.eventList.append(newEvent)
                    
                    if allEvents.isEmpty {
                        
                        
                        
                        allEvents.append([])
                        
                        allEvents[counter].append(newEvent)
                        
                    } else {
                        
                        let order = NSCalendar.currentCalendar().compareDate(allEvents[counter][0].start_date, toDate: newEvent.start_date,                                                       toUnitGranularity: .Day)
                        
                        switch order {
                            
                        case .OrderedDescending:
                            print("Descending?")
                        case .OrderedAscending:
                            allEvents.append([])
                            counter += 1
                            allEvents[counter].append(newEvent)
                        case .OrderedSame:
                            allEvents[counter].append(newEvent)
                        }
                        
                    }
                    
                    App.Memory.sortedEvents = allEvents
                    
                }
                
                completionHandler(events: allEvents)
                
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
        
        
    }
    
    static func tokenAuth() {
        // parameters will be username and password
        
        let url = "http://localhost:8000/api-token-auth/"
        
        let parameters = ["username" : "gladwin", "password" : "tundetobi11"]
        
        let headers = ["Accept": "application/json"]
        
        Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON, headers: headers)
            .responseJSON { response in
                debugPrint(response)
                
                // will return token which I will save in keychain
                
        }
    
    }
    
    static func authenticateUser() {
        
        
        let keychain = A0SimpleKeychain(service: "Auth0")
        guard let idToken = keychain.stringForKey("id_token") else {
            // idToken doesn't exist, user has to enter his credentials to log in
            // Present A0Lock Login
            //            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(tbc, animated: false, completion: {
            //
            //            })
            return
        }
        // idToken exists
        // Validate idToken
        let client = A0Lock.sharedLock().apiClient()
        client.fetchUserProfileWithIdToken(idToken, success: { profile in
            
            keychain.setData(NSKeyedArchiver.archivedDataWithRootObject(profile), forKey: "profile")
            // ✅ At this point, you can log the user into your app, by navigating to the corresponding screen
            
            App.Memory.currentUser.loggedIn = true
            App.Memory.currentUser.idToken = idToken
            App.Memory.currentUser.profile = profile
            
            //            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(tbc, animated: false, completion: {
            //
            //            })
            
            }, failure: { error in
                // ⚠️ idToken has expired or is no longer valid
                let keychain = A0SimpleKeychain(service: "Auth0")
                guard let refreshToken = keychain.stringForKey("refresh_token") else {
                    keychain.clearAll()
                    return
                }
                let client = A0Lock.sharedLock().apiClient()
                client.fetchNewIdTokenWithRefreshToken(refreshToken,
                    parameters: nil,
                    success: { newToken in
                        // Just got a new idToken!
                        // Don't forget to store it...
                        keychain.setString(newToken.idToken, forKey: "id_token")
                        // ✅ At this point, you can log the user into your app, by navigating to the corresponding screen
                        client.fetchUserProfileWithIdToken(newToken.idToken,
                            success: { profile in
                                // Our idToken is still valid...
                                // We store the fetched user profile
                                keychain.setData(NSKeyedArchiver.archivedDataWithRootObject(profile), forKey: "profile")
                                // ✅ At this point, you can log the user into your app, by navigating to the corresponding screen
                                App.Memory.currentUser.loggedIn = true
                                App.Memory.currentUser.idToken = newToken.idToken
                                App.Memory.currentUser.profile = profile
                                //                                UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(tbc, animated: false, completion: {
                                //
                                //                                })
                            },
                            failure: { error in
                                // ⚠️ idToken has expired or is no longer valid
                                // See step 4
                        })
                        
                    },
                    failure: { error in
                        // refreshToken is no longer valid (e.g. it has been revoked)
                        // Cleaning stored values since they are no longer valid
                        keychain.clearAll()
                        // ⛔️ At this point, you should ask the user to enter his credentials again!
                })
        })

        
    }
    
    static func authenticateUser2() {
        
        // Check if token exists
        guard let token = A0SimpleKeychain().stringForKey("token") else {
            // User doesn't exist, user has to enter login details
            
            // Present login screen
            
            return
        }
        
        // Token exists
        // Validate token
        
        let url = "http://127.0.0.1:8000/api/users/user-detail/"
        
        let headers = ["Accept": "application/json", "Authorization" : "Token c40ef966910e2b27239d8e2a7a28f4cdb756c094"]
        
        Alamofire.request(.GET, url, encoding: .JSON, headers: headers)
            .responseJSON { response in
                debugPrint(response)
                
                if let json = response.result.value {
                    // request gives user info
                    
                    if let id = json["id"] {
                        
                        if let email = json["email"] {
                            
                            if let username = json["username"] {
                                
                            }
                        }
                    }
                } else {
                    // request failed (Probably invalid token)
                    // So show login screen and login user
                    
                }
        }
        
        
        // let jwt = A0SimpleKeychain().setString(jwt, forKey:"auth0-user-jwt")
    }

    
    static func getDateFromString(string: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssz"
        return dateFormatter.dateFromString(string)!
    }
}




