//
//  AlertAction.swift
//
//  Created by Craig Pearlman on 2015-06-29.
//

import UIKit

@objc public enum AlertActionStyle: Int {
    case `default`
    case cancel
    case destructive
}

@objc public enum AlertActionState: Int {
    case normal
    case highlighted
    case disabled
}

open class AlertAction: NSObject {
    open var actionTitle: String
    open var actionStyle: AlertActionStyle = .`default`
    open var enabled = true
    open var handler: (AlertAction) -> Void
    
    open var title: String {
        return self.actionTitle
    }
    
    open var style: AlertActionStyle {
        return self.actionStyle
    }
    
    public init(title: String, style: AlertActionStyle, handler: @escaping (AlertAction!) -> Void) {
        self.actionTitle = title
        self.actionStyle = style
        self.handler     = handler
        
        super.init()
    }
    
    open func button() -> UIButton {
        let button = UIButton()
        
        button.setTitle(self.actionTitle, for: UIControlState())
        button.addTarget(self, action: #selector(AlertAction.tapped), for: .touchUpInside)
        
        return button
    }
    
    open func tapped() {
        self.handler(self)
    }
}
