//
//  FeedTableViewCell.swift
//  uni_events
//
//  Created by Gladwin Dosunmu on 21/06/2016.
//  Copyright © 2016 Gladwin Dosunmu. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var poster: UIImageView!
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var imageCache = NSCache()
    
    func updateUI(indexPath: NSIndexPath) {
        
//        let allEvents = App.Memory.sortedEvents
        
        let event = App.Memory.sortedEvents![indexPath.section][indexPath.row]
        
        if let eventTitle : String = event.title {
            self.title.text = eventTitle
        }
        if let eventLocation : String? = event.venue_name {
            self.location.text = eventLocation
        }
        
        self.poster.image = UIImage(named: "placeholder")
        self.cellImageView.image = UIImage(named: "light_grey")
        
        if let imageUrl : String? = event.posterUrl {
            
            if let image = imageCache.objectForKey(imageUrl!) as? UIImage {
                print("cache")
                self.poster.image = image
                self.cellImageView.image = image
            } else {
                print("else")
                
                NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: imageUrl!)!, completionHandler: { (data, response, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    let image = UIImage(data: data!)
                    
                    self.imageCache.setObject(image!, forKey: imageUrl!)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.poster.image = image
                        self.cellImageView.image = image
                        
                    })
                    
                    
                }).resume()
            }
        }
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        if (UIScreen.mainScreen().bounds.size.height <= 568) {
            self.frame.size.height = 125.1
        } else {
            self.frame.size.height = 147
        }
    }
    
    
}
