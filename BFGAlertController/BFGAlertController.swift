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

public enum BFGAlertControllerStyle : Int {
    case ActionSheet
    case Alert
}

// MARK: - Main
@objc public class BFGAlertController: UIViewController {
    // MARK: - Public Declarations
    
    public var alertTitle: String?
    public var alertMessage: String?
    public var showing = false
    public var containerView: UIView?
    
    public var actions: [BFGAlertAction] {
        return self.alertActions
    }
    
    public var textFields: [UITextField] {
        return self.alertFields
    }
    
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
    
    var style: BFGAlertControllerStyle = .Alert
    var shadeView: UIView?
    var shadeViewBottom: NSLayoutConstraint?
    var keyboardNotifications = [NSObjectProtocol]()
    var alertContainerView: UIView?
    var alertContainerViewHeight: NSLayoutConstraint?
    var alertContainerViewBottom: NSLayoutConstraint?
    var alertTitleLabel: UILabel?
    var alertMessageLabel: UILabel?
    var alertDivider: UIView?
    var alertActionsContainerView: UIView?
    var alertActionsAltContainerView: UIView?
    var alertActions = [BFGAlertAction]()
    var alertFields = [UITextField]()
    var alertFieldView: SimpleStackView?

    // MARK: - Private Declarations
    
    private var buttonBackgroundColor = [
        Config<UIColor>(style: .Default, state: .Normal,      value: UIColor.clearColor()),
        Config<UIColor>(style: .Default, state: .Highlighted, value: UIColor.groupTableViewBackgroundColor()),
        Config<UIColor>(style: .Cancel,  state: .Normal,      value: UIColor.clearColor()),
        Config<UIColor>(style: .Cancel,  state: .Highlighted, value: UIColor.groupTableViewBackgroundColor())
    ]

    private var buttonTextColor = [
        Config<UIColor>(style: .Default,     state: .Normal, value: UIColor.blackColor()),
        Config<UIColor>(style: .Destructive, state: .Normal, value: UIColor.redColor())
    ]

    private var buttonFont = [
        Config<UIFont>(style: .Default, state: .Normal, value: UIFont.systemFontOfSize(14.0)),
        Config<UIFont>(style: .Cancel,  state: .Normal, value: UIFont.boldSystemFontOfSize(14.0))
    ]
    
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

// FIXME: Some of the config fallbacks don't work right; but, setting explicitly works fine
// MARK: - Appearance
public extension BFGAlertController {
    public func backgroundColor(forButtonStyle style: BFGAlertActionStyle, state: BFGAlertActionState) -> UIColor? {
        return ConfigHelper.configValue(from: self.buttonBackgroundColor, forButtonStyle: style, state: state)
    }
    
    public func setBackgroundColor(color: UIColor, forButtonStyle style: BFGAlertActionStyle, state: BFGAlertActionState) {
        ConfigHelper.setConfigValue(color, inArray: &self.buttonBackgroundColor, forButtonStyle: style, state: state)
    }

    public func textColor(forButtonStyle style: BFGAlertActionStyle, state: BFGAlertActionState) -> UIColor? {
        return ConfigHelper.configValue(from: self.buttonTextColor, forButtonStyle: style, state: state)
    }
    
    public func setTextColor(color: UIColor, forButtonStyle style: BFGAlertActionStyle, state: BFGAlertActionState) {
        ConfigHelper.setConfigValue(color, inArray: &self.buttonTextColor, forButtonStyle: style, state: state)
    }
    
    public func font(forButtonStyle style: BFGAlertActionStyle, state: BFGAlertActionState) -> UIFont? {
        return ConfigHelper.configValue(from: self.buttonFont, forButtonStyle: style, state: state)
    }
    
    public func setFont(font: UIFont, forButtonStyle style: BFGAlertActionStyle, state: BFGAlertActionState) {
        ConfigHelper.setConfigValue(font, inArray: &self.buttonFont, forButtonStyle: style, state: state)
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
        self.shadeView?.setTranslatesAutoresizingMaskIntoConstraints(false)

        self.view?.addSubview(self.shadeView!)

        self.shadeViewBottom = NSLayoutConstraint(
            item: self.shadeView!, attribute: .Bottom,
                relatedBy: .Equal,
            toItem: self.view!, attribute: .Bottom,
                multiplier: 1.0, constant: 0.0
        )

        self.view?.addConstraints([
            NSLayoutConstraint(
                item: self.shadeView!, attribute: .Top,
                    relatedBy: .Equal,
                toItem: self.view!, attribute: .Top,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.shadeView!, attribute: .Leading,
                    relatedBy: .Equal,
                toItem: self.view!, attribute: .Leading,
                    multiplier: 1.0, constant: 0.0
            ),
            self.shadeViewBottom!,
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
        
        self.keyboardNotifications.append(NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardDidShowNotification, object: nil, queue: NSOperationQueue.mainQueue()) { notification in
            if let notification = notification, beginFrame = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue {
                dispatch_async(dispatch_get_main_queue()) {
                    self.shadeViewBottom?.constant = -(beginFrame.CGRectValue().size.height * 0.75)
                }
            }
        })

        // FIXME: on rotation, this "hops" because they keyboard event fires (one hide, one show) and resizes things
        // FIXME: if a field doesn't have the quick completion bar thing, this doesn't work right (shows through) -- fixed that, but now if the bar shows or not changes the position of the view as you flip between fields (grr)
        // FIXME: consider bringing back BFGAlertField as a wrapper around UITextField so I can have control over the field using blocks rather than configuring with delegates
        self.keyboardNotifications.append(NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardDidHideNotification, object: nil, queue: NSOperationQueue.mainQueue()) { notification in
            self.shadeViewBottom?.constant = 0
        })

        switch (self.style) {
            case .Alert:
                self.showAlert()
            case .ActionSheet:
                self.showActionSheet()
        }
    }
    
    private func hide() {
        if (self.showing) {
            for id in self.keyboardNotifications {
                NSNotificationCenter.defaultCenter().removeObserver(id)
            }
            
            switch (self.style) {
                case .Alert:
                    break
                case .ActionSheet:
                    self.hideActionSheet()
            }
        }
    }
}
