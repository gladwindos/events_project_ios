//
//  FavouritesCollectionViewCell.swift
//  uni_events
//
//  Created by Gladwin Dosunmu on 10/07/2016.
//  Copyright © 2016 Gladwin Dosunmu. All rights reserved.
//

import UIKit

class FavouritesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    var imageCache = NSCache()
    
    func updateUI(events:[Event], indexPath: NSIndexPath) {
        
        if let eventTitle : String = events[indexPath.row].title {
            title.text = eventTitle
        }
        
        if let imageUrl : String? = events[indexPath.row].posterUrl {
            
            if let image = imageCache.objectForKey(imageUrl!) as? UIImage {
                
                self.cellImage.image = image
                self.backgroundImage.image = image
                
            } else {
                
                NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: imageUrl!)!, completionHandler: { (data, response, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    let image = UIImage(data: data!)
                    
                    self.imageCache.setObject(image!, forKey: imageUrl!)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.cellImage.image = image
                        self.backgroundImage.image = image
                        
                    })
                    
                    
                }).resume()
            }
        }
        
    }
}
