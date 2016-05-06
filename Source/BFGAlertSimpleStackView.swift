//
//  BFGAlertSimpleStackView.swift
//  Pods
//
//  Created by Craig Pearlman on 2015-06-30.
//
//

import UIKit

// MARK: - Main
class BFGAlertSimpleStackView: UIView {
    // MARK: - Definitions
    
    var stackViews    = [UIView]()
    var viewHeight    = CGFloat(44.0)
    var viewHeights   = [CGFloat]()
    var dividerColor  = UIColor.grayColor()
    var dividerHeight = CGFloat(0.5)
    
    // MARK: - Constructors
    
    required init?(coder aDecoder: NSCoder) {
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
        
        for i in 0..<self.stackViews.count {
            let view = self.stackViews[i]
            
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
            
            let viewHeight = self.viewHeights.count > 0 && i <= self.viewHeights.endIndex ?
                self.viewHeights[i] : self.viewHeight
            
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
                        multiplier: 1.0, constant: viewHeight
                )
            ])
            
            if self.dividerHeight > 0 && i != self.stackViews.endIndex - 1 {
                let divider = UIView()
                divider.backgroundColor = self.dividerColor
                divider.translatesAutoresizingMaskIntoConstraints = false
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
            else {
                alignToView = view
                alignToAttribute = .Bottom
            }
        }

        self.setNeedsLayout()
    }
}
