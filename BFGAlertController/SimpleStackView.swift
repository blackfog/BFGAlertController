//
//  SimpleStackView.swift
//  Pods
//
//  Created by Craig Pearlman on 2015-06-30.
//
//

import UIKit

// MARK: - Main
class SimpleStackView: UIView {
    // MARK: - Definitions
    
    var stackViews    = [UIView]()
    var viewHeight    = CGFloat(40.0)
    var dividerColor  = UIColor.grayColor()
    var dividerHeight = CGFloat(0.5)
    
    // MARK: - Constructors
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(views: [UIView]) {
        assert(views.count > 0, "There are no views to stack")
        
        self.init(frame: CGRect())
        self.stackViews = views
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        var alignToView: UIView = self
        var alignToAttribute: NSLayoutAttribute = .Top
        
        for view in self.stackViews {
            view.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.addSubview(view)
            
            self.addConstraints([
                NSLayoutConstraint(
                    item: view, attribute: .Top,
                        relatedBy: .Equal,
                    toItem: alignToView, attribute: alignToAttribute,
                        multiplier: 1.0, constant: 0.0
                ),
                NSLayoutConstraint(
                    item: view, attribute: .Leading,
                        relatedBy: .Equal,
                    toItem: self, attribute: .Leading,
                        multiplier: 1.0, constant: 0.0
                ),
                NSLayoutConstraint(
                    item: view, attribute: .Trailing,
                        relatedBy: .Equal,
                    toItem: self, attribute: .Trailing,
                        multiplier: 1.0, constant: 0.0
                ),
                NSLayoutConstraint(
                    item: view, attribute: .Height,
                        relatedBy: .Equal,
                    toItem: nil, attribute: .NotAnAttribute,
                        multiplier: 1.0, constant: self.viewHeight
                )
            ])
            
            // TODO: suppress the final divider
            let divider = UIView()
            divider.backgroundColor = self.dividerColor
            divider.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.addSubview(divider)
            
            self.addConstraints([
                NSLayoutConstraint(
                    item: divider, attribute: .Top,
                        relatedBy: .Equal,
                    toItem: view, attribute: .Bottom,
                        multiplier: 1.0, constant: 0.0
                ),
                NSLayoutConstraint(
                    item: divider, attribute: .Leading,
                        relatedBy: .Equal,
                    toItem: self, attribute: .Leading,
                        multiplier: 1.0, constant: 0.0
                ),
                NSLayoutConstraint(
                    item: divider, attribute: .Trailing,
                        relatedBy: .Equal,
                    toItem: self, attribute: .Trailing,
                        multiplier: 1.0, constant: 0.0
                ),
                NSLayoutConstraint(
                    item: divider, attribute: .Height,
                        relatedBy: .Equal,
                    toItem: nil, attribute: .NotAnAttribute,
                        multiplier: 1.0, constant: self.dividerHeight
                )
            ])
            
            alignToView = divider
            alignToAttribute = .Bottom
        }
        
        self.setNeedsLayout()
    }
}

// MARK: - Private
extension SimpleStackView {

}