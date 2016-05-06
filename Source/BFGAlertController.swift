//
//  BFGAlertController.swift
//  TextTool2c
//
//  Created by Craig Pearlman on 2015-06-29.
//  Copyright (c) 2015 Black Fog Interactive. All rights reserved.
//

// TODO: for next major release, refactor how this object is put together
// TODO: if I put the title/message in their own container view, some logic gets much easier

import UIKit

// MARK: - Style Enum

@objc public enum BFGAlertControllerStyle : Int {
    case ActionSheet
    case Alert
}

// MARK: - Main
public class BFGAlertController: UIViewController {
    // MARK: - Public Declarations
    
    public var alertTitle: String?
    public var alertMessage: String?
    public var showing = false
    
    public var actions: [BFGAlertAction] {
        return self.alertActions
    }
    
    public var textFields: [UITextField] {
        return self.alertFields
    }

    public var style           = BFGAlertControllerStyle.Alert
    public var backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.925)
    public var titleColor      = UIColor.blackColor()
    public var titleFont       = UIFont.boldSystemFontOfSize(16.0)
    public var messageColor    = UIColor.blackColor()
    public var messageFont     = UIFont.systemFontOfSize(14.0)
    public var shadeOpacity    = CGFloat(0.4)
    public var shadeColor      = UIColor.blackColor()
    public var cornerRadius    = CGFloat(12.0)
    public var dividerColor    = UIColor.blackColor().colorWithAlphaComponent(0.4)
    public var dividerSize     = CGFloat(0.5)
    public var alertWidth      = CGFloat(300.0)
    public var alertPadding    = CGFloat(16.0)
    public var buttonHeight    = CGFloat(44.0)

    // MARK: - Internal Declarations
    
    var shadeView: UIView?
    var alertContainerView: UIView?
    var alertContainerViewHeight: NSLayoutConstraint?
    var alertContainerViewBottom: NSLayoutConstraint?
    var alertContainerViewCenterY: NSLayoutConstraint?
    var keyboardNotifications = [NSObjectProtocol]()
    var alertTitleLabel: UILabel?
    var alertMessageLabel: UILabel?
    var alertDivider: UIView?
    var alertActionsContainerView: UIView?
    var alertActionsAltContainerView: UIView?
    var alertActions = [BFGAlertAction]()
    var alertFields = [UITextField]()
    var alertFieldView: BFGAlertSimpleStackView?

    // MARK: - Private Declarations
    
    private var buttonBackgroundColor = [
        BFGAlertConfig<UIColor>(style: .Default, state: .Normal,      value: UIColor.clearColor()),
        BFGAlertConfig<UIColor>(style: .Default, state: .Highlighted, value: UIColor.groupTableViewBackgroundColor()),
        BFGAlertConfig<UIColor>(style: .Cancel,  state: .Normal,      value: UIColor.clearColor()),
        BFGAlertConfig<UIColor>(style: .Cancel,  state: .Highlighted, value: UIColor.groupTableViewBackgroundColor())
    ]

    private var buttonTextColor = [
        BFGAlertConfig<UIColor>(style: .Default,     state: .Normal, value: UIColor.blackColor()),
        BFGAlertConfig<UIColor>(style: .Destructive, state: .Normal, value: UIColor.redColor())
    ]

    private var buttonFont = [
        BFGAlertConfig<UIFont>(style: .Default, state: .Normal, value: UIFont.systemFontOfSize(14.0)),
        BFGAlertConfig<UIFont>(style: .Cancel,  state: .Normal, value: UIFont.boldSystemFontOfSize(14.0))
    ]
    
    // MARK: - Constructors
    
    public required init?(coder aDecoder: NSCoder) {
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
        self.modalTransitionStyle = .CrossDissolve
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
        assert(self.style != .ActionSheet, "Text fields may only be added to alerts")
        
        let field = UITextField()
        configurationHandler(field)
        self.alertFields.append(field)
    }
}

// MARK: - Appearance
public extension BFGAlertController {
    public func backgroundColor(forButtonStyle style: BFGAlertActionStyle, state: BFGAlertActionState) -> UIColor? {
        return BFGAlertConfigHelper.configValue(from: self.buttonBackgroundColor, forButtonStyle: style, state: state)
    }
    
    public func setBackgroundColor(color: UIColor, forButtonStyle style: BFGAlertActionStyle, state: BFGAlertActionState) {
        BFGAlertConfigHelper.setConfigValue(color, inArray: &self.buttonBackgroundColor, forButtonStyle: style, state: state)
    }

    public func textColor(forButtonStyle style: BFGAlertActionStyle, state: BFGAlertActionState) -> UIColor? {
        return BFGAlertConfigHelper.configValue(from: self.buttonTextColor, forButtonStyle: style, state: state)
    }
    
    public func setTextColor(color: UIColor, forButtonStyle style: BFGAlertActionStyle, state: BFGAlertActionState) {
        BFGAlertConfigHelper.setConfigValue(color, inArray: &self.buttonTextColor, forButtonStyle: style, state: state)
    }
    
    public func font(forButtonStyle style: BFGAlertActionStyle, state: BFGAlertActionState) -> UIFont? {
        return BFGAlertConfigHelper.configValue(from: self.buttonFont, forButtonStyle: style, state: state)
    }
    
    public func setFont(font: UIFont, forButtonStyle style: BFGAlertActionStyle, state: BFGAlertActionState) {
        BFGAlertConfigHelper.setConfigValue(font, inArray: &self.buttonFont, forButtonStyle: style, state: state)
    }
}

// MARK: - Button Appearance
extension BFGAlertController {
    func attributedStringForButton(button: UIButton, style: BFGAlertActionStyle, state: BFGAlertActionState, controlState: UIControlState) -> NSAttributedString {
        return NSAttributedString(
            string: button.titleForState(controlState)!,
            attributes: [
                NSFontAttributeName: self.font(forButtonStyle: style, state: state) as! AnyObject,
                NSForegroundColorAttributeName: self.textColor(forButtonStyle: style, state: state) as! AnyObject
            ]
        )
    }
    
    func styleButton(button: UIButton, style: BFGAlertActionStyle) {
        button.setAttributedTitle(self.attributedStringForButton(button, style: style, state: .Normal, controlState: .Normal), forState: .Normal)
        button.setAttributedTitle(self.attributedStringForButton(button, style: style, state: .Highlighted, controlState: .Highlighted), forState: .Highlighted)
        button.setAttributedTitle(self.attributedStringForButton(button, style: style, state: .Disabled, controlState: .Disabled), forState: .Disabled)
        
        button.setBackgroundImage(UIImage.pixelOfColor(self.backgroundColor(forButtonStyle: style, state: .Normal)!), forState: .Normal)
        button.setBackgroundImage(UIImage.pixelOfColor(self.backgroundColor(forButtonStyle: style, state: .Highlighted)!), forState: .Highlighted)
        button.setBackgroundImage(UIImage.pixelOfColor(self.backgroundColor(forButtonStyle: style, state: .Disabled)!), forState: .Disabled)
    }
}

// MARK: - Private/Internal
extension BFGAlertController {
    func addShade() {
        self.shadeView = UIView(frame: UIScreen.mainScreen().bounds)
        self.shadeView?.backgroundColor = self.shadeColor.colorWithAlphaComponent(self.shadeOpacity)
        self.shadeView?.translatesAutoresizingMaskIntoConstraints = false

        self.view?.addSubview(self.shadeView!)

        self.view?.addConstraints([
            NSLayoutConstraint(
                item: self.shadeView!, attribute: .Top,
                    relatedBy: .Equal,
                toItem: self.view!, attribute: .Top,
                    multiplier: 1.0, constant: 0.0
            ),
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
    }
    
    private func show() {
        precondition(self.alertTitle != nil || self.alertMessage != nil, "One of alert title or message is required")
        
        self.showing = true
        
        if self.style == .Alert {
            self.keyboardNotifications.append(
                NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: NSOperationQueue.mainQueue()) { notification in
                    if let beginFrame = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.alertContainerViewCenterY?.constant = -(beginFrame.CGRectValue().size.height / 2)
                        }
                    }
                }
            )

            self.keyboardNotifications.append(
                NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardDidHideNotification, object: nil, queue: NSOperationQueue.mainQueue()) { notification in
                    self.alertContainerViewCenterY?.constant = 0
                }
            )
        }

        switch (self.style) {
            case .Alert:
                self.showAlert()
            case .ActionSheet:
                self.showActionSheet()
        }
    }
    
    private func hide() {
        if (self.showing) {
            self.showing = false
            
            if self.style == .Alert {
                for id in self.keyboardNotifications {
                    NSNotificationCenter.defaultCenter().removeObserver(id)
                }
            }
            
            switch (self.style) {
                case .Alert:
                    self.hideAlert()
                case .ActionSheet:
                    self.hideActionSheet()
            }
        }
    }
}