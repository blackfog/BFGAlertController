//
//  UIImage+Pixel.swift
//  TextTool2c
//
//  Created by Craig Pearlman on 2015-06-12.
//  Copyright (c) 2015 Black Fog Interactive. All rights reserved.
//

import UIKit

internal extension UIImage {
    internal class func pixelOfColor(color: UIColor) -> UIImage? {
        return self.pixelOfColor(color, alpha: 1.0)
    }
    
    internal class func pixelOfColor(color: UIColor, alpha: CGFloat) -> UIImage? {
        if color == UIColor.clearColor() { return nil }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), alpha == 1.0, 1.0)
        let imageRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextSetAlpha(context, alpha)
        CGContextFillRect(context, imageRect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
