//
//  FeedTableViewController.swift
//  uni_events
//
//  Created by Gladwin Dosunmu on 21/06/2016.
//  Copyright © 2016 Gladwin Dosunmu. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {
    
    //    let titles = ["Barfest", "Stamina", "Project X", "Acs Summer Break", "Big Narstie"]
    //
    //    let locations = ["Club Republic", "The Forum", "Club Batchwood", "Northampton", "The Forum"]
    //
    //    let images = [UIImage(named: "barfest_image"), UIImage(named: "stamina"), UIImage(named: "projectx"), UIImage(named: "acs_summer_break"), UIImage(named: "big_narstie_forum")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        self.navigationController?.navigationBar.barTintColor = Utilies.hexStringToUIColor("001334")
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.tabBarController?.tabBar.tintColor = Utilies.hexStringToUIColor("001334")
        
        
        App.fetchEvents { (events) in
            
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self.tableView.reloadData()
                
            })
            
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows        
        return App.Memory.eventList.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if (UIScreen.mainScreen().bounds.size.height <= 568) {
            return 127.7
        } else {
            return 150
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textAlignment = NSTextAlignment.Center
        
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Tuesday 21 June 2016"
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("events cell", forIndexPath: indexPath) as! FeedTableViewCell
        
        cell.updateUI(indexPath)
        //        cell.title.text = titles[indexPath.row]
        //        cell.location.text = locations[indexPath.row]
        //        cell.poster.image = images[indexPath.row]
        //        cell.cellImageView.image = images[indexPath.row]
        
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
