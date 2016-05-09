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

public class AlertAction: NSObject {
    public var actionTitle: String
    public var actionStyle: AlertActionStyle = .`default`
    public var enabled = true
    public var handler: (AlertAction) -> Void
    
    public var title: String {
        return self.actionTitle
    }
    
    public var style: AlertActionStyle {
        return self.actionStyle
    }
    
    public init(title: String, style: AlertActionStyle, handler: (AlertAction!) -> Void) {
        self.actionTitle = title
        self.actionStyle = style
        self.handler     = handler
        
        super.init()
    }
    
    public func button() -> UIButton {
        let button = UIButton()
        
        button.setTitle(self.actionTitle, forState: .Normal)
        button.addTarget(self, action: #selector(AlertAction.tapped), forControlEvents: .TouchUpInside)
        
        return button
    }
    
    public func tapped() {
        self.handler(self)
    }
}
