//
//  DetailViewController.swift
//  uni_events
//
//  Created by Gladwin Dosunmu on 30/06/2016.
//  Copyright © 2016 Gladwin Dosunmu. All rights reserved.
//

import UIKit
import Lock
import SimpleKeychain
import Auth0
import Alamofire

class DetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var poster: UIImageView!
    
    @IBOutlet weak var main_description: UILabel!
    
    @IBOutlet weak var venue: UILabel!
    
    @IBOutlet weak var findTickets: UIView!
    
    func UserInEventFavourites(event: Event, user: User) -> Bool {
        
        if event.favourites_ids.contains(user.profile!.userId) {
            return true
        }
        return false
    }
    
    @IBAction func moreButton(sender: AnyObject) {
        
        let currentEvent = App.Memory.currentEvent
        let currentUser = App.Memory.currentUser
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Options", message: "", preferredStyle: .ActionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        var addOrRemove = ""
        
        if UserInEventFavourites(currentEvent, user: currentUser) {
            addOrRemove = "Remove from"
        } else {
            addOrRemove = "Add to"
        }
        
        
        let FavouritesActionButton: UIAlertAction = UIAlertAction(title: "\(addOrRemove) favourites", style: .Default)
        { action -> Void in
            print("Add to favourites")
//            let url = "http://127.0.0.1:8000/api/events/\(currentEvent.id)/update-favourites/"
            
            let url = "http://uni-events-test.eu-west-1.elasticbeanstalk.com/api/events/\(currentEvent.id)/update-favourites/"
            
            let parameters = ["auth0_favourite_ids" : currentUser.profile!.userId]
            
            let headers = ["Accept": "application/json"]
            
            Alamofire.request(.PUT, url, parameters: parameters, encoding: .JSON, headers: headers)
                .responseJSON { response in
                    debugPrint(response)
            }
            
            if self.UserInEventFavourites(currentEvent, user: currentUser) {
                // user has just been removed from favourites
                currentEvent.favourites_ids.removeObject(currentUser.profile!.userId)
            } else {
                currentEvent.favourites_ids.append(currentUser.profile!.userId)
            }
        }
        actionSheetController.addAction(FavouritesActionButton)
        
        let ShareActionButton: UIAlertAction = UIAlertAction(title: "Share", style: .Default)
        { action -> Void in
            print("Share")
        }
        actionSheetController.addAction(ShareActionButton)
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(App.Memory.currentUser.profile!.userId)
        print(App.Memory.currentEvent.favourites_ids)
        // Do any additional setup after loading the view.
        scrollView.delegate = self
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        let currentEvent = App.Memory.currentEvent
        
        if let eventTitle : String? = currentEvent.title {
            
            self.title = eventTitle
        }
        if let eventDate : String? = Utilies.myDateTimeFormatter(currentEvent.start_date) {
            date.text = eventDate
        }
        if let eventDescription : String? = currentEvent.main_description {
            main_description.text = eventDescription
        }
        if let eventVenue : String? = currentEvent.venue_name + "\n" + currentEvent.venue_address + "\n" + currentEvent.venue_city + "\n" + currentEvent.venue_postcode {
            venue.text = eventVenue
        }
        
        poster.image = nil
        backgroundImage.image = nil
        
        if let imageUrl : String? = currentEvent.posterUrl {
            
                NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: imageUrl!)!, completionHandler: { (data, response, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    let image = UIImage(data: data!)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.poster.image = image
                        self.backgroundImage.image = image
                        
                    })
                    
                    
                }).resume()
        }
        
    }
    
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        findTickets.alpha = 0.4
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        findTickets.alpha = 0.9
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
