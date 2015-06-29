//
//  BFGAlertController.swift
//  TextTool2c
//
//  Created by Craig Pearlman on 2015-06-29.
//  Copyright (c) 2015 Black Fog Interactive. All rights reserved.
//

import UIKit

// MARK: - Style Enum

enum BFGAlertControllerStyle : Int {
    case ActionSheet
    case Alert
}

// MARK: - Main
class BFGAlertController: UIViewController {
    // MARK: - Declarations
    
    var alertTitle: String?
    var alertMessage: String?
    var showing = false
    
    // MARK: - Private Declarations
    
    private var style: BFGAlertControllerStyle = .Alert
    private var shadeView: UIView?
    private var alertContainerView: UIView?
    private var alertTitleLabel: UILabel?
    private var alertMessageLabel: UILabel?
    private var alertActionCollectionView = UICollectionView()
    private var alertActions = [BFGAlertAction]()
    private var alertFields = [UITextField]()
    
    var actions: [BFGAlertAction] {
        return self.alertActions
    }
    
    var textFields: [UITextField] {
        return self.alertFields
    }
    
    // MARK: - Constructors
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(title: String?, message: String?, preferredStyle: BFGAlertControllerStyle) {
        self.init(nibName: nil, bundle: nil)

        self.alertTitle   = title
        self.alertMessage = message
        self.style        = preferredStyle
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
//        <#code#>
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.show()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.hide()
    }
    
    // MARK: - Public
    
    func actionAtIndex(index: Int) -> BFGAlertAction {
        return self.alertActions[index]
    }
    
    func addAction(action: BFGAlertAction) {
        self.alertActions.append(action)
    }
    
    func addTextFieldWithConfigurationHandler(configurationHandler: ((UITextField!) -> Void)!) {
        let field = UITextField()
        configurationHandler(field)
        self.alertFields.append(field)
    }
}

// MARK: - Appearance
extension BFGAlertController {
    // MARK: - Static Declarations
    
    static var backgroundColor = UIColor.whiteColor()
    static var titleColor      = UIColor.blackColor()
    static var titleFont       = UIFont.boldSystemFontOfSize(16.0)
    static var messageColor    = UIColor.blackColor()
    static var messageFont     = UIFont.systemFontOfSize(14.0)
    static var shadeOpacity    = 0.5
    static var shadeColor      = UIColor.blackColor()
    static var cornerRadius    = 6.0
    
    // MARK: - Private Static Declarations
    
    private static var buttonBackgroundColor: [BFGAlertActionStyle : [BFGAlertActionState : UIColor]] = [.Default : [.Normal : UIColor.whiteColor()]]
    private static var buttonTextColor: [BFGAlertActionStyle : [BFGAlertActionState : UIColor]] = [.Default : [.Normal : UIColor.blackColor()]]
    private static var buttonFont: [BFGAlertActionStyle : [BFGAlertActionState : UIFont]] = [.Default : [.Normal : UIFont.systemFontOfSize(14.0)]]

    // MARK: - Class Methods
    
    class func backgroundColor(forButtonStyle style: BFGAlertActionStyle, state: BFGAlertActionState) -> UIColor? {
        if let styleProps = self.buttonBackgroundColor[style], color = styleProps[state] {
            return color
        }
        
        if let styleProps = self.buttonBackgroundColor[.Default], color = styleProps[.Normal] {
            return color
        }
        
        return nil
    }
    
    class func setBackgroundColor(color: UIColor, forButtonStyle style: BFGAlertActionStyle, state: BFGAlertActionState) {
        self.buttonBackgroundColor[style] = [state : color]
    }

    class func textColor(forButtonStyle style: BFGAlertActionStyle, state: BFGAlertActionState) -> UIColor? {
        if let styleProps = self.buttonTextColor[style], color = styleProps[state] {
            return color
        }
        
        if let styleProps = self.buttonTextColor[.Default], color = styleProps[.Normal] {
            return color
        }
        
        return nil
    }
    
    class func setTextColor(color: UIColor, forButtonStyle style: BFGAlertActionStyle, state: BFGAlertActionState) {
        self.buttonTextColor[style] = [state: color]
    }

    class func font(forButtonStyle style: BFGAlertActionStyle, state: BFGAlertActionState) -> UIFont? {
        if let styleProps = self.buttonFont[style], font = styleProps[state] {
            return font
        }

        if let styleProps = self.buttonFont[.Default], font = styleProps[.Normal] {
            return font
        }
        
        return nil
    }
    
    class func setFont(font: UIFont, forButtonStyle style: BFGAlertActionStyle, state: BFGAlertActionState) {
        self.buttonFont[style] = [state: font]
    }
}

// MARK: - Private
extension BFGAlertController {
    private func show() {
        
    }
    
    private func hide() {
        
    }
}
