//
//  ViewController.swift
//  AlertControllerExample
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
        let alert = AlertController(title: "Alert!", message: "Behold! A message. Aren't you excited?", preferredStyle: .alert)
        
        alert.addAction(
            AlertAction(title: "OK", style: .`default`) { action in
                NSLog("OK")
                alert.dismissViewControllerAnimated(true, completion: nil)
            }
        )
        
        alert.addAction(
            AlertAction(title: "Cancel", style: .cancel) { action in
                NSLog("Cancel")
                alert.dismissViewControllerAnimated(true, completion: nil)
            }
        )

        alert.backgroundColor = UIColor.blackColor()
        alert.shadeOpacity = 0.25
        alert.dividerColor = UIColor.grayColor()
        alert.setTextColor(UIColor.whiteColor(), forButtonStyle: .`default`, state: .normal)
        alert.setBackgroundColor(UIColor.blackColor(), forButtonStyle: .`default`, state: .normal)
        alert.setBackgroundColor(UIColor.darkGrayColor(), forButtonStyle: .`default`, state: .highlighted)
        alert.setBackgroundColor(UIColor.darkGrayColor(), forButtonStyle: .cancel, state: .highlighted)
        alert.titleColor = UIColor.whiteColor()
        alert.messageColor = UIColor.lightTextColor()
        alert.setFont(UIFont.boldSystemFontOfSize(14.0), forButtonStyle: .cancel, state: .normal)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func showAlertWithFields() {
        let alert = AlertController(title: "Log In", message: "Enter your login credentials", preferredStyle: .alert)
        
        alert.addAction(
            AlertAction(title: "OK", style: .`default`) { action in
                NSLog("Log In")
                alert.dismissViewControllerAnimated(true, completion: nil)
            }
        )
        
        alert.addAction(
            AlertAction(title: "Cancel", style: .cancel) { action in
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
        alert.setTextColor(UIColor.whiteColor(), forButtonStyle: .`default`, state: .normal)
        alert.setBackgroundColor(UIColor.blackColor(), forButtonStyle: .`default`, state: .normal)
        alert.setBackgroundColor(UIColor.darkGrayColor(), forButtonStyle: .`default`, state: .highlighted)
        alert.setBackgroundColor(UIColor.darkGrayColor(), forButtonStyle: .cancel, state: .highlighted)
        alert.titleColor = UIColor.whiteColor()
        alert.messageColor = UIColor.lightTextColor()
        alert.setFont(UIFont.boldSystemFontOfSize(14.0), forButtonStyle: .cancel, state: .normal)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func showActionSheetModal() {
        let alert = AlertController(title: nil, message: "Choose one of the following options", preferredStyle: .actionSheet)
        
        alert.addAction(
            AlertAction(title: "Option A", style: .`default`) { action in
                NSLog("Option A")
                alert.dismissViewControllerAnimated(true, completion: nil)
            }
        )

        alert.addAction(
            AlertAction(title: "Option B", style: .`default`) { action in
                NSLog("Option B")
                alert.dismissViewControllerAnimated(true, completion: nil)
            }
        )

        alert.addAction(
            AlertAction(title: "Cancel", style: .cancel) { action in
                NSLog("Cancel")
                alert.dismissViewControllerAnimated(true, completion: nil)
            }
        )

        alert.backgroundColor = UIColor.blackColor()
        alert.shadeOpacity = 0.25
        alert.dividerColor = UIColor.grayColor()
        alert.setTextColor(UIColor.whiteColor(), forButtonStyle: .`default`, state: .normal)
        alert.setBackgroundColor(UIColor.blackColor(), forButtonStyle: .`default`, state: .normal)
        alert.setBackgroundColor(UIColor.darkGrayColor(), forButtonStyle: .`default`, state: .highlighted)
        alert.setBackgroundColor(UIColor.darkGrayColor(), forButtonStyle: .cancel, state: .highlighted)
        alert.setBackgroundColor(UIColor.redColor(), forButtonStyle: .cancel, state: .normal)
        alert.titleColor = UIColor.whiteColor()
        alert.messageColor = UIColor.lightTextColor()
        alert.setFont(UIFont.boldSystemFontOfSize(14.0), forButtonStyle: .cancel, state: .normal)
        alert.alertPadding = 6.0
        alert.cornerRadius = 4.0
        alert.buttonHeight = 40.0

        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func showActionSheetPopover() {
        // TODO
    }
}
