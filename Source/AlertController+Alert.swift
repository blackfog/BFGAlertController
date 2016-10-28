//
//  AlertController+Alert.swift
//
//  Created by Craig Pearlman on 2015-07-02.
//

import UIKit

extension AlertController {
    func showAlert() {
        precondition(self.alertActions.count > 0, "Alert has no actions")
        
        self.addShade()
        
        self.alertContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 150)) // arbitrary
        
        self.alertContainerView?.backgroundColor = self.backgroundColor
        self.alertContainerView?.transform = CGAffineTransform(scaleX: 0, y: 0)
        self.alertContainerView?.translatesAutoresizingMaskIntoConstraints = false
        self.alertContainerView?.layer.cornerRadius = self.cornerRadius
        self.alertContainerView?.clipsToBounds = true

        self.shadeView?.addSubview(self.alertContainerView!)

        self.alertContainerViewHeight = NSLayoutConstraint(
            item: self.alertContainerView!, attribute: .height,
                relatedBy: .equal,
            toItem: nil, attribute: .notAnAttribute,
                multiplier: 1.0, constant: 150.0 // arbitrary
        )

        self.alertContainerViewCenterY = NSLayoutConstraint(
            item: self.alertContainerView!, attribute: .centerY,
                relatedBy: .equal,
            toItem: self.shadeView!, attribute: .centerY,
                multiplier: 1.0, constant: 1.0
        )

        self.shadeView?.addConstraints([
            NSLayoutConstraint(
                item: self.alertContainerView!, attribute: .centerX,
                    relatedBy: .equal,
                toItem: self.shadeView!, attribute: .centerX,
                    multiplier: 1.0, constant: 1.0
            ),
            self.alertContainerViewCenterY!,
            self.alertContainerViewHeight!,
            NSLayoutConstraint(
                item: self.alertContainerView!, attribute: .width,
                    relatedBy: .equal,
                toItem: nil, attribute: .notAnAttribute,
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
        
        UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.05,
            options: .curveLinear, animations: {
                self.alertContainerView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
    }
    
    func hideAlert() {
        self.alertContainerView?.alpha = 0
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
    
    func createLabel(textColor: UIColor, font: UIFont, text: String?) -> UILabel? {
        if let text = text  {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30)) // arbitrary
            label.textColor = textColor
            label.font = font
            label.textAlignment = .center
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.text = text
            label.translatesAutoresizingMaskIntoConstraints = false
            
            self.alertContainerView?.addSubview(label)
            
            return label
        }
        
        return nil
    }
    
    func sizeForLabel(_ label: UILabel?) -> CGRect {
        if let label = label {
            let rect = NSString(string: label.text!).boundingRect(
                with: CGSize(width: label.bounds.width, height: CGFloat.greatestFiniteMagnitude),
                options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading],
                attributes: [NSFontAttributeName: label.font],
                context: nil
            )
            
            return CGRect(x: rect.origin.x, y: rect.origin.y, width: ceil(rect.size.width), height: ceil(rect.size.height))
        }
        else {
            return CGRect()
        }
    }

    func widthForLabel(_ label: UILabel?) -> CGFloat {
        return self.sizeForLabel(label).width
    }
    
    func heightForLabel(_ label: UILabel?) -> CGFloat {
        return self.sizeForLabel(label).height
    }
    
    func layoutLabelInView(_ targetView: UIView, label: UILabel, alignToView: UIView, alignToAttribute: NSLayoutAttribute) {
        targetView.addConstraints([
            NSLayoutConstraint(
                item: label, attribute: .top,
                    relatedBy: .equal,
                toItem: alignToView, attribute: alignToAttribute,
                    multiplier: 1.0, constant: self.alertPadding
            ),
            NSLayoutConstraint(
                item: label, attribute: .leading,
                    relatedBy: .equal,
                toItem: targetView, attribute: .leading,
                    multiplier: 1.0, constant: self.alertPadding
            ),
            NSLayoutConstraint(
                item: label, attribute: .trailing,
                    relatedBy: .equal,
                toItem: targetView, attribute: .trailing,
                    multiplier: 1.0, constant: -self.alertPadding
            ),
            NSLayoutConstraint(
                item: label, attribute: .height,
                    relatedBy: .equal,
                toItem: nil, attribute: .notAnAttribute,
                    multiplier: 1.0, constant: self.heightForLabel(label)
            )
        ])
    }
    
    func layoutLabels() {
        var alignTitleToView: UIView? = self.alertContainerView
        let alignTitleToAttribute: NSLayoutAttribute = .top
        
        var alignMessageToView: UIView? = self.alertTitleLabel
        var alignMessageToAttribute: NSLayoutAttribute = .bottom
        
        if self.alertTitle != nil && self.alertMessage == nil {
            alignMessageToView = nil
        }
        else if self.alertTitle == nil && self.alertMessage != nil {
            alignTitleToView = nil
            alignMessageToView = self.alertContainerView
            alignMessageToAttribute = .top
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
            self.alertFieldView = AlertSimpleStackView(views: self.alertFields)
            self.alertFieldView?.dividerHeight = 0
            self.alertFieldView?.translatesAutoresizingMaskIntoConstraints = false
            
            self.alertContainerView?.addSubview(self.alertFieldView!)
            
            let attachToView = self.alertMessage == nil ? self.alertTitleLabel! : self.alertMessageLabel!
            
            self.alertContainerView?.addConstraints([
                NSLayoutConstraint(
                    item: self.alertFieldView!, attribute: .top,
                        relatedBy: .equal,
                    toItem: attachToView, attribute: .bottom,
                        multiplier: 1.0, constant: self.alertPadding
                ),
                NSLayoutConstraint(
                    item: self.alertFieldView!, attribute: .leading,
                        relatedBy: .equal,
                    toItem: self.alertContainerView!, attribute: .leading,
                        multiplier: 1.0, constant: self.alertPadding
                ),
                NSLayoutConstraint(
                    item: self.alertFieldView!, attribute: .trailing,
                        relatedBy: .equal,
                    toItem: self.alertContainerView!, attribute: .trailing,
                        multiplier: 1.0, constant: -self.alertPadding
                ),
                NSLayoutConstraint(
                    item: self.alertFieldView!, attribute: .height,
                        relatedBy: .equal,
                    toItem: nil, attribute: .notAnAttribute,
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
        self.alertDivider?.translatesAutoresizingMaskIntoConstraints = false
        
        self.alertContainerView?.addSubview(self.alertDivider!)
        
        var alignTo: UIView? = self.alertMessageLabel != nil ? self.alertMessageLabel : self.alertTitleLabel
        if self.alertFieldView != nil { alignTo = self.alertFieldView }
        
        self.alertContainerView?.addConstraints([
            NSLayoutConstraint(
                item: self.alertDivider!, attribute: .top,
                    relatedBy: .equal,
                toItem: alignTo, attribute: .bottom,
                    multiplier: 1.0, constant: self.alertPadding
            ),
            NSLayoutConstraint(
                item: self.alertDivider!, attribute: .leading,
                    relatedBy: .equal,
                toItem: self.alertContainerView!, attribute: .leading,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.alertDivider!, attribute: .trailing,
                    relatedBy: .equal,
                toItem: self.alertContainerView!, attribute: .trailing,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.alertDivider!, attribute: .height,
                    relatedBy: .equal,
                toItem: nil, attribute: .notAnAttribute,
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
                let container = AlertSideBySideView(
                    left: buttons[0],
                    right: buttons[1]
                )
                
                self.alertActionsContainerView = container
                
                container.dividerColor = self.dividerColor
                container.dividerWidth = self.dividerSize
            }
            else {
                self.alertActionsContainerView = AlertSimpleStackView(views: buttons)
                (self.alertActionsContainerView as! AlertSimpleStackView).viewHeight = self.buttonHeight
            }
        }
        else {
            self.alertActionsContainerView = AlertSimpleStackView(views: buttons)
            (self.alertActionsContainerView as! AlertSimpleStackView).viewHeight = self.buttonHeight
        }
        
        self.alertActionsContainerView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.alertContainerView?.addSubview(self.alertActionsContainerView!)
        
        self.alertContainerView?.addConstraints([
            NSLayoutConstraint(
                item: self.alertActionsContainerView!, attribute: .top,
                    relatedBy: .equal,
                toItem: self.alertDivider!, attribute: .bottom,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.alertActionsContainerView!, attribute: .leading,
                    relatedBy: .equal,
                toItem: self.alertContainerView!, attribute: .leading,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.alertActionsContainerView!, attribute: .trailing,
                    relatedBy: .equal,
                toItem: self.alertContainerView!, attribute: .trailing,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.alertActionsContainerView!, attribute: .height,
                    relatedBy: .equal,
                toItem: nil, attribute: .notAnAttribute,
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
        if self.alertActionsContainerView! is AlertSimpleStackView {
            return (CGFloat(self.alertActions.count) * self.buttonHeight) + (CGFloat(self.alertActions.count - 1) * self.dividerSize)
        }
        else if self.alertActionsContainerView! is AlertSideBySideView {
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
