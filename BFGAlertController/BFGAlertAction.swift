//
//  BFGAlertAction.swift
//  TextTool2c
//
//  Created by Craig Pearlman on 2015-06-29.
//  Copyright (c) 2015 Black Fog Interactive. All rights reserved.
//

import UIKit

@objc public enum BFGAlertActionStyle: Int {
    case Default
    case Cancel
    case Destructive
}

@objc public enum BFGAlertActionState: Int {
    case Normal
    case Highlighted
    case Disabled
}

public class BFGAlertAction: NSObject {
    public typealias ActionHandler = (BFGAlertAction) -> Void
    
    public var actionTitle: String
    public var actionStyle: BFGAlertActionStyle = .Default
    public var enabled = true
    public var handler: ActionHandler?
    
    public var title: String {
        return self.actionTitle
    }
    
    public var style: BFGAlertActionStyle {
        return self.actionStyle
    }
    
    public init(title: String, style: BFGAlertActionStyle, handler: ActionHandler?) {
        self.actionTitle = title
        self.actionStyle = style
        self.handler     = handler
        
        super.init()
    }
    
    internal func button() -> UIButton {
        let button = UIButton()
        
        button.setTitle(self.actionTitle, forState: .Normal)
        button.addTarget(self, action: #selector(tapped), forControlEvents: .TouchUpInside)
        
        return button
    }
    
    @objc private func tapped() {
        self.handler?(self)
    }
}
