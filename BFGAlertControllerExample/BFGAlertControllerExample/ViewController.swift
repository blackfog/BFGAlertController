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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showAlert() {
        let alert = BFGAlertController(title: "Title", message: "Message", preferredStyle: .Alert)
        
        alert.addAction(
            BFGAlertAction(title: "OK", style: .Default, handler: { action in
                let x = 1
            })
        )
        
//        alert.modalPresentationStyle = .OverFullScreen
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func showActionSheetModal() {
        
    }
    
    @IBAction func showActionSheetPopover() {
        
    }
}

