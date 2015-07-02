//
//  BFGAlertController.swift
//  TextTool2c
//
//  Created by Craig Pearlman on 2015-06-29.
//  Copyright (c) 2015 Black Fog Interactive. All rights reserved.
//

// TODO: think of ways to break down this (getting) massive class into subclasses

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
    
    var style: BFGAlertControllerStyle = .Alert
    var shadeView: UIView?
    var alertContainerView: UIView?
    var alertContainerViewHeight: NSLayoutConstraint?
    var alertTitleLabel: UILabel?
    var alertMessageLabel: UILabel?
    var alertDivider: UIView?
    var alertActionsContainerView: UIView?
    var alertActionsAltContainerView: UIView?
    var alertActions = [BFGAlertAction]()
    var alertFields = [UITextField]()
    
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
    public static var dividerSize     = CGFloat(0.5)
    
    // MARK: - Private Static Declarations
    
    private static var buttonBackgroundColor = [
        Config<UIColor>(style: .Default, state: .Normal,      value: UIColor.clearColor()),
        Config<UIColor>(style: .Default, state: .Highlighted, value: UIColor.groupTableViewBackgroundColor()),
        Config<UIColor>(style: .Cancel,  state: .Normal,      value: UIColor.clearColor()),
        Config<UIColor>(style: .Cancel,  state: .Highlighted, value: UIColor.groupTableViewBackgroundColor())
    ]

    private static var buttonTextColor = [
        Config<UIColor>(style: .Default,     state: .Normal, value: UIColor.blackColor()),
        Config<UIColor>(style: .Destructive, state: .Normal, value: UIColor.redColor())
    ]

    private static var buttonFont = [
        Config<UIFont>(style: .Default, state: .Normal, value: UIFont.systemFontOfSize(14.0)),
        Config<UIFont>(style: .Cancel,  state: .Normal, value: UIFont.boldSystemFontOfSize(14.0))
    ]
    
    static let alertWidth   = CGFloat(300.0)
    static let alertPadding = CGFloat(16.0)
    static let buttonHeight = CGFloat(40.0)
    
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
        return ConfigHelper.configValue(from: self.buttonBackgroundColor, forButtonStyle: style, state: state)
    }
    
    public class func setBackgroundColor(color: UIColor, forButtonStyle style: BFGAlertActionStyle, state: BFGAlertActionState) {
        ConfigHelper.setConfigValue(color, inArray: &self.buttonBackgroundColor, forButtonStyle: style, state: state)
    }

    public class func textColor(forButtonStyle style: BFGAlertActionStyle, state: BFGAlertActionState) -> UIColor? {
        return ConfigHelper.configValue(from: self.buttonTextColor, forButtonStyle: style, state: state)
    }
    
    public class func setTextColor(color: UIColor, forButtonStyle style: BFGAlertActionStyle, state: BFGAlertActionState) {
        ConfigHelper.setConfigValue(color, inArray: &self.buttonTextColor, forButtonStyle: style, state: state)
    }
    
    public class func font(forButtonStyle style: BFGAlertActionStyle, state: BFGAlertActionState) -> UIFont? {
        return ConfigHelper.configValue(from: self.buttonFont, forButtonStyle: style, state: state)
    }
    
    public class func setFont(font: UIFont, forButtonStyle style: BFGAlertActionStyle, state: BFGAlertActionState) {
        ConfigHelper.setConfigValue(font, inArray: &self.buttonFont, forButtonStyle: style, state: state)
    }
}

// MARK: - Private/Internal
extension BFGAlertController {
    func addShade() {
        self.shadeView = UIView(frame: UIScreen.mainScreen().bounds)
        self.shadeView?.backgroundColor = BFGAlertController.shadeColor.colorWithAlphaComponent(BFGAlertController.shadeOpacity)
        self.shadeView?.setTranslatesAutoresizingMaskIntoConstraints(false)

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
    }
    
    private func show() {
        precondition(self.alertTitle != nil || self.alertMessage != nil, "One of alert title or message is required")
        
        self.showing = true
        
        switch (self.style) {
            case .Alert:
                self.showAlert()
            case .ActionSheet:
                self.showActionSheet()
        }
    }
}
