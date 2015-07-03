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
    
    func hideActionSheet() {
        if let popover = self.popoverPresentationController {
            // nop
        }
        else {
            self.hideModalActionSheet()
        }
    }
    
    func smallestDimension() -> CGFloat {
        let rect     = UIScreen.mainScreen().bounds
        let smallest = min(rect.height, rect.width)
        
        return smallest
    }
    
    func showActionSheetModally() {
        self.addShade()
        self.createActionSheet()
        
        self.shadeView?.addSubview(self.alertContainerView!)
        let height = self.calculateHeight()
        
        self.alertContainerViewHeight = NSLayoutConstraint(
            item: self.alertContainerView!, attribute: .Height,
                relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute,
                multiplier: 1.0, constant: height
        )

        self.alertContainerViewBottom = NSLayoutConstraint(
            item: self.alertContainerView!, attribute: .Bottom,
            relatedBy: .Equal,
            toItem: self.shadeView!, attribute: .Bottom,
            multiplier: 1.0, constant: height
        )

        self.shadeView?.addConstraints([
            self.alertContainerViewBottom!,
            NSLayoutConstraint(
                item: self.alertContainerView!, attribute: .CenterX,
                    relatedBy: .Equal,
                toItem: self.shadeView!, attribute: .CenterX,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.alertContainerView!, attribute: .Width,
                    relatedBy: .Equal,
                toItem: nil, attribute: .NotAnAttribute,
                    multiplier: 1.0, constant: self.smallestDimension() - BFGAlertController.alertPadding
            ),
            self.alertContainerViewHeight!
        ])
        
        dispatch_async(dispatch_get_main_queue()) {
            self.alertContainerViewBottom!.constant = -(BFGAlertController.alertPadding / 2)
            
            UIView.animateWithDuration(0.2) {
                self.alertContainerView?.layoutIfNeeded()
            }
        }
    }
    
    func hideModalActionSheet() {
        self.alertContainerViewBottom!.constant = self.calculateHeight()
        
        UIView.animateWithDuration(0.2) {
            self.alertContainerView?.layoutIfNeeded()
        }
    }
    
    func showActionSheetInPopover() {
        // set up the popover and display the action sheet within
        self.createActionSheet()
    }
    
    // TODO: add support for title/message
    func createActionSheet() {
        self.addMainButtons()
        self.addAltButtons()
        
        self.alertContainerView = SimpleStackView(views: [self.alertActionsContainerView!, self.alertActionsAltContainerView!])
        (self.alertContainerView as! SimpleStackView).dividerColor = UIColor.clearColor()
        (self.alertContainerView as! SimpleStackView).dividerHeight = BFGAlertController.alertPadding / 2
        (self.alertContainerView as! SimpleStackView).viewHeights = [self.defaultsHeight(), self.nonDefaultsHeight()]
        
        self.alertContainerView?.setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    
    func addMainButtons() {
        var buttons = [UIButton]()
        
        for action in self.alertActions {
            if (action.style == .Default) {
                let button = action.button()
                BFGAlertController.styleButton(button, style: action.style)
                buttons.append(button)
            }
        }
        
        self.alertActionsContainerView = SimpleStackView(views: buttons)
        self.alertActionsContainerView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.alertActionsContainerView?.layer.cornerRadius = BFGAlertController.cornerRadius / 2
        self.alertActionsContainerView?.layer.masksToBounds = true
    }
    
    func addAltButtons() {
        var buttons = [UIButton]()
        
        for action in self.alertActions {
            if (action.style != .Default) {
                let button = action.button()
                BFGAlertController.styleButton(button, style: action.style)
                buttons.append(button)
            }
        }
        
        self.alertActionsAltContainerView = SimpleStackView(views: buttons)
        self.alertActionsAltContainerView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.alertActionsAltContainerView?.layer.cornerRadius = BFGAlertController.cornerRadius / 2
        self.alertActionsAltContainerView?.layer.masksToBounds = true
    }
    
    func defaultsHeight() -> CGFloat {
        var count = 0
        
        for action in self.alertActions {
            if (action.style == .Default) {
                count++
            }
        }
        
        return (CGFloat(count) * BFGAlertController.buttonHeight) + (CGFloat(count - 1) * BFGAlertController.dividerSize)
    }
    
    func nonDefaultsHeight() -> CGFloat {
        var count = 0
        
        for action in self.alertActions {
            if (action.style != .Default) {
                count++
            }
        }
        
        return (CGFloat(count) * BFGAlertController.buttonHeight) + (CGFloat(count - 1) * BFGAlertController.dividerSize)
    }
    
    func calculateHeight() -> CGFloat {
        // TODO: add in the heights for title and message
        return self.defaultsHeight() + BFGAlertController.alertPadding + self.nonDefaultsHeight()
    }
}
