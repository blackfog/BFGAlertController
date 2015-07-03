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
            self.showActionSheetInternal(modal: false)
        }
        else {
            self.showActionSheetInternal(modal: true)
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
    
    func showActionSheetInternal(#modal: Bool) {
        if (modal) { self.addShade() }
        self.createActionSheet()
        
        let targetView = modal ? self.shadeView! : self.popoverPresentationController?.containerView
        
        self.shadeView?.addSubview(self.alertContainerView!)

        let height      = self.calculateHeight()
        let finalBottom = -(self.alertPadding / 2)
        
        self.alertContainerViewHeight = NSLayoutConstraint(
            item: self.alertContainerView!, attribute: .Height,
                relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute,
                multiplier: 1.0, constant: modal ? height : finalBottom
        )

        self.alertContainerViewBottom = NSLayoutConstraint(
            item: self.alertContainerView!, attribute: .Bottom,
                relatedBy: .Equal,
            toItem: targetView, attribute: .Bottom,
                multiplier: 1.0, constant: height
        )

        self.shadeView?.addConstraints([
            self.alertContainerViewBottom!,
            NSLayoutConstraint(
                item: self.alertContainerView!, attribute: .CenterX,
                    relatedBy: .Equal,
                toItem: targetView, attribute: .CenterX,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.alertContainerView!, attribute: .Width,
                    relatedBy: .Equal,
                toItem: nil, attribute: .NotAnAttribute,
                    multiplier: 1.0, constant: self.smallestDimension() - self.alertPadding
            ),
            self.alertContainerViewHeight!
        ])

        if modal {
            dispatch_async(dispatch_get_main_queue()) {
                self.alertContainerViewBottom!.constant = finalBottom
                
                UIView.animateWithDuration(0.2) {
                    self.alertContainerView?.layoutIfNeeded()
                }
            }
        }
        
        // TODO: whatever is necessary to finish popover presentation (the rest should be in place)
    }
    
    func hideModalActionSheet() {
        self.alertContainerViewBottom!.constant = self.calculateHeight()
        
        UIView.animateWithDuration(0.2) {
            self.alertContainerView?.layoutIfNeeded()
        }
    }
    
    // TODO: add support for title/message
    func createActionSheet() {
        self.addMainButtons()
        self.addAltButtons()
        
        self.alertContainerView = SimpleStackView(views: [self.alertActionsContainerView!, self.alertActionsAltContainerView!])
        (self.alertContainerView as! SimpleStackView).dividerColor = UIColor.clearColor()
        (self.alertContainerView as! SimpleStackView).dividerHeight = self.alertPadding / 2
        (self.alertContainerView as! SimpleStackView).viewHeights = [self.defaultsHeight(), self.nonDefaultsHeight()]
        
        self.alertContainerView?.setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    
    func addMainButtons() {
        var buttons = [UIButton]()
        
        for action in self.alertActions {
            if (action.style == .Default) {
                let button = action.button()
                self.styleButton(button, style: action.style)
                buttons.append(button)
            }
        }
        
        self.alertActionsContainerView = SimpleStackView(views: buttons)
        self.alertActionsContainerView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.alertActionsContainerView?.layer.cornerRadius = self.cornerRadius / 2
        self.alertActionsContainerView?.layer.masksToBounds = true
    }
    
    func addAltButtons() {
        var buttons = [UIButton]()
        
        for action in self.alertActions {
            if (action.style != .Default) {
                let button = action.button()
                self.styleButton(button, style: action.style)
                buttons.append(button)
            }
        }
        
        self.alertActionsAltContainerView = SimpleStackView(views: buttons)
        self.alertActionsAltContainerView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.alertActionsAltContainerView?.layer.cornerRadius = self.cornerRadius / 2
        self.alertActionsAltContainerView?.layer.masksToBounds = true
    }
    
    func defaultsHeight() -> CGFloat {
        var count = 0
        
        for action in self.alertActions {
            if (action.style == .Default) {
                count++
            }
        }
        
        return (CGFloat(count) * self.buttonHeight) + (CGFloat(count - 1) * self.dividerSize)
    }
    
    func nonDefaultsHeight() -> CGFloat {
        var count = 0
        
        for action in self.alertActions {
            if (action.style != .Default) {
                count++
            }
        }
        
        return (CGFloat(count) * self.buttonHeight) + (CGFloat(count - 1) * self.dividerSize)
    }
    
    func calculateHeight() -> CGFloat {
        // TODO: add in the heights for title and message
        return self.defaultsHeight() + self.alertPadding + self.nonDefaultsHeight()
    }
}
