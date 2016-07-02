//
//  DetailViewController.swift
//  uni_events
//
//  Created by Gladwin Dosunmu on 30/06/2016.
//  Copyright © 2016 Gladwin Dosunmu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var poster: UIImageView!
    
    @IBOutlet weak var main_description: UILabel!
    
    @IBOutlet weak var venue: UILabel!
    
    @IBOutlet weak var findTickets: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
