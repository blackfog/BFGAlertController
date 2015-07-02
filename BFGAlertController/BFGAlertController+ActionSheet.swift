//
//  BFGAlertController+ActionSheet.swift
//  Pods
//
//  Created by Craig Pearlman on 2015-07-02.
//
//

import UIKit

extension BFGAlertController {
    func showActionSheet() {
        if let popover = self.popoverPresentationController {
            self.showActionSheetInPopover()
        }
        else {
            self.showActionSheetModally()
        }
    }
    
    func showActionSheetModally() {
        self.addShade()
        // create the action sheet itself
    }
    
    func showActionSheetInPopover() {
        // set up the popover and display the action sheet within
    }
    
    func createActionSheet() {
        
    }
}
