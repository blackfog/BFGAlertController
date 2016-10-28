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
open class AlertController: UIViewController {
    // MARK: - Public Declarations
    
    open var alertTitle: String?
    open var alertMessage: String?
    open var showing = false
    
    open var actions: [AlertAction] {
        return self.alertActions
    }
    
    open var textFields: [UITextField] {
        return self.alertFields
    }

    open var style           = AlertControllerStyle.alert
    open var backgroundColor = UIColor.white.withAlphaComponent(0.925)
    open var titleColor      = UIColor.black
    open var titleFont       = UIFont.boldSystemFont(ofSize: 16.0)
    open var messageColor    = UIColor.black
    open var messageFont     = UIFont.systemFont(ofSize: 14.0)
    open var shadeOpacity    = CGFloat(0.4)
    open var shadeColor      = UIColor.black
    open var cornerRadius    = CGFloat(12.0)
    open var dividerColor    = UIColor.black.withAlphaComponent(0.4)
    open var dividerSize     = CGFloat(0.5)
    open var alertWidth      = CGFloat(300.0)
    open var alertPadding    = CGFloat(16.0)
    open var buttonHeight    = CGFloat(44.0)

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
    
    fileprivate var buttonBackgroundColor = [
        Config<UIColor>(style: .`default`, state: .normal,      value: UIColor.clear),
        Config<UIColor>(style: .`default`, state: .highlighted, value: UIColor.groupTableViewBackground),
        Config<UIColor>(style: .cancel,    state: .normal,      value: UIColor.clear),
        Config<UIColor>(style: .cancel,    state: .highlighted, value: UIColor.groupTableViewBackground)
    ]

    fileprivate var buttonTextColor = [
        Config<UIColor>(style: .`default`,   state: .normal, value: UIColor.black),
        Config<UIColor>(style: .destructive, state: .normal, value: UIColor.red)
    ]

    fileprivate var buttonFont = [
        Config<UIFont>(style: .`default`, state: .normal, value: UIFont.systemFont(ofSize: 14.0)),
        Config<UIFont>(style: .cancel,    state: .normal, value: UIFont.boldSystemFont(ofSize: 14.0))
    ]
    
    // MARK: - Constructors
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public convenience init(title: String?, message: String?, preferredStyle: AlertControllerStyle) {
        self.init(nibName: nil, bundle: nil)

        self.alertTitle   = title
        self.alertMessage = message
        self.style        = preferredStyle
        
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    // MARK: - Lifecycle
    
    open override func viewDidLoad() {
        self.view = UIView()
        self.view?.backgroundColor = UIColor.clear
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.show()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hide()
    }
    
    // MARK: - Public
    
    open func actionAtIndex(_ index: Int) -> AlertAction {
        return self.alertActions[index]
    }
    
    open func addAction(_ action: AlertAction) {
        self.alertActions.append(action)
    }
    
    open func addTextFieldWithConfigurationHandler(_ configurationHandler: ((UITextField?) -> Void)!) {
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
    
    public func setBackgroundColor(_ color: UIColor, forButtonStyle style: AlertActionStyle, state: AlertActionState) {
        ConfigHelper.setConfigValue(color, inArray: &self.buttonBackgroundColor, forButtonStyle: style, state: state)
    }

    public func textColor(forButtonStyle style: AlertActionStyle, state: AlertActionState) -> UIColor? {
        return ConfigHelper.configValue(from: self.buttonTextColor, forButtonStyle: style, state: state)
    }
    
    public func setTextColor(_ color: UIColor, forButtonStyle style: AlertActionStyle, state: AlertActionState) {
        ConfigHelper.setConfigValue(color, inArray: &self.buttonTextColor, forButtonStyle: style, state: state)
    }
    
    public func font(forButtonStyle style: AlertActionStyle, state: AlertActionState) -> UIFont? {
        return ConfigHelper.configValue(from: self.buttonFont, forButtonStyle: style, state: state)
    }
    
    public func setFont(_ font: UIFont, forButtonStyle style: AlertActionStyle, state: AlertActionState) {
        ConfigHelper.setConfigValue(font, inArray: &self.buttonFont, forButtonStyle: style, state: state)
    }
}

// MARK: - Button Appearance
extension AlertController {
    func attributedStringForButton(_ button: UIButton, style: AlertActionStyle, state: AlertActionState, controlState: UIControlState) -> NSAttributedString {
        return NSAttributedString(
            string: button.title(for: controlState)!,
            attributes: [
                NSFontAttributeName: self.font(forButtonStyle: style, state: state) as AnyObject,
                NSForegroundColorAttributeName: self.textColor(forButtonStyle: style, state: state) as AnyObject
            ]
        )
    }
    
    func styleButton(_ button: UIButton, style: AlertActionStyle) {
        button.setAttributedTitle(self.attributedStringForButton(button, style: style, state: .normal, controlState: UIControlState()), for: UIControlState())
        button.setAttributedTitle(self.attributedStringForButton(button, style: style, state: .highlighted, controlState: .highlighted), for: .highlighted)
        button.setAttributedTitle(self.attributedStringForButton(button, style: style, state: .disabled, controlState: .disabled), for: .disabled)
        
        button.setBackgroundImage(UIImage.pixelOfColor(self.backgroundColor(forButtonStyle: style, state: .normal)!), for: UIControlState())
        button.setBackgroundImage(UIImage.pixelOfColor(self.backgroundColor(forButtonStyle: style, state: .highlighted)!), for: .highlighted)
        button.setBackgroundImage(UIImage.pixelOfColor(self.backgroundColor(forButtonStyle: style, state: .disabled)!), for: .disabled)
    }
}

// MARK: - Private/Internal
extension AlertController {
    func addShade() {
        self.shadeView = UIView(frame: UIScreen.main.bounds)
        self.shadeView?.backgroundColor = self.shadeColor.withAlphaComponent(self.shadeOpacity)
        self.shadeView?.translatesAutoresizingMaskIntoConstraints = false

        self.view?.addSubview(self.shadeView!)

        self.view?.addConstraints([
            NSLayoutConstraint(
                item: self.shadeView!, attribute: .top,
                    relatedBy: .equal,
                toItem: self.view!, attribute: .top,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.shadeView!, attribute: .bottom,
                    relatedBy: .equal,
                toItem: self.view!, attribute: .bottom,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.shadeView!, attribute: .leading,
                    relatedBy: .equal,
                toItem: self.view!, attribute: .leading,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.shadeView!, attribute: .trailing,
                    relatedBy: .equal,
                toItem: self.view!, attribute: .trailing,
                    multiplier: 1.0, constant: 0.0
            )
        ])
    }
    
    fileprivate func show() {
        precondition(self.alertTitle != nil || self.alertMessage != nil, "One of alert title or message is required")
        
        self.showing = true
        
        if self.style == .alert {
            self.keyboardNotifications.append(
                NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { notification in
                    if let beginFrame = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue {
                        DispatchQueue.main.async {
                            self.alertContainerViewCenterY?.constant = -(beginFrame.cgRectValue.size.height / 2)
                        }
                    }
                }
            )

            self.keyboardNotifications.append(
                NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardDidHide, object: nil, queue: OperationQueue.main) { notification in
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
    
    fileprivate func hide() {
        if (self.showing) {
            self.showing = false
            
            if self.style == .alert {
                for id in self.keyboardNotifications {
                    NotificationCenter.default.removeObserver(id)
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
