//
//  BFGAlertController.swift
//  TextTool2c
//
//  Created by Craig Pearlman on 2015-06-29.
//  Copyright (c) 2015 Black Fog Interactive. All rights reserved.
//

import UIKit

// MARK: - Style Enum

public enum BFGAlertControllerStyle : Int {
    case ActionSheet
    case Alert
}

// MARK: - Main
public class BFGAlertController: UIViewController {
    // MARK: - Public Declarations
    
    public var alertTitle: String?
    public var alertMessage: String?
    public var showing = false
    
    // MARK: - Private Declarations
    
    private var style: BFGAlertControllerStyle = .Alert
    private var shadeView: UIView?
    private var alertContainerView: UIView?
    private var alertContainerViewHeight: NSLayoutConstraint?
    private var alertTitleLabel: UILabel?
    private var alertMessageLabel: UILabel?
    private var alertDivider: UIView?
    private var alertActionCollectionView: UICollectionView?
    private var alertActions = [BFGAlertAction]()
    private var alertFields = [UITextField]()
    
    public var actions: [BFGAlertAction] {
        return self.alertActions
    }
    
    public var textFields: [UITextField] {
        return self.alertFields
    }
    
    // MARK: - Public Static Declarations
    
    public static var backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.925)
    public static var titleColor      = UIColor.blackColor()
    public static var titleFont       = UIFont.boldSystemFontOfSize(16.0)
    public static var messageColor    = UIColor.blackColor()
    public static var messageFont     = UIFont.systemFontOfSize(14.0)
    public static var shadeOpacity    = CGFloat(0.4)
    public static var shadeColor      = UIColor.blackColor()
    public static var cornerRadius    = CGFloat(12.0)
    public static var dividerColor    = BFGAlertController.shadeColor.colorWithAlphaComponent(BFGAlertController.shadeOpacity)
    public static var dividerHeight   = CGFloat(0.5)
    
    // MARK: - Private Static Declarations
    
    typealias ButtonBackgroundColorType = [BFGAlertActionStyle : [BFGAlertActionState : UIColor]]
    typealias ButtonTextColorType = [BFGAlertActionStyle : [BFGAlertActionState : UIColor]]
    typealias ButtonFontType = [BFGAlertActionStyle : [BFGAlertActionState : UIFont]]
    
    private static var buttonBackgroundColor: ButtonBackgroundColorType = [.Default : [.Normal : UIColor.whiteColor()]]
    private static var buttonTextColor: ButtonTextColorType = [.Default : [.Normal : UIColor.blackColor()]]
    private static var buttonFont: ButtonFontType = [.Default : [.Normal : UIFont.systemFontOfSize(14.0)]]
    
    private static let alertWidth: CGFloat = 300.0
    private static let alertPadding: CGFloat = 16.0
    private static let buttonHeight: CGFloat = 40.0
    
    // MARK: - Constructors
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init(title: String?, message: String?, preferredStyle: BFGAlertControllerStyle) {
        self.init(nibName: nil, bundle: nil)

        self.alertTitle   = title
        self.alertMessage = message
        self.style        = preferredStyle
        
        self.modalPresentationStyle = .OverFullScreen
    }
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        self.view = UIView()
        self.view?.backgroundColor = UIColor.clearColor()
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.show()
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.hide()
    }
    
    // MARK: - Public
    
    public func actionAtIndex(index: Int) -> BFGAlertAction {
        return self.alertActions[index]
    }
    
    public func addAction(action: BFGAlertAction) {
        self.alertActions.append(action)
    }
    
    public func addTextFieldWithConfigurationHandler(configurationHandler: ((UITextField!) -> Void)!) {
        let field = UITextField()
        configurationHandler(field)
        self.alertFields.append(field)
    }
}

// MARK: - Appearance
public extension BFGAlertController {
    public class func backgroundColor(forButtonStyle style: BFGAlertActionStyle, state: BFGAlertActionState) -> UIColor? {
        if let styleProps = self.buttonBackgroundColor[style], color = styleProps[state] {
            return color
        }
        
        if let styleProps = self.buttonBackgroundColor[.Default], color = styleProps[.Normal] {
            return color
        }
        
        return nil
    }
    
    public class func setBackgroundColor(color: UIColor, forButtonStyle style: BFGAlertActionStyle, state: BFGAlertActionState) {
        self.buttonBackgroundColor[style] = [state : color]
    }

    public class func textColor(forButtonStyle style: BFGAlertActionStyle, state: BFGAlertActionState) -> UIColor? {
        if let styleProps = self.buttonTextColor[style], color = styleProps[state] {
            return color
        }
        
        if let styleProps = self.buttonTextColor[.Default], color = styleProps[.Normal] {
            return color
        }
        
        return nil
    }
    
    public class func setTextColor(color: UIColor, forButtonStyle style: BFGAlertActionStyle, state: BFGAlertActionState) {
        self.buttonTextColor[style] = [state: color]
    }

    public class func font(forButtonStyle style: BFGAlertActionStyle, state: BFGAlertActionState) -> UIFont? {
        if let styleProps = self.buttonFont[style], font = styleProps[state] {
            return font
        }

        if let styleProps = self.buttonFont[.Default], font = styleProps[.Normal] {
            return font
        }
        
        return nil
    }
    
    public class func setFont(font: UIFont, forButtonStyle style: BFGAlertActionStyle, state: BFGAlertActionState) {
        self.buttonFont[style] = [state: font]
    }
}

// MARK: - Private
extension BFGAlertController {
    private func addShade() {
        self.shadeView = UIView(frame: UIScreen.mainScreen().bounds)
        self.shadeView?.backgroundColor = BFGAlertController.shadeColor.colorWithAlphaComponent(BFGAlertController.shadeOpacity)
        self.shadeView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.shadeView?.alpha = 0

        self.view?.addSubview(self.shadeView!)
        
        self.view?.addConstraint(
            NSLayoutConstraint(item: self.shadeView!, attribute: .Top, relatedBy: .Equal,
                toItem: self.view!, attribute: .Top, multiplier: 1.0, constant: 0.0)
        )

        self.view?.addConstraints([
            NSLayoutConstraint(
                item: self.shadeView!, attribute: .Bottom,
                    relatedBy: .Equal,
                toItem: self.view!, attribute: .Bottom,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.shadeView!, attribute: .Leading,
                    relatedBy: .Equal,
                toItem: self.view!, attribute: .Leading,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.shadeView!, attribute: .Trailing,
                    relatedBy: .Equal,
                toItem: self.view!, attribute: .Trailing,
                    multiplier: 1.0, constant: 0.0
            )
        ])
        
        UIView.animateWithDuration(0.2) {
            self.shadeView?.alpha = 1.0
        }
    }
    
    private func show() {
        precondition(self.alertTitle != nil || self.alertMessage != nil, "One of alert title or message is required")
        
        switch (self.style) {
            case .Alert:
                self.showAlert()
            case .ActionSheet:
                self.showActionSheet()
        }
    }

    private func hide() {
        // TODO
    }
}

// MARK: - Alert
extension BFGAlertController {
    private func showAlert() {
        precondition(self.alertActions.count > 0, "Alert has no actions")
        
        self.addShade()
        
        self.alertContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 150)) // arbitrary
        
        self.alertContainerView?.backgroundColor = BFGAlertController.backgroundColor
        self.alertContainerView?.transform = CGAffineTransformMakeScale(0, 0)
        self.alertContainerView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.alertContainerView?.layer.cornerRadius = BFGAlertController.cornerRadius

        self.shadeView?.addSubview(self.alertContainerView!)

        self.alertContainerViewHeight = NSLayoutConstraint(
            item: self.alertContainerView!, attribute: .Height,
            relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute,
            multiplier: 1.0, constant: 150.0 // arbitrary
        )

        self.shadeView?.addConstraints([
            NSLayoutConstraint(
                item: self.alertContainerView!, attribute: .CenterX,
                    relatedBy: .Equal,
                toItem: self.shadeView!, attribute: .CenterX,
                    multiplier: 1.0, constant: 1.0
            ),
            NSLayoutConstraint(
                item: self.alertContainerView!, attribute: .CenterY,
                    relatedBy: .Equal,
                toItem: self.shadeView!, attribute: .CenterY,
                    multiplier: 1.0, constant: 1.0
            ),
            self.alertContainerViewHeight!,
            NSLayoutConstraint(
                item: self.alertContainerView!, attribute: .Width,
                    relatedBy: .Equal,
                toItem: nil, attribute: .NotAnAttribute,
                    multiplier: 1.0, constant: BFGAlertController.alertWidth
            )
        ])

        self.createTitleLabel()
        var titleHeight: CGFloat = 0.0
        
        self.createMessageLabel()
        var messageHeight: CGFloat = 0.0
        
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
            titleHeight = self.layoutLabel(self.alertTitleLabel!, alignToView: alignTo, alignToAttribute: alignTitleToAttribute)
        }
        
        if let alignTo = alignMessageToView {
            messageHeight = self.layoutLabel(self.alertMessageLabel!, alignToView: alignTo, alignToAttribute: alignMessageToAttribute)
        }

        self.addDivider()
        self.addButtons()

        self.alertContainerViewHeight?.constant = self.alertHeight(
            titleHeight: titleHeight,
            messageHeight: messageHeight,
            buttonHeight: BFGAlertController.buttonHeight  // FIXME: buttonHeight is temporary
        )
        
        self.alertContainerView?.setNeedsLayout()
        
        UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.05,
            options: .CurveLinear, animations: {
                self.alertContainerView?.transform = CGAffineTransformMakeScale(1, 1)
            }, completion: nil)
    }
    
    private func createTitleLabel() {
        self.alertTitleLabel = self.createLabel(
            textColor: BFGAlertController.titleColor,
            font: BFGAlertController.titleFont,
            text: self.alertTitle
        )
    }
    
    private func createMessageLabel() {
        self.alertMessageLabel = self.createLabel(
            textColor: BFGAlertController.messageColor,
            font: BFGAlertController.messageFont,
            text: self.alertMessage
        )
    }
    
    private func createLabel(#textColor: UIColor, font: UIFont, text: String?) -> UILabel? {
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
    
    private func layoutLabel(label: UILabel, alignToView: UIView, alignToAttribute: NSLayoutAttribute) -> CGFloat {
        let height = NSString(string: label.text!).sizeWithAttributes([ NSFontAttributeName: label.font]).height
        
        self.alertContainerView?.addConstraints([
            NSLayoutConstraint(
                item: label, attribute: .Top,
                    relatedBy: .Equal,
                toItem: alignToView, attribute: alignToAttribute,
                    multiplier: 1.0, constant: BFGAlertController.alertPadding
            ),
            NSLayoutConstraint(
                item: label, attribute: .Leading,
                    relatedBy: .Equal,
                toItem: self.alertContainerView!, attribute: .Leading,
                    multiplier: 1.0, constant: BFGAlertController.alertPadding
            ),
            NSLayoutConstraint(
                item: label, attribute: .Trailing,
                    relatedBy: .Equal,
                toItem: self.alertContainerView!, attribute: .Trailing,
                    multiplier: 1.0, constant: -BFGAlertController.alertPadding
            ),
            NSLayoutConstraint(
                item: label, attribute: .Height,
                    relatedBy: .Equal,
                toItem: nil, attribute: .NotAnAttribute,
                    multiplier: 1.0, constant: height
            )
        ])
        
        return height
    }
    
    private func addDivider() {
        self.alertDivider = UIView(frame: CGRect(x: 0, y: 0, width: BFGAlertController.alertWidth, height: BFGAlertController.dividerHeight))
        self.alertDivider?.backgroundColor = BFGAlertController.dividerColor
        self.alertDivider?.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.alertContainerView?.addSubview(self.alertDivider!)
        
        var alignTo = self.alertMessageLabel != nil ? self.alertMessageLabel : self.alertTitleLabel
        
        self.alertContainerView?.addConstraints([
            NSLayoutConstraint(
                item: self.alertDivider!, attribute: .Top,
                    relatedBy: .Equal,
                toItem: alignTo, attribute: .Bottom,
                    multiplier: 1.0, constant: BFGAlertController.alertPadding
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
                    multiplier: 1.0, constant: BFGAlertController.dividerHeight
            )
        ])
    }
    
    private func addButtons() {
        
    }
    
    private func alertHeight(#titleHeight: CGFloat, messageHeight: CGFloat, buttonHeight: CGFloat) -> CGFloat {
        var alertHeight = BFGAlertController.alertPadding * 2

        if self.alertTitle != nil { alertHeight += titleHeight }
        if self.alertMessage != nil { alertHeight += messageHeight }
        if self.alertTitle != nil && self.alertMessage != nil { alertHeight += BFGAlertController.alertPadding }
        
        alertHeight += BFGAlertController.dividerHeight
        alertHeight += BFGAlertController.buttonHeight // TODO: add buttons to height (for realz)
        
        return alertHeight
    }
}

// MARK: - Action Sheet
extension BFGAlertController {
    private func showActionSheet() {
        if let popover = self.popoverPresentationController {
            self.showActionSheetInPopover()
        }
        else {
            self.showActionSheetModally()
        }
    }
    
    private func showActionSheetModally() {
        self.addShade()
        // create the action sheet itself
    }
    
    private func showActionSheetInPopover() {
        // set up the popover and display the action sheet within
    }
}
