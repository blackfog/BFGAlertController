//
//  AlertSimpleStackView.swift
//
//  Created by Craig Pearlman on 2015-06-30.
//

import UIKit

// MARK: - Main
class AlertSimpleStackView: UIView {
    // MARK: - Definitions
    
    var stackViews    = [UIView]()
    var viewHeight    = CGFloat(44.0)
    var viewHeights   = [CGFloat]()
    var dividerColor  = UIColor.gray
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
        var alignToAttribute: NSLayoutAttribute = .top
        
        for i in 0..<self.stackViews.count {
            let view = self.stackViews[i]
            
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
            
            let viewHeight = self.viewHeights.count > 0 && i <= self.viewHeights.endIndex ?
                self.viewHeights[i] : self.viewHeight
            
            self.addConstraints([
                NSLayoutConstraint(
                    item: view, attribute: .top,
                        relatedBy: .equal,
                    toItem: alignToView, attribute: alignToAttribute,
                        multiplier: 1.0, constant: 0.0
                ),
                NSLayoutConstraint(
                    item: view, attribute: .leading,
                        relatedBy: .equal,
                    toItem: self, attribute: .leading,
                        multiplier: 1.0, constant: 0.0
                ),
                NSLayoutConstraint(
                    item: view, attribute: .trailing,
                        relatedBy: .equal,
                    toItem: self, attribute: .trailing,
                        multiplier: 1.0, constant: 0.0
                ),
                NSLayoutConstraint(
                    item: view, attribute: .height,
                        relatedBy: .equal,
                    toItem: nil, attribute: .notAnAttribute,
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
                        item: divider, attribute: .top,
                            relatedBy: .equal,
                        toItem: view, attribute: .bottom,
                            multiplier: 1.0, constant: 0.0
                    ),
                    NSLayoutConstraint(
                        item: divider, attribute: .leading,
                            relatedBy: .equal,
                        toItem: self, attribute: .leading,
                            multiplier: 1.0, constant: 0.0
                    ),
                    NSLayoutConstraint(
                        item: divider, attribute: .trailing,
                            relatedBy: .equal,
                        toItem: self, attribute: .trailing,
                            multiplier: 1.0, constant: 0.0
                    ),
                    NSLayoutConstraint(
                        item: divider, attribute: .height,
                            relatedBy: .equal,
                        toItem: nil, attribute: .notAnAttribute,
                            multiplier: 1.0, constant: self.dividerHeight
                    )
                ])
                
                alignToView = divider
                alignToAttribute = .bottom
            }
            else {
                alignToView = view
                alignToAttribute = .bottom
            }
        }

        self.setNeedsLayout()
    }
}
