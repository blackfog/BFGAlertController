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
    
    // MARK: - Private Static Declarations
    
    typealias ButtonBackgroundColorType = [BFGAlertActionStyle : [BFGAlertActionState : UIColor]]
    typealias ButtonTextColorType = [BFGAlertActionStyle : [BFGAlertActionState : UIColor]]
    typealias ButtonFontType = [BFGAlertActionStyle : [BFGAlertActionState : UIFont]]
    
    private static var buttonBackgroundColor: ButtonBackgroundColorType = [.Default : [.Normal : UIColor.whiteColor()]]
    private static var buttonTextColor: ButtonTextColorType = [.Default : [.Normal : UIColor.blackColor()]]
    private static var buttonFont: ButtonFontType = [.Default : [.Normal : UIFont.systemFontOfSize(14.0)]]
    
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

        self.view?.addConstraint(
            NSLayoutConstraint(
                item: self.shadeView!, attribute: .Bottom,
                    relatedBy: .Equal,
                toItem: self.view!, attribute: .Bottom,
                    multiplier: 1.0, constant: 0.0
            )
        )

        self.view?.addConstraint(
            NSLayoutConstraint(
                item: self.shadeView!, attribute: .Leading,
                    relatedBy: .Equal,
                toItem: self.view!, attribute: .Leading,
                    multiplier: 1.0, constant: 0.0)
        )

        self.view?.addConstraint(
            NSLayoutConstraint(
                item: self.shadeView!, attribute: .Trailing,
                    relatedBy: .Equal,
                toItem: self.view!, attribute: .Trailing,
                    multiplier: 1.0, constant: 0.0)
        )
        
        UIView.animateWithDuration(0.2) {
            self.shadeView?.alpha = 1.0
        }
    }
    
    private func show() {
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
        self.addShade()
        
        self.alertContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 150))
        
        self.alertContainerView?.backgroundColor = BFGAlertController.backgroundColor
        self.alertContainerView?.transform = CGAffineTransformMakeScale(0, 0)
        self.alertContainerView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.alertContainerView?.layer.cornerRadius = BFGAlertController.cornerRadius

        self.shadeView?.addSubview(self.alertContainerView!)
        
        self.shadeView?.addConstraint(
            NSLayoutConstraint(
                item: self.alertContainerView!, attribute: .CenterX,
                    relatedBy: .Equal,
                toItem: self.shadeView!, attribute: .CenterX,
                    multiplier: 1.0, constant: 1.0
            )
        )

        self.shadeView?.addConstraint(
            NSLayoutConstraint(
                item: self.alertContainerView!, attribute: .CenterY,
                    relatedBy: .Equal,
                toItem: self.shadeView!, attribute: .CenterY,
                    multiplier: 1.0, constant: 1.0
            )
        )
        
        self.alertContainerViewHeight = NSLayoutConstraint(
            item: self.alertContainerView!, attribute: .Height,
                relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute,
                multiplier: 1.0, constant: 150.0
        )
        
        self.shadeView?.addConstraint(self.alertContainerViewHeight!)

        self.shadeView?.addConstraint(
            NSLayoutConstraint(
                item: self.alertContainerView!, attribute: .Width,
                    relatedBy: .Equal,
                toItem: nil, attribute: .NotAnAttribute,
                    multiplier: 1.0, constant: 300.0
            )
        )
        
        UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.05,
            options: .CurveLinear, animations: {
                self.alertContainerView?.transform = CGAffineTransformMakeScale(1, 1)
            }, completion: nil)
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
