//
//  AlertController.swift
//
//  Created by Craig Pearlman on 2015-06-29.
//

// TODO: for next major release, refactor how this object is put together
// TODO: if I put the title/message in their own container view, some logic gets much easier

import UIKit

// MARK: - Style Enum

@objc public enum AlertControllerStyle : Int {
    case actionSheet
    case alert
}

// MARK: - Main
public class AlertController: UIViewController {
    // MARK: - Public Declarations
    
    public var alertTitle: String?
    public var alertMessage: String?
    public var showing = false
    
    public var actions: [AlertAction] {
        return self.alertActions
    }
    
    public var textFields: [UITextField] {
        return self.alertFields
    }

    public var style           = AlertControllerStyle.alert
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
    var alertActions = [AlertAction]()
    var alertFields = [UITextField]()
    var alertFieldView: AlertSimpleStackView?

    // MARK: - Private Declarations
    
    private var buttonBackgroundColor = [
        Config<UIColor>(style: .`default`, state: .normal,      value: UIColor.clearColor()),
        Config<UIColor>(style: .`default`, state: .highlighted, value: UIColor.groupTableViewBackgroundColor()),
        Config<UIColor>(style: .cancel,    state: .normal,      value: UIColor.clearColor()),
        Config<UIColor>(style: .cancel,    state: .highlighted, value: UIColor.groupTableViewBackgroundColor())
    ]

    private var buttonTextColor = [
        Config<UIColor>(style: .`default`,   state: .normal, value: UIColor.blackColor()),
        Config<UIColor>(style: .destructive, state: .normal, value: UIColor.redColor())
    ]

    private var buttonFont = [
        Config<UIFont>(style: .`default`, state: .normal, value: UIFont.systemFontOfSize(14.0)),
        Config<UIFont>(style: .cancel,    state: .normal, value: UIFont.boldSystemFontOfSize(14.0))
    ]
    
    // MARK: - Constructors
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public convenience init(title: String?, message: String?, preferredStyle: AlertControllerStyle) {
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
    
    public func actionAtIndex(index: Int) -> AlertAction {
        return self.alertActions[index]
    }
    
    public func addAction(action: AlertAction) {
        self.alertActions.append(action)
    }
    
    public func addTextFieldWithConfigurationHandler(configurationHandler: ((UITextField!) -> Void)!) {
        assert(self.style != .actionSheet, "Text fields may only be added to alerts")
        
        let field = UITextField()
        configurationHandler(field)
        self.alertFields.append(field)
    }
}

// MARK: - Appearance
public extension AlertController {
    public func backgroundColor(forButtonStyle style: AlertActionStyle, state: AlertActionState) -> UIColor? {
        return ConfigHelper.configValue(from: self.buttonBackgroundColor, forButtonStyle: style, state: state)
    }
    
    public func setBackgroundColor(color: UIColor, forButtonStyle style: AlertActionStyle, state: AlertActionState) {
        ConfigHelper.setConfigValue(color, inArray: &self.buttonBackgroundColor, forButtonStyle: style, state: state)
    }

    public func textColor(forButtonStyle style: AlertActionStyle, state: AlertActionState) -> UIColor? {
        return ConfigHelper.configValue(from: self.buttonTextColor, forButtonStyle: style, state: state)
    }
    
    public func setTextColor(color: UIColor, forButtonStyle style: AlertActionStyle, state: AlertActionState) {
        ConfigHelper.setConfigValue(color, inArray: &self.buttonTextColor, forButtonStyle: style, state: state)
    }
    
    public func font(forButtonStyle style: AlertActionStyle, state: AlertActionState) -> UIFont? {
        return ConfigHelper.configValue(from: self.buttonFont, forButtonStyle: style, state: state)
    }
    
    public func setFont(font: UIFont, forButtonStyle style: AlertActionStyle, state: AlertActionState) {
        ConfigHelper.setConfigValue(font, inArray: &self.buttonFont, forButtonStyle: style, state: state)
    }
}

// MARK: - Button Appearance
extension AlertController {
    func attributedStringForButton(button: UIButton, style: AlertActionStyle, state: AlertActionState, controlState: UIControlState) -> NSAttributedString {
        return NSAttributedString(
            string: button.titleForState(controlState)!,
            attributes: [
                NSFontAttributeName: self.font(forButtonStyle: style, state: state) as! AnyObject,
                NSForegroundColorAttributeName: self.textColor(forButtonStyle: style, state: state) as! AnyObject
            ]
        )
    }
    
    func styleButton(button: UIButton, style: AlertActionStyle) {
        button.setAttributedTitle(self.attributedStringForButton(button, style: style, state: .normal, controlState: .Normal), forState: .Normal)
        button.setAttributedTitle(self.attributedStringForButton(button, style: style, state: .highlighted, controlState: .Highlighted), forState: .Highlighted)
        button.setAttributedTitle(self.attributedStringForButton(button, style: style, state: .disabled, controlState: .Disabled), forState: .Disabled)
        
        button.setBackgroundImage(UIImage.pixelOfColor(self.backgroundColor(forButtonStyle: style, state: .normal)!), forState: .Normal)
        button.setBackgroundImage(UIImage.pixelOfColor(self.backgroundColor(forButtonStyle: style, state: .highlighted)!), forState: .Highlighted)
        button.setBackgroundImage(UIImage.pixelOfColor(self.backgroundColor(forButtonStyle: style, state: .disabled)!), forState: .Disabled)
    }
}

// MARK: - Private/Internal
extension AlertController {
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
        
        if self.style == .alert {
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
            case .alert:
                self.showAlert()
            case .actionSheet:
                self.showActionSheet()
        }
    }
    
    private func hide() {
        if (self.showing) {
            self.showing = false
            
            if self.style == .alert {
                for id in self.keyboardNotifications {
                    NSNotificationCenter.defaultCenter().removeObserver(id)
                }
            }
            
            switch (self.style) {
                case .alert:
                    self.hideAlert()
                case .actionSheet:
                    self.hideActionSheet()
            }
        }
    }
}
