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
        
    func updateUI(indexPath: NSIndexPath) {
        
        let allEvents = App.Memory.eventList
        
        self.title.text = allEvents[indexPath.row].title
        self.location.text = allEvents[indexPath.row].venue_name
        self.poster.image = UIImage(data: allEvents[indexPath.row].poster)
        self.cellImageView.image = UIImage(data: allEvents[indexPath.row].poster)
        
        
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
