//
//  AlertSideBySideView.swift
//
//  Created by Craig Pearlman on 2015-06-30.
//

import UIKit

// MARK: - Main
class AlertSideBySideView: UIView {
    // MARK: - Declarations
    
    var leftView     = UIView()
    var rightView    = UIView()
    var dividerColor = UIColor.grayColor()
    var dividerWidth = CGFloat(0.5)
    
    // MARK: - Private Declarations
    
    private var dividerView: UIView?
    
    // MARK: - Constructors
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(left: UIView, right: UIView) {
        self.init(frame: CGRect())

        self.leftView = left
        self.rightView = right
    }
    
    // MARK: - Lifecycle

    override func layoutSubviews() {
        self.insertDivider()
        self.insertLeftView()
        self.insertRightView()
        self.setNeedsLayout()
    }
}

// MARK: - Private
extension AlertSideBySideView {
    private func insertLeftView() {
        self.leftView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.leftView)
        
        self.addConstraints([
            NSLayoutConstraint(
                item: self.leftView, attribute: .Leading,
                    relatedBy: .Equal,
                toItem: self, attribute: .Leading,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.leftView, attribute: .Trailing,
                    relatedBy: .Equal,
                toItem: self.dividerView!, attribute: .Leading,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.leftView, attribute: .Top,
                    relatedBy: .Equal,
                toItem: self, attribute: .Top,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.leftView, attribute: .Bottom,
                    relatedBy: .Equal,
                toItem: self, attribute: .Bottom,
                    multiplier: 1.0, constant: 0.0
            )
        ])
    }
    
    private func insertRightView() {
        self.rightView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(self.rightView)
        
        self.addConstraints([
            NSLayoutConstraint(
                item: self.rightView, attribute: .Leading,
                    relatedBy: .Equal,
                toItem: self.dividerView!, attribute: .Trailing,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.rightView, attribute: .Trailing,
                    relatedBy: .Equal,
                toItem: self, attribute: .Trailing,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.rightView, attribute: .Top,
                    relatedBy: .Equal,
                toItem: self, attribute: .Top,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.rightView, attribute: .Bottom,
                    relatedBy: .Equal,
                toItem: self, attribute: .Bottom,
                    multiplier: 1.0, constant: 0.0
            )
        ])
    }
    
    private func insertDivider() {
        self.dividerView = UIView()
        self.dividerView?.translatesAutoresizingMaskIntoConstraints = false
        self.dividerView?.backgroundColor = self.dividerColor

        self.addSubview(self.dividerView!)
        
        self.addConstraints([
            NSLayoutConstraint(
                item: self.dividerView!, attribute: .CenterX,
                    relatedBy: .Equal,
                toItem: self, attribute: .CenterX,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.dividerView!, attribute: .CenterY,
                    relatedBy: .Equal,
                toItem: self, attribute: .CenterY,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.dividerView!, attribute: .Width,
                    relatedBy: .Equal,
                toItem: nil, attribute: .NotAnAttribute,
                    multiplier: 1.0, constant: self.dividerWidth
            ),
            NSLayoutConstraint(
                item: self.dividerView!, attribute: .Top,
                    relatedBy: .Equal,
                toItem: self, attribute: .Top,
                    multiplier: 1.0, constant: 0.0
            ),
            NSLayoutConstraint(
                item: self.dividerView!, attribute: .Bottom,
                    relatedBy: .Equal,
                toItem: self, attribute: .Bottom,
                    multiplier: 1.0, constant: 0.0
            )
        ])
    }
}
