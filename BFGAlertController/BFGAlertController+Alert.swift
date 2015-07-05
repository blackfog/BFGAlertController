//
//  BFGAlertController+Alert.swift
//  Pods
//
//  Created by Craig Pearlman on 2015-07-02.
//
//

import UIKit

extension BFGAlertController {
    func showAlert() {
        precondition(self.alertActions.count > 0, "Alert has no actions")
        
        self.addShade()
        
        self.alertContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 150)) // arbitrary
        
        self.alertContainerView?.backgroundColor = self.backgroundColor
        self.alertContainerView?.transform = CGAffineTransformMakeScale(0, 0)
        self.alertContainerView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.alertContainerView?.layer.cornerRadius = self.cornerRadius
        self.alertContainerView?.clipsToBounds = true

        self.shadeView?.addSubview(self.alertContainerView!)

        self.alertContainerViewHeight = NSLayoutConstraint(
            item: self.alertContainerView!, attribute: .Height,
                relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute,
                multiplier: 1.0, constant: 150.0 // arbitrary
        )

        self.alertContainerViewCenterY = NSLayoutConstraint(
            item: self.alertContainerView!, attribute: .CenterY,
                relatedBy: .Equal,
            toItem: self.shadeView!, attribute: .CenterY,
                multiplier: 1.0, constant: 1.0
        )

        self.shadeView?.addConstraints([
            NSLayoutConstraint(
                item: self.alertContainerView!, attribute: .CenterX,
                    relatedBy: .Equal,
                toItem: self.shadeView!, attribute: .CenterX,
                    multiplier: 1.0, constant: 1.0
            ),
            self.alertContainerViewCenterY!,
            self.alertContainerViewHeight!,
            NSLayoutConstraint(
                item: self.alertContainerView!, attribute: .Width,
                    relatedBy: .Equal,
                toItem: nil, attribute: .NotAnAttribute,
                    multiplier: 1.0, constant: self.alertWidth
            )
        ])

        self.createTitleLabel()
        self.createMessageLabel()
        self.layoutLabels()
        self.addTextFields()
        self.addDivider()
        self.addButtons()
        self.updateAlertHeight()

        if self.alertFields.count > 0 {
            self.alertFields.first?.becomeFirstResponder()
        }
        
        UIView.animateWithDuration(0.33, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.05,
            options: .CurveLinear, animations: {
                self.alertContainerView?.transform = CGAffineTransformMakeScale(1, 1)
            }, completion: nil)
    }
    
    func createTitleLabel() {
        self.alertTitleLabel = self.createLabel(
            textColor: self.titleColor,
            font: self.titleFont,
            text: self.alertTitle
        )
    }
    
    func createMessageLabel() {
        self.alertMessageLabel = self.createLabel(
            textColor: self.messageColor,
            font: self.messageFont,
            text: self.alertMessage
        )
    }
    
    func createLabel(#textColor: UIColor, font: UIFont, text: String?) -> UILabel? {
        if let text = text  {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30)) // arbitrary
            label.textColor = textColor
            label.font = font
            label.textAlignment = .Center
            label.numberOfLines = 0
            label.lineBreakMode = .ByWordWrapping
            label.text = text
            label.setTranslatesAutoresizingMaskIntoConstraints(false)
            
            self.alertContainerView?.addSubview(label)
            
            return label
        }
        
        return nil
    }
    
    func sizeForLabel(label: UILabel?) -> CGRect {
        if let label = label {
            let rect = NSString(string: label.text!).boundingRectWithSize(
                CGSize(width: label.bounds.width, height: CGFloat.max),
                options: NSStringDrawingOptions.UsesLineFragmentOrigin|NSStringDrawingOptions.UsesFontLeading,
                attributes: [NSFontAttributeName: label.font],
                context: nil
            )
            
            return CGRect(x: rect.origin.x, y: rect.origin.y, width: ceil(rect.size.width), height: ceil(rect.size.height))
        }
        else {
            return CGRect()
        }
    }

    func widthForLabel(label: UILabel?) -> CGFloat {
        return self.sizeForLabel(label).width
    }
    
    func heightForLabel(label: UILabel?) -> CGFloat {
        return self.sizeForLabel(label).height
    }
    
    func layoutLabelInView(targetView: UIView, label: UILabel, alignToView: UIView, alignToAttribute: NSLayoutAttribute) {
        targetView.addConstraints([
            NSLayoutConstraint(
                item: label, attribute: .Top,
                    relatedBy: .Equal,
                toItem: alignToView, attribute: alignToAttribute,
                    multiplier: 1.0, constant: self.alertPadding
            ),
            NSLayoutConstraint(
                item: label, attribute: .Leading,
                    relatedBy: .Equal,
                toItem: targetView, attribute: .Leading,
                    multiplier: 1.0, constant: self.alertPadding
            ),
            NSLayoutConstraint(
                item: label, attribute: .Trailing,
                    relatedBy: .Equal,
                toItem: targetView, attribute: .Trailing,
                    multiplier: 1.0, constant: -self.alertPadding
            ),
            NSLayoutConstraint(
                item: label, attribute: .Height,
                    relatedBy: .Equal,
                toItem: nil, attribute: .NotAnAttribute,
                    multiplier: 1.0, constant: self.heightForLabel(label)
            )
        ])
    }
    
    func layoutLabels() {
        var alignTitleToView: UIView? = self.alertContainerView
        var alignTitleToAttribute: NSLayoutAttribute = .Top
        
        var alignMessageToView: UIView? = self.alertTitleLabel
        var alignMessageToAttribute: NSLayoutAttribute = .Bottom
        
        if self.alertTitle != nil && self.alertMessage == nil {
            alignMessageToView = nil
        }
        else if self.alertTitle == nil && self.alertMessage != nil {
            alignTitleToView = nil
            alignMessageToView = self.alertContainerView
            alignMessageToAttribute = .Top
        }
        
        if let alignTo = alignTitleToView {
            self.layoutLabelInView(self.alertContainerView!, label: self.alertTitleLabel!, alignToView: alignTo, alignToAttribute: alignTitleToAttribute)
        }
        
        if let alignTo = alignMessageToView {
            self.layoutLabelInView(self.alertContainerView!, label: self.alertMessageLabel!, alignToView: alignTo, alignToAttribute: alignMessageToAttribute)
        }
    }
    
    func addTextFields() {
        if self.alertFields.count > 0 {
            self.alertFieldView = SimpleStackView(views: self.alertFields)
            self.alertFieldView?.dividerHeight = 0
            self.alertFieldView?.setTranslatesAutoresizingMaskIntoConstraints(false)
            
            self.alertContainerView?.addSubview(self.alertFieldView!)
            
            let attachToView = self.alertMessage == nil ? self.alertTitleLabel! : self.alertMessageLabel!
            
            self.alertContainerView?.addConstraints([
                NSLayoutConstraint(
                    item: self.alertFieldView!, attribute: .Top,
                        relatedBy: .Equal,
                    toItem: attachToView, attribute: .Bottom,
                        multiplier: 1.0, constant: self.alertPadding
                ),
                NSLayoutConstraint(
                    item: self.alertFieldView!, attribute: .Leading,
                        relatedBy: .Equal,
                    toItem: self.alertContainerView!, attribute: .Leading,
                        multiplier: 1.0, constant: self.alertPadding
                ),
                NSLayoutConstraint(
                    item: self.alertFieldView!, attribute: .Trailing,
                        relatedBy: .Equal,
                    toItem: self.alertContainerView!, attribute: .Trailing,
                        multiplier: 1.0, constant: -self.alertPadding
                ),
                NSLayoutConstraint(
                    item: self.alertFieldView!, attribute: .Height,
                        relatedBy: .Equal,
                    toItem: nil, attribute: .NotAnAttribute,
                        multiplier: 1.0, constant: self.alertFieldViewHeight()
                )
            ])
        }
    }
    
    func alertFieldViewHeight() -> CGFloat {
        if self.alertFields.count > 0 {
            return self.alertFieldView!.viewHeight * CGFloat(self.alertFields.count)
        }
        else {
            return 0.0
        }
    }
    
    func addDivider() {
        self.alertDivider = UIView(frame: CGRect(x: 0, y: 0, width: self.alertWidth, height: self.dividerSize))
        self.alertDivider?.backgroundColor = self.dividerColor
        self.alertDivider?.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.alertContainerView?.addSubview(self.alertDivider!)
        
        var alignTo: UIView? = self.alertMessageLabel != nil ? self.alertMessageLabel : self.alertTitleLabel
        if self.alertFieldView != nil { alignTo = self.alertFieldView }
        
        self.alertContainerView?.addConstraints([
            NSLayoutConstraint(
                item: self.alertDivider!, attribute: .Top,
                    relatedBy: .Equal,
                toItem: alignTo, attribute: .Bottom,
                    multiplier: 1.0, constant: self.alertPadding
            ),
            NSLayoutConstraint(
                item: self.alertDivider!, attribute: .Leading,
                    relatedBy: .Equal,
                toItem: self.alertContainerView!, attribute: .Leading,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.alertDivider!, attribute: .Trailing,
                    relatedBy: .Equal,
                toItem: self.alertContainerView!, attribute: .Trailing,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.alertDivider!, attribute: .Height,
                    relatedBy: .Equal,
                toItem: nil, attribute: .NotAnAttribute,
                    multiplier: 1.0, constant: self.dividerSize
            )
        ])
    }

    func addButtons() {
        var buttons = [UIButton]()
        
        for action in self.alertActions {
            let button = action.button()
            self.styleButton(button, style: action.style)
            buttons.append(button)
        }

        if buttons.count == 2 {
            if self.widthForLabel(buttons[0].titleLabel) < self.alertWidth / 2 &&
                self.widthForLabel(buttons[1].titleLabel) < self.alertWidth / 2
            {
                let container = SideBySideView(
                    left: buttons[0],
                    right: buttons[1]
                )
                
                self.alertActionsContainerView = container
                
                container.dividerColor = self.dividerColor
                container.dividerWidth = self.dividerSize
            }
            else {
                self.alertActionsContainerView = SimpleStackView(views: buttons)
                (self.alertActionsContainerView as! SimpleStackView).viewHeight = self.buttonHeight
            }
        }
        else {
            self.alertActionsContainerView = SimpleStackView(views: buttons)
            (self.alertActionsContainerView as! SimpleStackView).viewHeight = self.buttonHeight
        }
        
        self.alertActionsContainerView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.alertContainerView?.addSubview(self.alertActionsContainerView!)
        
        self.alertContainerView?.addConstraints([
            NSLayoutConstraint(
                item: self.alertActionsContainerView!, attribute: .Top,
                    relatedBy: .Equal,
                toItem: self.alertDivider!, attribute: .Bottom,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.alertActionsContainerView!, attribute: .Leading,
                    relatedBy: .Equal,
                toItem: self.alertContainerView!, attribute: .Leading,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.alertActionsContainerView!, attribute: .Trailing,
                    relatedBy: .Equal,
                toItem: self.alertContainerView!, attribute: .Trailing,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.alertActionsContainerView!, attribute: .Height,
                    relatedBy: .Equal,
                toItem: nil, attribute: .NotAnAttribute,
                    multiplier: 1.0, constant: self.heightForButtons()
            )
        ])
    }
    
    func alertHeight() -> CGFloat {
        var alertHeight = self.alertPadding * 2

        if self.alertTitle != nil { alertHeight += self.heightForLabel(self.alertTitleLabel) }
        if self.alertMessage != nil { alertHeight += self.heightForLabel(self.alertMessageLabel) }
        if self.alertTitle != nil && self.alertMessage != nil { alertHeight += self.alertPadding }
        
        alertHeight += self.dividerSize
        alertHeight += self.heightForButtons()
        
        var fieldHeight = self.alertFieldViewHeight()
        if fieldHeight > 0 { fieldHeight += 16.0 }
        
        alertHeight += fieldHeight
        
        return alertHeight
    }
    
    func heightForButtons() -> CGFloat {
        if self.alertActionsContainerView! is SimpleStackView {
            return (CGFloat(self.alertActions.count) * self.buttonHeight) + (CGFloat(self.alertActions.count - 1) * self.dividerSize)
        }
        else if self.alertActionsContainerView! is SideBySideView {
            return self.buttonHeight
        }
        else {
            fatalError("Unknown actions container view class")
        }
    }
    
    func updateAlertHeight() {
        self.alertContainerViewHeight?.constant = self.alertHeight()
        self.alertContainerView?.setNeedsLayout()
    }
}
