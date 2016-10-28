//
//  AlertController+ActionSheet.swift
//
//  Created by Craig Pearlman on 2015-07-02.
//

import UIKit

extension AlertController {
    func showActionSheet() {
        if self.popoverPresentationController != nil {
            self.showActionSheetInternal(modal: false)
        }
        else {
            self.showActionSheetInternal(modal: true)
        }
    }
    
    func hideActionSheet() {
        if self.popoverPresentationController == nil {
            self.hideModalActionSheet()
        }
    }
    
    func smallestDimension() -> CGFloat {
        let rect     = UIScreen.main.bounds
        let smallest = min(rect.height, rect.width)
        
        if (smallest > 600.0) {
            return 600.0
        }
        
        return smallest
    }
    
    func showActionSheetInternal(modal: Bool) {
        if (modal) { self.addShade() }
        self.createActionSheet()
        
        let presentedView = self.popoverPresentationController?.presentedView
        let targetView = modal ? self.shadeView! : presentedView!
        
        targetView.addSubview(self.alertContainerView!)

        let height      = self.calculateHeight()
        let width       = modal ? self.smallestDimension() - self.alertPadding * 2 : targetView.bounds.size.width
        let finalBottom = -self.alertPadding
        
        if !modal {
            self.preferredContentSize = CGSize(width: width + self.alertPadding * 2, height: height + self.alertPadding * 2)
        }
        
        self.alertContainerViewHeight = NSLayoutConstraint(
            item: self.alertContainerView!, attribute: .height,
                relatedBy: .equal,
            toItem: nil, attribute: .notAnAttribute,
                multiplier: 1.0, constant: height
        )

        self.alertContainerViewBottom = NSLayoutConstraint(
            item: self.alertContainerView!, attribute: .bottom,
                relatedBy: .equal,
            toItem: targetView, attribute: .bottom,
                multiplier: 1.0, constant: modal ? height : -self.alertPadding
        )

        targetView.addConstraints([
            self.alertContainerViewBottom!,
            NSLayoutConstraint(
                item: self.alertContainerView!, attribute: .centerX,
                    relatedBy: .equal,
                toItem: targetView, attribute: .centerX,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.alertContainerView!, attribute: .width,
                    relatedBy: .equal,
                toItem: nil, attribute: .notAnAttribute,
                    multiplier: 1.0, constant: width
            ),
            self.alertContainerViewHeight!
        ])

        if modal {
            DispatchQueue.main.async {
                self.alertContainerViewBottom!.constant = finalBottom
                
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                    self.alertContainerView?.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    func hideModalActionSheet() {
        self.alertContainerViewBottom!.constant = self.calculateHeight()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.alertContainerView?.layoutIfNeeded()
        }) 
    }
    
    func createActionSheet() {
        self.addMainButtons()
        self.addAltButtons()
        
        self.alertContainerView = AlertSimpleStackView(views: [self.alertActionsContainerView!, self.alertActionsAltContainerView!])
        (self.alertContainerView as! AlertSimpleStackView).dividerColor = UIColor.clear
        (self.alertContainerView as! AlertSimpleStackView).dividerHeight = self.alertPadding
        (self.alertContainerView as! AlertSimpleStackView).viewHeights = [self.defaultsHeight(), self.nonDefaultsHeight()]
        
        self.alertContainerView?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addMainButtons() {
        var buttons = [UIView]()

        let messageView = self.createMessageView()
        
        let titleHeight = self.alertTitleLabel != nil ? self.heightForLabel(self.alertTitleLabel!) : 0
        let messageHeight = self.alertMessageLabel != nil ? self.heightForLabel(self.alertMessageLabel!) : 0
        var messageViewHeight = self.alertPadding * 2
        
        if self.alertTitle != nil { messageViewHeight += titleHeight }
        if self.alertMessage != nil { messageViewHeight += messageHeight }
        if self.alertTitle != nil && self.alertMessage != nil { messageViewHeight += self.alertPadding }

        let wrapperView = UIView()
        
        wrapperView.backgroundColor = self.backgroundColor
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        
        wrapperView.addSubview(messageView)
        
        wrapperView.addConstraints([
            NSLayoutConstraint(
                item: messageView, attribute: .leading,
                    relatedBy: .equal,
                toItem: wrapperView, attribute: .leading,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: messageView, attribute: .trailing,
                    relatedBy: .equal,
                toItem: wrapperView, attribute: .trailing,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: messageView, attribute: .centerY,
                    relatedBy: .equal,
                toItem: wrapperView, attribute: .centerY,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: messageView, attribute: .height,
                    relatedBy: .equal,
                toItem: nil, attribute: .notAnAttribute,
                    multiplier: 1.0, constant: messageViewHeight
            )
        ])
        
        buttons.append(wrapperView)
        
        for action in self.alertActions {
            if (action.style == .`default`) {
                let button = action.button()
                self.styleButton(button, style: action.style)
                buttons.append(button)
            }
        }
        
        self.alertActionsContainerView = AlertSimpleStackView(views: buttons)
        self.alertActionsContainerView?.translatesAutoresizingMaskIntoConstraints = false
        self.alertActionsContainerView?.layer.cornerRadius = self.cornerRadius
        self.alertActionsContainerView?.layer.masksToBounds = true
        
        var viewHeights = [CGFloat]()

        for button in buttons {
            if button is UIButton {
                viewHeights.append(self.buttonHeight)
            }
            else {
                viewHeights.append(messageViewHeight >= self.buttonHeight ? messageViewHeight : self.buttonHeight)
            }
        }
        
        (self.alertActionsContainerView as! AlertSimpleStackView).viewHeights = viewHeights
        (self.alertActionsContainerView as! AlertSimpleStackView).dividerColor = self.dividerColor
        (self.alertActionsContainerView as! AlertSimpleStackView).dividerHeight = self.dividerSize
    }
    
    func createMessageView() -> UIView {
        let messageView = UIView()

        messageView.backgroundColor = self.backgroundColor
        messageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.createTitleLabel()
        self.createMessageLabel()
        
        if self.alertTitleLabel != nil { messageView.addSubview(self.alertTitleLabel!) }
        if self.alertMessageLabel != nil { messageView.addSubview(self.alertMessageLabel!) }
        
        self.layoutLabelsInView(messageView)
        
        return messageView
    }
    
    func addAltButtons() {
        var buttons = [UIButton]()
        
        for action in self.alertActions {
            if (action.style != .`default`) {
                let button = action.button()
                self.styleButton(button, style: action.style)
                buttons.append(button)
            }
        }
        
        self.alertActionsAltContainerView = AlertSimpleStackView(views: buttons)
        self.alertActionsAltContainerView?.translatesAutoresizingMaskIntoConstraints = false
        self.alertActionsAltContainerView?.layer.cornerRadius = self.cornerRadius
        self.alertActionsAltContainerView?.layer.masksToBounds = true
        (self.alertActionsAltContainerView as! AlertSimpleStackView).viewHeight = self.buttonHeight
        (self.alertActionsAltContainerView as! AlertSimpleStackView).dividerColor = self.dividerColor
        (self.alertActionsAltContainerView as! AlertSimpleStackView).dividerHeight = self.dividerSize
    }
    
    func layoutLabelsInView(_ targetView: UIView) {
        var alignTitleToView: UIView? = targetView
        let alignTitleToAttribute: NSLayoutAttribute = .top
        
        var alignMessageToView: UIView? = self.alertTitleLabel
        var alignMessageToAttribute: NSLayoutAttribute = .bottom
        
        if self.alertTitle != nil && self.alertMessage == nil {
            alignMessageToView = nil
        }
        else if self.alertTitle == nil && self.alertMessage != nil {
            alignTitleToView = nil
            alignMessageToView = targetView
            alignMessageToAttribute = .top
        }
        
        if let alignTo = alignTitleToView {
            self.layoutLabelInView(targetView, label: self.alertTitleLabel!, alignToView: alignTo, alignToAttribute: alignTitleToAttribute)
        }
        
        if let alignTo = alignMessageToView {
            self.layoutLabelInView(targetView, label: self.alertMessageLabel!, alignToView: alignTo, alignToAttribute: alignMessageToAttribute)
        }
    }

    func defaultsHeight() -> CGFloat {
        var count = 0
        
        for action in self.alertActions {
            if action.style == .`default` {
                count += 1
            }
        }
        
        return (CGFloat(count) * self.buttonHeight) + (CGFloat(count - 1) * self.dividerSize) + self.messageViewHeight()
    }
    
    func nonDefaultsHeight() -> CGFloat {
        var count = 0
        
        for action in self.alertActions {
            if action.style != .`default` {
                count += 1
            }
        }
        
        return (CGFloat(count) * self.buttonHeight) + (CGFloat(count - 1) * self.dividerSize)
    }
    
    func messageViewHeight() -> CGFloat {
        let container  = self.alertContainerView as! AlertSimpleStackView
        let topSection = container.stackViews.first as! AlertSimpleStackView
        
        return topSection.viewHeights.first!
    }
    
    func calculateHeight() -> CGFloat {
        return self.defaultsHeight() + self.alertPadding + self.nonDefaultsHeight()
    }
}
