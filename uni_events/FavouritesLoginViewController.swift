//
//  FavouritesViewController.swift
//  uni_events
//
//  Created by Gladwin Dosunmu on 06/07/2016.
//  Copyright © 2016 Gladwin Dosunmu. All rights reserved.
//

import UIKit
import Lock
import SimpleKeychain

class FavouritesLoginViewController: UIViewController {
    
    @IBAction func loginButton(sender: AnyObject) {        
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
            print(App.Memory.currentUser.idToken)
            print(App.Memory.currentUser.profile!.email)
            // Don't forget to dismiss the Lock controller
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
        A0Lock.sharedLock().presentLockController(controller, fromController: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Favourites"
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
