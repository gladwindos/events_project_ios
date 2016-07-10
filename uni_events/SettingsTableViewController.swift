//
//  SettingsTableViewController.swift
//  uni_events
//
//  Created by Gladwin Dosunmu on 07/07/2016.
//  Copyright © 2016 Gladwin Dosunmu. All rights reserved.
//

import UIKit
import Lock
import SimpleKeychain

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.title = "Settings"
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
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("settings cell", forIndexPath: indexPath)

        if App.Memory.currentUser.loggedIn {
            cell.textLabel?.text = "Logout"
        } else {
            cell.textLabel?.text = "Log In"
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if App.Memory.currentUser.loggedIn {
            let keychain = A0SimpleKeychain(service: "Auth0")
            keychain.clearAll()
            App.Memory.currentUser.loggedIn = false
        } else {
            let controller = A0Lock.sharedLock().newLockViewController()
            controller.closable = true
            controller.onAuthenticationBlock = { profile, token in
                // Do something with token  profile. e.g.: save them.
                // Lock will not save these objects for you.
                
                let keychain = A0SimpleKeychain(service: "Auth0")
                keychain.setString(token!.idToken, forKey: "id_token")
                keychain.setString(token!.refreshToken!, forKey: "refresh_token") // Add this line
                
                App.Memory.currentUser.loggedIn = true
                App.Memory.currentUser.idToken = (token?.idToken)!
                App.Memory.currentUser.profile = profile!
                // Don't forget to dismiss the Lock controller
                controller.dismissViewControllerAnimated(true, completion: nil)
                self.tableView.reloadData()
             }
            A0Lock.sharedLock().presentLockController(controller, fromController: self)
        }
        self.tableView.reloadData()
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
