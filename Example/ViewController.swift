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
                alert.dismiss(animated: true, completion: nil)
            }
        )
        
        alert.addAction(
            AlertAction(title: "Cancel", style: .cancel) { action in
                NSLog("Cancel")
                alert.dismiss(animated: true, completion: nil)
            }
        )

        alert.backgroundColor = UIColor.black
        alert.shadeOpacity = 0.25
        alert.dividerColor = UIColor.gray
        alert.setTextColor(UIColor.white, forButtonStyle: .`default`, state: .normal)
        alert.setBackgroundColor(UIColor.black, forButtonStyle: .`default`, state: .normal)
        alert.setBackgroundColor(UIColor.darkGray, forButtonStyle: .`default`, state: .highlighted)
        alert.setBackgroundColor(UIColor.darkGray, forButtonStyle: .cancel, state: .highlighted)
        alert.titleColor = UIColor.white
        alert.messageColor = UIColor.lightText
        alert.setFont(UIFont.boldSystemFont(ofSize: 14.0), forButtonStyle: .cancel, state: .normal)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showAlertWithFields() {
        let alert = AlertController(title: "Log In", message: "Enter your login credentials", preferredStyle: .alert)
        
        alert.addAction(
            AlertAction(title: "OK", style: .`default`) { action in
                NSLog("Log In")
                alert.dismiss(animated: true, completion: nil)
            }
        )
        
        alert.addAction(
            AlertAction(title: "Cancel", style: .cancel) { action in
                NSLog("Cancel")
                alert.dismiss(animated: true, completion: nil)
            }
        )
        
        alert.addTextFieldWithConfigurationHandler { field in
            field?.placeholder = "username"
            field?.borderStyle = .line
            field?.backgroundColor = UIColor.darkGray
            field?.textColor = UIColor.lightText
            field?.tintColor = UIColor.gray
            field?.returnKeyType = .next
        }

        alert.addTextFieldWithConfigurationHandler { field in
            field?.placeholder = "password"
            field?.borderStyle = .line
            field?.isSecureTextEntry = true
            field?.backgroundColor = UIColor.darkGray
            field?.textColor = UIColor.lightText
            field?.tintColor = UIColor.gray
            field?.tag = 2
            field?.returnKeyType = .send
        }

        alert.backgroundColor = UIColor.black
        alert.shadeOpacity = 0.25
        alert.dividerColor = UIColor.gray
        alert.setTextColor(UIColor.white, forButtonStyle: .`default`, state: .normal)
        alert.setBackgroundColor(UIColor.black, forButtonStyle: .`default`, state: .normal)
        alert.setBackgroundColor(UIColor.darkGray, forButtonStyle: .`default`, state: .highlighted)
        alert.setBackgroundColor(UIColor.darkGray, forButtonStyle: .cancel, state: .highlighted)
        alert.titleColor = UIColor.white
        alert.messageColor = UIColor.lightText
        alert.setFont(UIFont.boldSystemFont(ofSize: 14.0), forButtonStyle: .cancel, state: .normal)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showActionSheetModal() {
        let alert = AlertController(title: nil, message: "Choose one of the following options", preferredStyle: .actionSheet)
        
        alert.addAction(
            AlertAction(title: "Option A", style: .`default`) { action in
                NSLog("Option A")
                alert.dismiss(animated: true, completion: nil)
            }
        )

        alert.addAction(
            AlertAction(title: "Option B", style: .`default`) { action in
                NSLog("Option B")
                alert.dismiss(animated: true, completion: nil)
            }
        )

        alert.addAction(
            AlertAction(title: "Cancel", style: .cancel) { action in
                NSLog("Cancel")
                alert.dismiss(animated: true, completion: nil)
            }
        )

        alert.backgroundColor = UIColor.black
        alert.shadeOpacity = 0.25
        alert.dividerColor = UIColor.gray
        alert.setTextColor(UIColor.white, forButtonStyle: .`default`, state: .normal)
        alert.setBackgroundColor(UIColor.black, forButtonStyle: .`default`, state: .normal)
        alert.setBackgroundColor(UIColor.darkGray, forButtonStyle: .`default`, state: .highlighted)
        alert.setBackgroundColor(UIColor.darkGray, forButtonStyle: .cancel, state: .highlighted)
        alert.setBackgroundColor(UIColor.red, forButtonStyle: .cancel, state: .normal)
        alert.titleColor = UIColor.white
        alert.messageColor = UIColor.lightText
        alert.setFont(UIFont.boldSystemFont(ofSize: 14.0), forButtonStyle: .cancel, state: .normal)
        alert.alertPadding = 6.0
        alert.cornerRadius = 4.0
        alert.buttonHeight = 40.0

        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showActionSheetPopover() {
        // TODO
    }
}
