//
//  ViewController.swift
//  BFGAlertControllerExample
//
//  Created by Craig Pearlman on 2015-06-29.
//  Copyright (c) 2015 Black Fog Interactive. All rights reserved.
//

import UIKit
import BFGAlertController

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // also great when used in the AppDelegate
        BFGAlertController.backgroundColor = UIColor.blackColor()
        BFGAlertController.shadeOpacity = 0.25
        BFGAlertController.dividerColor = UIColor.grayColor()
        BFGAlertController.setTextColor(UIColor.lightTextColor(), forButtonStyle: .Default, state: .Normal)
        BFGAlertController.setBackgroundColor(UIColor.blackColor(), forButtonStyle: .Default, state: .Normal)
        BFGAlertController.setBackgroundColor(UIColor.darkGrayColor(), forButtonStyle: .Default, state: .Highlighted)
        BFGAlertController.setBackgroundColor(UIColor.darkGrayColor(), forButtonStyle: .Cancel, state: .Highlighted)
        BFGAlertController.titleColor = UIColor.lightTextColor()
        BFGAlertController.messageColor = UIColor.lightTextColor()
        BFGAlertController.setFont(UIFont.boldSystemFontOfSize(14.0), forButtonStyle: .Cancel, state: .Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showAlert() {
        let alert = BFGAlertController(title: "Alert!", message: "Behold! A message. Aren't you excited?", preferredStyle: .Alert)
        
        alert.addAction(
            BFGAlertAction(title: "OK", style: .Default) { action in
                NSLog("OK")
                alert.dismissViewControllerAnimated(true, completion: nil)
            }
        )
        
        alert.addAction(
            BFGAlertAction(title: "Cancel", style: .Cancel) { action in
                NSLog("Cancel")
                alert.dismissViewControllerAnimated(true, completion: nil)
            }
        )

        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func showActionSheetModal() {
        
    }
    
    @IBAction func showActionSheetPopover() {
        
    }
}

