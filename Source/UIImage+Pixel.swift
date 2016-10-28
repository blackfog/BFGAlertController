//
//  UIImage+Pixel.swift
//
//  Created by Craig Pearlman on 2015-06-12.
//

import UIKit

internal extension UIImage {
    internal class func pixelOfColor(_ color: UIColor) -> UIImage? {
        return self.pixelOfColor(color, alpha: 1.0)
    }
    
    internal class func pixelOfColor(_ color: UIColor, alpha: CGFloat) -> UIImage? {
        if color == UIColor.clear { return nil }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), alpha == 1.0, 1.0)
        let imageRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.setAlpha(alpha)
        context?.fill(imageRect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
