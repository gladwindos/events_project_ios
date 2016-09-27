//
//  FeedTableViewController.swift
//  uni_events
//
//  Created by Gladwin Dosunmu on 21/06/2016.
//  Copyright © 2016 Gladwin Dosunmu. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    @IBAction func searchButton(sender: UIBarButtonItem) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        App.authenticateUser()
        
        self.view.makeToastActivity(.Center)
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        App.fetchEvents2 { (events) in
            
            dispatch_async(dispatch_get_main_queue(), {
                self.view.hideToastActivity()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                self.tableView.reloadData()
                
            })
            
        }
        
        menuButton.target = self.revealViewController()
        
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        if self.revealViewController() != nil {
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }

        print(App.Memory.currentUser.loggedIn)
        
        
    }
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont.systemFontOfSize(17, weight: UIFontWeightSemibold),  NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        print(App.Memory.currentUser.loggedIn)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return App.Memory.sortedEvents!.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows        
        return App.Memory.sortedEvents![section].count
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
//        let headerTitle = App.Memory.sortedEvents[section][0].start_date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE dd MMMM"
        let headerTitle = dateFormatter.stringFromDate(App.Memory.sortedEvents![section][0].start_date)
        return headerTitle
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("events cell", forIndexPath: indexPath) as! FeedTableViewCell
        
        cell.updateUI(indexPath)
        
        cell.layoutMargins = UIEdgeInsetsZero
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        App.Memory.currentEvent = App.Memory.sortedEvents![indexPath.section][indexPath.row]
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
