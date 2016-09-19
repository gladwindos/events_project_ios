//
//  MenuTableViewController.swift
//  uni_events
//
//  Created by Gladwin Dosunmu on 26/07/2016.
//  Copyright © 2016 Gladwin Dosunmu. All rights reserved.
//

import UIKit
import Lock
import SimpleKeychain

class MenuTableViewController: UITableViewController {
    
    var currentCell = NSIndexPath(forRow: 0, inSection: 0)
    
    var auth = String()
    
    var menu = [String]()
    
    func setMenu() {
        
        if App.Memory.currentUser.loggedIn {
            auth = "Logout"
        } else {
            auth = "Login"
        }
        
        menu = ["Discover","Favourites", "Contact Us", auth]
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.setMenu()
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setMenu()
        
        self.tableView.tableFooterView = UIView()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menu.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menu cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = menu[indexPath.row]
        
        if indexPath == currentCell {
            cell.textLabel?.textColor = Utilities.hexStringToUIColor("2980b9")
        } else {
            cell.textLabel?.textColor = UIColor.blackColor()
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch menu[indexPath.row] {
        case "Favourites":
            if App.Memory.currentUser.loggedIn {
                currentCell = indexPath
                performSegueWithIdentifier("Favourites", sender: self)
            } else {
                let alert = UIAlertController(title: "Favourites", message: "Please login to view your favourites", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
                    
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    
                }))
                
                alert.addAction(UIAlertAction(title: "Login", style: .Default, handler: { (action) -> Void in
                    let controller = A0Lock.sharedLock().newLockViewController()
                    controller.closable = true
                    controller.onAuthenticationBlock = { profile, token in
                        // Do something with token  profile. e.g.: save them.
                        // Lock will no t save these objects for you.
                        
                        let keychain = A0SimpleKeychain(service: "Auth0")
                        keychain.setString(token!.idToken, forKey: "id_token")
                        keychain.setString(token!.refreshToken!, forKey: "refresh_token") // Add this line
                        
                        App.Memory.currentUser.loggedIn = true
                        App.Memory.currentUser.idToken = (token?.idToken)!
                        App.Memory.currentUser.profile = profile!
                        
                        // Don't forget to dismiss the Lock controller
                        
                        controller.dismissViewControllerAnimated(true, completion: {
                            self.currentCell = indexPath
                        })
                        self.setMenu()
                        self.tableView.reloadData()
                        self.performSegueWithIdentifier("Favourites", sender: self)
                    }
                    A0Lock.sharedLock().presentLockController(controller, fromController: self)
                    
                }))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
        case "Logout":
            if App.Memory.currentUser.loggedIn {
                currentCell = NSIndexPath(forRow: 0, inSection: 0)
                let keychain = A0SimpleKeychain(service: "Auth0")
                keychain.clearAll()
                App.Memory.currentUser.loggedIn = false
                App.Memory.currentUser.profile = nil
                self.view.makeToast("Logged out", duration: 3.0, position: .Center)
                self.setMenu()
                self.tableView.reloadData()
                
                performSegueWithIdentifier("Events", sender: self)
                
            }
        case "Login":
            if App.Memory.currentUser.loggedIn == false {
                
                let controller = A0Lock.sharedLock().newLockViewController()
                controller.closable = true
                controller.onAuthenticationBlock = { profile, token in
                    // Do something with token  profile. e.g.: save them.
                    // Lock will no t save these objects for you.
                    
                    let keychain = A0SimpleKeychain(service: "Auth0")
                    keychain.setString(token!.idToken, forKey: "id_token")
                    keychain.setString(token!.refreshToken!, forKey: "refresh_token") // Add this line
                    
                    App.Memory.currentUser.loggedIn = true
                    App.Memory.currentUser.idToken = (token?.idToken)!
                    App.Memory.currentUser.profile = profile!
                    
                    // Don't forget to dismiss the Lock controller
                    controller.dismissViewControllerAnimated(true, completion: nil)
                    self.setMenu()
                    self.tableView.reloadData()
                    self.performSegueWithIdentifier("Events", sender: self)
                }
                A0Lock.sharedLock().presentLockController(controller, fromController: self)
            }
//        case "Call a Cab":
//            currentCell = indexPath
//            performSegueWithIdentifier("Call a Cab", sender: self)
        case "Contact Us":
            let email = "motive.app1@gmail.com"
            let url = NSURL(string: "mailto:\(email)")
            UIApplication.sharedApplication().openURL(url!)
            self.revealViewController().pushFrontViewController(self.revealViewController().frontViewController, animated: true)
            
        default:
            currentCell = indexPath
            performSegueWithIdentifier("Events", sender: self)
        }
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
