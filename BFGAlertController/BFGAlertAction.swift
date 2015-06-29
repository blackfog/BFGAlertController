//
//  BFGAlertAction.swift
//  TextTool2c
//
//  Created by Craig Pearlman on 2015-06-29.
//  Copyright (c) 2015 Black Fog Interactive. All rights reserved.
//

import UIKit

enum BFGAlertActionStyle: Int {
    case Default
    case Cancel
    case Destructive
}

enum BFGAlertActionState: Int {
    case Normal
    case Highlighted
    case Disabled
}

class BFGAlertAction: NSObject {
    var actionTitle: String
    var actionStyle: BFGAlertActionStyle = .Default
    var enabled = true
    var handler: (UIAlertAction) -> Void
    
    var title: String {
        return self.actionTitle
    }
    
    var style: BFGAlertActionStyle {
        return self.actionStyle
    }
    
    init(title: String, style: BFGAlertActionStyle, handler: (UIAlertAction!) -> Void) {
        self.actionTitle = title
        self.actionStyle = style
        self.handler     = handler
        
        super.init()
    }
}
