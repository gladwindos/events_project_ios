//
//  TabBarController.swift
//  uni_events
//
//  Created by Gladwin Dosunmu on 10/07/2016.
//  Copyright © 2016 Gladwin Dosunmu. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        setNewViewControllers()
        print(App.Memory.currentUser.loggedIn)
    }
    
    func setNewViewControllers() {
        
        
        
        let vc1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("feed nav")
        
        var vc2 = UIViewController()
        
        if (App.Memory.currentUser.loggedIn == false) {
            
            vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("favourites login nav")
            
        } else {
            
            vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("favourites nav")
            
        }
        
        let vc3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("settings nav") as! UINavigationController
        
        setViewControllers([vc1, vc2, vc3], animated: true)
        
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
