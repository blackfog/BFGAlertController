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

        alert.backgroundColor = UIColor.blackColor()
        alert.shadeOpacity = 0.25
        alert.dividerColor = UIColor.grayColor()
        alert.setTextColor(UIColor.whiteColor(), forButtonStyle: .Default, state: .Normal)
        alert.setBackgroundColor(UIColor.blackColor(), forButtonStyle: .Default, state: .Normal)
        alert.setBackgroundColor(UIColor.darkGrayColor(), forButtonStyle: .Default, state: .Highlighted)
        alert.setBackgroundColor(UIColor.darkGrayColor(), forButtonStyle: .Cancel, state: .Highlighted)
        alert.titleColor = UIColor.whiteColor()
        alert.messageColor = UIColor.lightTextColor()
        alert.setFont(UIFont.boldSystemFontOfSize(14.0), forButtonStyle: .Cancel, state: .Normal)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func showAlertWithFields() {
        let alert = BFGAlertController(title: "Log In", message: "Enter your login credentials", preferredStyle: .Alert)
        
        alert.addAction(
            BFGAlertAction(title: "OK", style: .Default) { action in
                NSLog("Log In")
                alert.dismissViewControllerAnimated(true, completion: nil)
            }
        )
        
        alert.addAction(
            BFGAlertAction(title: "Cancel", style: .Cancel) { action in
                NSLog("Cancel")
                alert.dismissViewControllerAnimated(true, completion: nil)
            }
        )
        
        alert.addTextFieldWithConfigurationHandler { field in
            field.placeholder = "username"
            field.borderStyle = .Line
            field.backgroundColor = UIColor.darkGrayColor()
            field.textColor = UIColor.lightTextColor()
            field.tintColor = UIColor.grayColor()
            field.returnKeyType = .Next
        }

        alert.addTextFieldWithConfigurationHandler { field in
            field.placeholder = "password"
            field.borderStyle = .Line
            field.secureTextEntry = true
            field.backgroundColor = UIColor.darkGrayColor()
            field.textColor = UIColor.lightTextColor()
            field.tintColor = UIColor.grayColor()
            field.tag = 2
            field.returnKeyType = .Send
        }

        alert.backgroundColor = UIColor.blackColor()
        alert.shadeOpacity = 0.25
        alert.dividerColor = UIColor.grayColor()
        alert.setTextColor(UIColor.whiteColor(), forButtonStyle: .Default, state: .Normal)
        alert.setBackgroundColor(UIColor.blackColor(), forButtonStyle: .Default, state: .Normal)
        alert.setBackgroundColor(UIColor.darkGrayColor(), forButtonStyle: .Default, state: .Highlighted)
        alert.setBackgroundColor(UIColor.darkGrayColor(), forButtonStyle: .Cancel, state: .Highlighted)
        alert.titleColor = UIColor.whiteColor()
        alert.messageColor = UIColor.lightTextColor()
        alert.setFont(UIFont.boldSystemFontOfSize(14.0), forButtonStyle: .Cancel, state: .Normal)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func showActionSheetModal() {
        let alert = BFGAlertController(title: nil, message: "Choose one of the following options", preferredStyle: .ActionSheet)
        
        alert.addAction(
            BFGAlertAction(title: "Option A", style: .Default) { action in
                NSLog("Option A")
                alert.dismissViewControllerAnimated(true, completion: nil)
            }
        )

        alert.addAction(
            BFGAlertAction(title: "Option B", style: .Default) { action in
                NSLog("Option B")
                alert.dismissViewControllerAnimated(true, completion: nil)
            }
        )

        alert.addAction(
            BFGAlertAction(title: "Cancel", style: .Cancel) { action in
                NSLog("Cancel")
                alert.dismissViewControllerAnimated(true, completion: nil)
            }
        )

        alert.backgroundColor = UIColor.blackColor()
        alert.shadeOpacity = 0.25
        alert.dividerColor = UIColor.grayColor()
        alert.setTextColor(UIColor.whiteColor(), forButtonStyle: .Default, state: .Normal)
        alert.setBackgroundColor(UIColor.blackColor(), forButtonStyle: .Default, state: .Normal)
        alert.setBackgroundColor(UIColor.darkGrayColor(), forButtonStyle: .Default, state: .Highlighted)
        alert.setBackgroundColor(UIColor.darkGrayColor(), forButtonStyle: .Cancel, state: .Highlighted)
        alert.setBackgroundColor(UIColor.redColor(), forButtonStyle: .Cancel, state: .Normal)
        alert.titleColor = UIColor.whiteColor()
        alert.messageColor = UIColor.lightTextColor()
        alert.setFont(UIFont.boldSystemFontOfSize(14.0), forButtonStyle: .Cancel, state: .Normal)
        alert.alertPadding = 6.0
        alert.cornerRadius = 4.0
        alert.buttonHeight = 40.0

        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func showActionSheetPopover() {
        
    }
}

